import 'dart:io';

import 'package:coursez/model/video.dart';
import 'package:coursez/utils/color.dart';
import 'package:coursez/utils/inputDecoration.dart';
import 'package:coursez/view_model/video_view_model.dart';
import 'package:coursez/widgets/button/button.dart';
import 'package:coursez/widgets/text/body10px.dart';
import 'package:coursez/widgets/text/body12px.dart';
import 'package:coursez/widgets/text/body14px.dart';
import 'package:coursez/widgets/text/body16.dart';
import 'package:coursez/widgets/text/heading1_24px.dart';
import 'package:coursez/widgets/text/heading2_20px.dart';
import 'package:coursez/widgets/text/title16px.dart';
import 'package:coursez/widgets/textField/Textformfield.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class EditVideoPage extends StatefulWidget {
  const EditVideoPage({super.key});

  @override
  State<EditVideoPage> createState() => _EditVideoPageState();
}

class _EditVideoPageState extends State<EditVideoPage> {
  final VideoViewModel videoViewModel = VideoViewModel();
  final _formKey = GlobalKey<FormState>();
  final video = Get.arguments;
  File? coverImage, videoFile, pdfFile;
  PlatformFile? _platformVideoFile, _platformPdfFile;

  onSubmit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      videoViewModel.updateVideo(video, coverImage, videoFile, pdfFile);
    }
  }

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);

      if (image == null) return;

      final imageTemp = File(image.path);

      return imageTemp;
    } on PlatformException catch (e) {
      debugPrint("Fail to pick image : $e");
    }
  }

  Future selectVideoFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['mp4', 'mov', 'avi', 'flv', 'wmv', 'mkv', 'webm'],
      );

      if (result == null) return;

      final String? fileType = result.files.single.extension;
      final file = result.files.single;

      if (fileType == 'mp4' ||
          fileType == 'mov' ||
          fileType == 'avi' ||
          fileType == 'flv' ||
          fileType == 'wmv' ||
          fileType == 'mkv' ||
          fileType == 'webm') {
        return file;
      } else {
        Get.snackbar('ผิดพลาด', 'กรุณาเลือกไฟล์วิดีโอ',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: whiteColor);
      }
    } on PlatformException catch (e) {
      debugPrint("Fail to pick video : $e");
    }
  }

  Future selectPdfFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result == null) return;

      final String? fileType = result.files.single.extension;
      final file = result.files.single;

      if (fileType != 'pdf') {
        Get.snackbar('ผิดพลาด', 'กรุณาเลือกไฟล์ PDF',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: whiteColor);
        return;
      }
      return file;
    } on PlatformException catch (e) {
      debugPrint("Fail to pick PDF : $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        titleSpacing: 0.0,
        title: const Heading24px(text: 'แก้ไขวิดีโอ'),
        backgroundColor: whiteColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: primaryColor),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: SingleChildScrollView(child: videoDetail(video)),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(width: 1, color: primaryDarkColor),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Bt(
              text: "ยืนยัน",
              color: primaryColor,
              onPressed: (() {
                showDialog(
                    context: context,
                    builder: ((context) {
                      return AlertDialog(
                        title: const Heading20px(
                            text: 'ยืนยันการสร้างคอร์สและวิดีโอ'),
                        content: const Body16px(
                            text: 'กรุณาตรวจสอบข้อมูลให้ถูกต้อง'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Get.back();
                            },
                            child: const Body16px(
                              text: 'ยกเลิก',
                              color: Colors.red,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Get.back();
                              onSubmit();
                            },
                            child: const Title16px(
                              text: 'ยืนยัน',
                              color: primaryColor,
                            ),
                          ),
                        ],
                      );
                    }));
              }),
            ),
          ],
        ),
      ),
    );
  }

  videoDetail(Video video) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Heading20px(text: 'ภาพหน้าปก'),
            ),
            coverImage != null
                ? Stack(
                    alignment: AlignmentDirectional.topEnd,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Center(
                          child: Image.file(
                            coverImage!,
                            height: 250,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 50,
                        child: RawMaterialButton(
                          onPressed: () {
                            pickImage().then((value) => setState(() {
                                  coverImage = value;
                                }));
                          },
                          elevation: 2.0,
                          fillColor: primaryColor,
                          padding: const EdgeInsets.all(15),
                          shape: const CircleBorder(),
                          child: const Icon(
                            color: Colors.white,
                            Icons.edit,
                            size: 25,
                          ),
                        ),
                      ),
                    ],
                  )
                : Stack(
                    alignment: AlignmentDirectional.topEnd,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Image.network(
                          video.picture,
                          height: 250,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(
                        width: 50,
                        child: RawMaterialButton(
                          onPressed: () {
                            pickImage().then((value) => setState(() {
                                  coverImage = value;
                                }));
                          },
                          elevation: 2.0,
                          fillColor: primaryColor,
                          padding: const EdgeInsets.all(15),
                          shape: const CircleBorder(),
                          child: const Icon(
                            color: Colors.white,
                            Icons.edit,
                            size: 25,
                          ),
                        ),
                      ),
                    ],
                  ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Heading20px(text: 'เลือกวิดีโอที่ท่านต้องการจะเปลี่ยน'),
                  Text(
                    'กรุณาเลือกไฟล์วิดีโอเมื่อท่านต้องการเปลี่ยนเท่านั้น',
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  )
                ],
              ),
            ),
            _platformVideoFile != null
                ? Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: greyColor.withOpacity(0.5)),
                    ),
                    child: ListTile(
                      leading:
                          const Icon(Icons.video_collection_outlined, size: 40),
                      title: Body14px(text: _platformVideoFile!.name),
                      subtitle: Body14px(
                          text:
                              '${(_platformVideoFile!.size * 0.000001).toPrecision(2)} MB'),
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('ลบไฟล์'),
                              content:
                                  const Text('คุณต้องการลบไฟล์นี้ใช่หรือไม่?'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Get.back();
                                  },
                                  child: const Body14px(text: 'ยกเลิก'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Get.back();
                                    setState(() {
                                      _platformVideoFile = null;
                                      videoFile = null;
                                    });
                                  },
                                  child: const Body14px(
                                      text: 'ลบ', color: Colors.red),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  )
                : InkWell(
                    onTap: () {
                      selectVideoFile().then((value) => setState(() {
                            _platformVideoFile = value;
                            videoFile = File(value!.path);
                          }));
                    },
                    child: DottedBorder(
                      borderType: BorderType.RRect,
                      radius: const Radius.circular(10),
                      dashPattern: const [10, 4],
                      strokeCap: StrokeCap.round,
                      color: primaryColor,
                      child: Container(
                        width: double.infinity,
                        height: 150,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: primaryLighterColor.withOpacity(0.3)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(
                              Icons.video_collection_outlined,
                              size: 40,
                              color: primaryColor,
                            ),
                            SizedBox(height: 8),
                            Body14px(
                              text: 'คลิกเพื่อเลือกวิดีโอ',
                              color: greyColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Heading20px(text: 'ชื่อวิดีโอ'),
            ),
            CustomTextForm(
              title: 'ชื่อวิดีโอ',
              initialValue: video.videoName,
              onChanged: (String value) {
                video.videoName = value;
              },
              validator: (String? value) {
                if (value == null || value.trim().isEmpty) {
                  return 'กรุณากรอกชื่อวิดีโอ';
                }
                return null;
              },
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Heading20px(text: 'รายละเอียดวิดีโอ'),
            ),
            TextFormField(
              maxLines: 5,
              initialValue: video.description,
              decoration: getInputDecoration('รายละเอียดวิดีโอ'),
              onChanged: (String value) {
                video.description = value;
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'กรุณากรอกรายละเอียดวิดีโอ';
                }
                return null;
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Heading20px(text: 'เอกสารประกอบการเรียน'),
                  Text(
                      'กรุณาเลือกไฟล์เอกสารประกอบการเรียนเมื่อท่านต้องการเปลี่ยนเท่านั้น',
                      style: TextStyle(color: Colors.red, fontSize: 12))
                ],
              ),
            ),
            _platformPdfFile != null
                ? Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: greyColor.withOpacity(0.5)),
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.video_collection_outlined),
                      title: Body14px(text: _platformPdfFile!.name),
                      subtitle: Body14px(
                          text: (_platformPdfFile!.size * 0.000001 > 1
                              ? '${(_platformPdfFile!.size * 0.000001).toPrecision(2)} MB'
                              : '${(_platformPdfFile!.size * 0.001).toPrecision(2)} KB')),
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('ลบไฟล์'),
                              content:
                                  const Text('คุณต้องการลบไฟล์นี้ใช่หรือไม่?'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Get.back();
                                  },
                                  child: const Body14px(text: 'ยกเลิก'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Get.back();
                                    setState(() {
                                      _platformPdfFile = null;
                                      pdfFile = null;
                                    });
                                  },
                                  child: const Body14px(
                                      text: 'ลบ', color: Colors.red),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  )
                : InkWell(
                    onTap: () {
                      selectPdfFile().then((value) => setState(() {
                            _platformPdfFile = value;
                            pdfFile = File(value!.path);
                          }));
                    },
                    child: DottedBorder(
                      borderType: BorderType.RRect,
                      radius: const Radius.circular(10),
                      dashPattern: const [10, 4],
                      strokeCap: StrokeCap.round,
                      color: primaryColor,
                      child: Container(
                        width: double.infinity,
                        height: 150,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: primaryLighterColor.withOpacity(0.3)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(
                              Icons.picture_as_pdf_outlined,
                              size: 40,
                              color: primaryColor,
                            ),
                            SizedBox(height: 8),
                            Body14px(
                              text: 'คลิกเพื่อเลือกเอกสารประกอบการเรียน',
                              color: greyColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Heading20px(text: 'ราคา'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: CustomTextForm(
                    title: 'ราคา',
                    keyboardType: TextInputType.number,
                    initialValue: video.price.toString(),
                    onChanged: (String value) {
                      if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                        return;
                      }
                      video.price = int.parse(value);
                    },
                    validator: (String? value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'กรุณากรอกราคา';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.05,
                ),
                const Body16px(text: 'บาท'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
