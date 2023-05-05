import 'dart:io';
import 'package:coursez/controllers/auth_controller.dart';
import 'package:coursez/controllers/post_controller.dart';
import 'package:coursez/controllers/refresh_controller.dart';
import 'package:coursez/model/video.dart';
import 'package:coursez/utils/color.dart';
import 'package:coursez/view_model/auth_view_model.dart';
import 'package:coursez/view_model/course_view_model.dart';
import 'package:coursez/view_model/level_view_model.dart';
import 'package:coursez/view_model/post_view_model.dart';
import 'package:coursez/view_model/profile_view_model.dart';
import 'package:coursez/widgets/button/button.dart';
import 'package:coursez/widgets/text/body12px.dart';
import 'package:coursez/widgets/text/body14px.dart';
import 'package:coursez/widgets/text/body16.dart';
import 'package:coursez/widgets/text/heading2_20px.dart';
import 'package:coursez/widgets/textField/Textformfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:coursez/utils/inputDecoration.dart';
import 'package:intl/intl.dart';
import '../model/course.dart';
import '../model/subject.dart';
import '../model/user.dart';
import '../widgets/rating/rating.dart';
import '../widgets/text/title14px.dart';
import '../widgets/text/title16px.dart';

class EditCourse extends StatefulWidget {
  const EditCourse({super.key});

  @override
  State<EditCourse> createState() => _EditCourseState();
}

class _EditCourseState extends State<EditCourse> {
  Course coursedata = Get.arguments;

  Future<File?> pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);

      if (image == null) return null;

      final imageTemp = File(image.path);

      return imageTemp;
    } on PlatformException catch (e) {
      debugPrint("Fail to pick image : $e");
    }
  }

  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  final AuthViewModel authViewModel = AuthViewModel();
  final CourseViewModel courseViewModel = CourseViewModel();
  final ProfileViewModel profileViewModel = ProfileViewModel();
  final AuthController authController = Get.find<AuthController>();
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  final RefreshController refreshController = Get.find<RefreshController>();
  PostController postController = Get.find<PostController>();

  File? image;
  double screenWidth = Get.width;

  onSubmit() async {
    if (coursedata.subject!.classLevel == 0) {
      Get.snackbar("กรุณาเลือกระดับชั้น", "กรุณาเลือกระดับชั้น",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: whiteColor);
      return;
    }

    courseViewModel.updatecourse(image, coursedata);
  }

  @override
  Widget build(BuildContext context) {
    LevelViewModel levelViewModel = LevelViewModel();
    return Scaffold(
      key: _globalKey,
      backgroundColor: whiteColor,
      appBar: AppBar(
        elevation: 0.0,
        titleSpacing: 0,
        title: const Heading20px(text: "แก้ไขคอร์ส"),
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
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: formkey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                        child: image != null
                            ? Image.file(
                                image!,
                                height: 150,
                                width: 150,
                                fit: BoxFit.cover,
                              )
                            : Image.network(
                                coursedata.picture,
                                height: 150,
                                width: 150,
                                fit: BoxFit.cover,
                              )),
                    Center(
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            disabledBackgroundColor: primaryLighterColor,
                            backgroundColor: primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          onPressed: (() {
                            pickImage().then((value) => setState(
                                  () {
                                    image = value;
                                  },
                                ));
                          }),
                          child: const Text("เปลี่ยนรูป")),
                    ),
                    const Title16px(text: "ชื่อคอร์ส"),
                    TextFormField(
                      decoration: getInputDecoration('ชื่อคอร์ส'),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: MultiValidator([
                        RequiredValidator(errorText: "โปรดกรอกชื่อคอร์สของคุณ"),
                      ]),
                      onChanged: (String? courseName) {
                        coursedata.coursename = courseName!;
                      },
                      initialValue: coursedata.coursename,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Title16px(text: "รายละเอียดคอร์ส"),
                    TextFormField(
                      keyboardType: TextInputType.multiline,
                      maxLines: 7,
                      decoration: getInputDecoration('รายละเอียดคอร์ส'),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: MultiValidator([
                        RequiredValidator(
                            errorText: "โปรดกรอกรายละเอียดคอร์สของคุณ"),
                      ]),
                      onChanged: (String? description) {
                        coursedata.description = description!;
                      },
                      initialValue: coursedata.description,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: () {
                        showModalBottomSheet(
                            context: Get.context!,
                            builder: (context) {
                              return SingleChildScrollView(
                                child: Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: Column(
                                    children: [
                                      const Align(
                                          alignment: Alignment.centerLeft,
                                          child: Title14px(text: 'ระดับชั้น')),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      FutureBuilder(
                                        future: levelViewModel.loadLevel(0),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            return Column(
                                              children: snapshot.data!.map((e) {
                                                return Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Title14px(
                                                        text: e['levelName']),
                                                    Container(
                                                      alignment:
                                                          Alignment.center,
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 10),
                                                      child: Wrap(
                                                        spacing:
                                                            screenWidth / 20,
                                                        runSpacing: 10,
                                                        runAlignment:
                                                            WrapAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          ...e['subject'].map(
                                                              (Subject
                                                                  subject) {
                                                            return InkWell(
                                                              onTap: () {
                                                                Get.back();
                                                                setState(() {
                                                                  coursedata
                                                                          .subject!
                                                                          .classLevel =
                                                                      subject
                                                                          .classLevel;
                                                                  coursedata
                                                                          .subject!
                                                                          .subjectTitle =
                                                                      subject
                                                                          .subjectTitle;
                                                                  postController
                                                                          .subjectid =
                                                                      subject
                                                                          .subjectId;
                                                                  if (subject
                                                                          .classLevel ==
                                                                      7) {
                                                                    postController
                                                                            .classLevelName =
                                                                        'มหาวิทยาลัย';
                                                                  } else {
                                                                    postController
                                                                            .classLevelName =
                                                                        'ม.${subject.classLevel}';
                                                                  }
                                                                  postController
                                                                          .subjectTitle =
                                                                      subject
                                                                          .subjectTitle;
                                                                  postController
                                                                          .classLevel =
                                                                      subject
                                                                          .classLevel;
                                                                });
                                                              },
                                                              child: Container(
                                                                width:
                                                                    screenWidth /
                                                                        4,
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(8),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  border: Border
                                                                      .all(
                                                                          color:
                                                                              primaryColor),
                                                                  borderRadius: const BorderRadius
                                                                          .all(
                                                                      Radius.circular(
                                                                          10)),
                                                                ),
                                                                child: Center(
                                                                    child: Body14px(
                                                                        text: subject
                                                                            .subjectTitle)),
                                                              ),
                                                            );
                                                          }).toList(),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                );
                                              }).toList(),
                                            );
                                          } else {
                                            return const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            );
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            });
                      },
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(color: greyColor),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Obx(() => Body16px(
                                  text:
                                      '${postController.classLevelName} ${postController.subjectTitle}')),
                              const Icon(Icons.arrow_drop_down_rounded)
                            ],
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                disabledBackgroundColor: primaryLighterColor,
                                backgroundColor: Colors.red,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              onPressed: (() {
                                Get.back();
                                image = null;
                              }),
                              child: const Text("ยกเลิก")),
                        ),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              disabledBackgroundColor: primaryLighterColor,
                              backgroundColor: primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            onPressed: (() {
                              onSubmit();
                            }),
                            child: const Text("บันทึก")),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
