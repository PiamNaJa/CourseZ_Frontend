import 'dart:io';
import 'package:coursez/model/video.dart';
import 'package:coursez/utils/color.dart';
import 'package:coursez/utils/inputDecoration.dart';
import 'package:coursez/widgets/button/button.dart';
import 'package:coursez/widgets/text/body14px.dart';
import 'package:coursez/widgets/text/body16.dart';
import 'package:coursez/widgets/text/heading1_24px.dart';
import 'package:coursez/widgets/text/heading2_20px.dart';
import 'package:coursez/widgets/textField/Textformfield.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class CreateVideoPage extends StatefulWidget {
  const CreateVideoPage({super.key});

  @override
  State<CreateVideoPage> createState() => _CreateVideoPageState();
}

class _CreateVideoPageState extends State<CreateVideoPage> {
  List<Video> videos = List.filled(
      1,
      Video(
          courseId: 1,
          createdAt: 11111,
          description: '',
          exercises: [],
          picture: '',
          price: 0,
          reviews: [],
          sheet: '',
          url: '',
          videoId: 1,
          videoName: ''),
      growable: true);

  final int videoLength = 1;

  List<File?> coverImage = List.filled(1, null, growable: true);
  List<File?> videoFile = List.filled(1, null, growable: true);
  List<File?> pdfFile = List.filled(1, null, growable: true);
  final List<PlatformFile?> _platformVideoFile =
      List.filled(1, null, growable: true);
  final List<PlatformFile?> _platformPdfFile =
      List.filled(1, null, growable: true);
  final _formKey = GlobalKey<FormState>();

  onSubmit() {
    // if (_formKey.currentState!.validate()) {
    //   _formKey.currentState!.save();
    //   print(videos);
    // }
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
      final result = await FilePicker.platform.pickFiles(type: FileType.video);

      if (result == null) return;

      final String? fileType = result.files.single.extension;
      final file = File(result.files.single.path!);

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
      final file = File(result.files.single.path!);

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
        title: const Heading24px(text: 'เพิ่มวิดีโอ'),
        backgroundColor: whiteColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: primaryColor),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [
          Form(
              key: _formKey,
              child: Column(
                children: [
                  for (var i = 0; i < videos.length; i++) videoForm(i)
                ],
              )),
          Padding(
            padding: const EdgeInsets.only(right: 20, bottom: 10),
            child: Bt(
              text: "เพิ่มวิดีโอ",
              color: primaryColor,
              onPressed: () => setState(() {
                videos.add(Video(
                    courseId: 1,
                    createdAt: 11111,
                    description: '',
                    exercises: [],
                    picture: '',
                    price: 0,
                    reviews: [],
                    sheet: '',
                    url: '',
                    videoId: 1,
                    videoName: ''));
                coverImage.add(null);
                videoFile.add(null);
                pdfFile.add(null);
                _platformVideoFile.add(null);
                _platformPdfFile.add(null);
              }),
            ),
          ),
        ],
      )),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(width: 1, color: primaryDarkColor),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Body16px(text: 'ทั้งหมด ${videos.length} วิดีโอ'),
            const SizedBox(width: 10),
            Bt(
              text: "ยืนยัน",
              color: primaryColor,
              onPressed: onSubmit,
            ),
          ],
        ),
      ),
    );
  }

  Widget videoForm(int index) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: (index % 2 == 0) ? whiteColor : whiteColor.withOpacity(0.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Heading20px(
                  text: 'วิดีโอที่ ${index + 1}',
                  color: primaryColor,
                ),
                (index > 0)
                    ? IconButton(
                        onPressed: () => setState(() {
                          videos.removeAt(index);
                          coverImage.removeAt(index);
                          videoFile.removeAt(index);
                          pdfFile.removeAt(index);
                          _platformVideoFile.removeAt(index);
                          _platformPdfFile.removeAt(index);
                        }),
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                      )
                    : const SizedBox(),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Heading20px(text: 'ภาพหน้าปก'),
          ),
          Center(
            child: coverImage[index] != null
                ? Stack(
                    alignment: AlignmentDirectional.topEnd,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Image.file(
                          coverImage[index]!,
                          height: 250,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(
                        width: 50,
                        child: RawMaterialButton(
                          onPressed: () {
                            pickImage().then((value) => setState(() {
                                  coverImage[index] = value;
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
                : InkWell(
                    onTap: () {
                      pickImage().then((value) => setState(() {
                            coverImage[index] = value;
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
                              Icons.add_a_photo_outlined,
                              size: 40,
                              color: primaryColor,
                            ),
                            SizedBox(height: 8),
                            Body14px(
                              text: 'คลิกเพื่อเลือกรูปภาพ',
                              color: greyColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Heading20px(text: 'เลือกวิดีโอ'),
          ),
          _platformVideoFile[index] != null
              ? Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: greyColor.withOpacity(0.5)),
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.video_collection_outlined),
                    title: Body14px(text: _platformVideoFile[index]!.name),
                    subtitle: Body14px(
                        text: (_platformVideoFile[index]!.size * 0.000001)
                            .toPrecision(2)
                            .toString()),
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
                                    _platformVideoFile[index] = null;
                                    videoFile[index] = null;
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
                          _platformVideoFile[index] = value;
                          videoFile[index] = File(value!.path);
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
            onChanged: (String value) {
              videos[index].videoName = value;
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
            decoration: getInputDecoration('รายละเอียดวิดีโอ'),
            onChanged: (String value) {
              videos[index].description = value;
            },
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'กรุณากรอกรายละเอียดวิดีโอ';
              }
              return null;
            },
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Heading20px(text: 'เอกสารประกอบการเรียน'),
          ),
          _platformPdfFile[index] != null
              ? Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: greyColor.withOpacity(0.5)),
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.video_collection_outlined),
                    title: Body14px(text: _platformPdfFile[index]!.name),
                    subtitle: Body14px(
                        text: (_platformPdfFile[index]!.size * 0.000001)
                            .toPrecision(2)
                            .toString()),
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
                                    _platformPdfFile[index] = null;
                                    pdfFile[index] = null;
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
                          _platformPdfFile[index] = value;
                          pdfFile[index] = File(value!.path);
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
                  initialValue:
                      (videos.length > 1) ? null : videos[0].price.toString(),
                  onChanged: (String value) {
                    videos[index].price = int.parse(value);
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
          const SizedBox(height: 5),
        ],
      ),
    );
  }
}
