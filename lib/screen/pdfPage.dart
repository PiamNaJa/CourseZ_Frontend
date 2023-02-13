import 'package:coursez/utils/color.dart';
import 'package:coursez/view_model/pdf_view_model.dart';
import 'package:get/get.dart';
import 'package:coursez/widgets/text/heading2_20px.dart';
import 'package:flutter/material.dart';
import 'package:pdf_render/pdf_render_widgets.dart';

class PDFPage extends StatelessWidget {
  final String path;
  const PDFPage({super.key, required this.path});
  

  @override
  Widget build(BuildContext context) {
    
    final String name = path.split('/').last;
    final pdfFile =  PDFViewModel().getPdfBytes(path);
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          title: Heading20px(text: name),
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
              Icons.bookmark,
              color: Colors.white,
              semanticLabel: 'Bookmark',
            ),
            onPressed: () {
            },
          ),
        ],
        ),
        body: PdfViewer.openFutureData((() => pdfFile),)
    );
  }
}
