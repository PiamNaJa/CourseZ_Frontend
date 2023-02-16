import 'dart:isolate';
import 'dart:ui';

import 'package:coursez/utils/color.dart';
import 'package:coursez/view_model/pdf_view_model.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:pdf_render/pdf_render_widgets.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';

class PDFPage extends StatefulWidget {
  final String path;
  final String name;
  const PDFPage({super.key, required this.path, required this.name});

  @override
  State<PDFPage> createState() => _PDFPageState();
}

class _PDFPageState extends State<PDFPage> {
  final ReceivePort _port = ReceivePort();
  double progess = 0.0;
  static downloadingcallback(id, status, progress) {
    SendPort? sendPort = IsolateNameServer.lookupPortByName('downloading');
    sendPort?.send([id, status, progress]);
  }

  @override
  void initState() {
    IsolateNameServer.registerPortWithName(_port.sendPort, 'downloading');
    _port.listen((message) {
      setState(() {
        progess = message[2].toDouble();
      });
    });
    FlutterDownloader.registerCallback(downloadingcallback);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final pdfFile = PDFViewModel().getPdfBytes(widget.path);
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          title: Text(widget.name,
              style: const TextStyle(
                fontFamily: 'Athiti',
                color: blackColor,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              )),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(0),
            child: LinearProgressIndicator(
              value: progess,
              backgroundColor: Colors.grey[200],
              valueColor: const AlwaysStoppedAnimation<Color>(primaryColor),
            ),
          ),
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: primaryColor),
            onPressed: () {
              Get.back();
            },
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.download_rounded,
                color: blackColor,
                semanticLabel: 'Download',
              ),
              onPressed: () async {
                final status = await Permission.storage.status;
                debugPrint(status.toString());
                if (status.isGranted) {
                  final externalDir = await getExternalStorageDirectory();
                  Map<Permission, PermissionStatus> statuses = await [
                    Permission.storage,
                  ].request();
                  FlutterDownloader.enqueue(
                    url: widget.path,
                    savedDir: externalDir!.path,
                    showNotification:
                        true, // show download progress in status bar (for Android)
                    openFileFromNotification:
                        true, // click on notification to open downloaded file (for Android)
                  ).then((value) => null);
                } else {
                  Get.defaultDialog(
                    title: 'Permission denied',
                    middleText: 'Please allow storage permission',
                    textConfirm: 'OK',
                    onConfirm: () {
                      Get.back();
                    },
                  );
                  debugPrint('Permission denied');
                }
              },
            ),
          ],
        ),
        body: PdfViewer.openFutureData(
          (() => pdfFile),
        ));
  }
}
