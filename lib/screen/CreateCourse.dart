import 'dart:io';
import 'package:coursez/controllers/post_controller.dart';
import 'package:coursez/model/course.dart';
import 'package:coursez/model/subject.dart';
import 'package:coursez/model/user.dart';
import 'package:coursez/utils/color.dart';
import 'package:coursez/view_model/auth_view_model.dart';
import 'package:coursez/view_model/course_view_model.dart';
import 'package:coursez/widgets/appbar/app_bar.dart';
import 'package:coursez/widgets/button/button.dart';
import 'package:coursez/widgets/button/radiobutton.dart';
import 'package:coursez/widgets/text/heading2_20px.dart';
import 'package:coursez/widgets/text/title16px.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../widgets/bottomSheet/dropdownBottomSheet.dart';
import '../widgets/text/body14px.dart';
import '../widgets/text/body16.dart';

class Createcourse extends StatefulWidget {
  const Createcourse({super.key});

  @override
  State<Createcourse> createState() => _CreatecourseState();
}

class _CreatecourseState extends State<Createcourse> {
  PostController postController = Get.find<PostController>();
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  File? image;
  Course course = Course(
      courseId: 0,
      coursename: '',
      createdAt: 0,
      description: '',
      picture: '',
      subject: Subject(
          classLevel: 0, subjectId: 0, subjectPicture: '', subjectTitle: ''),
      subjectId: 0,
      teacherId: 0,
      videos: []);

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);

      if (image == null) return;

      final imageTemp = File(image.path);

      setState(() => this.image = imageTemp);
    } on PlatformException catch (e) {
      debugPrint("Fail to pick image : $e");
    }
  }

  onSubmit(File? image) async {
    if (formkey.currentState!.validate()) {
      formkey.currentState!.save();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        elevation: 0.0,
        titleSpacing: 0,
        title: const Heading20px(text: "สร้างคอร์ส"),
        backgroundColor: whiteColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: primaryColor),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formkey,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: image != null
                      ? Stack(
                          alignment: AlignmentDirectional.topEnd,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(15),
                              child: Image.file(
                                image!,
                                height: 200,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(
                              width: 50,
                              child: RawMaterialButton(
                                onPressed: () {
                                  pickImage();
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
                            )
                          ],
                        )
                      : InkWell(
                          onTap: () {
                            pickImage();
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
                                    Icons.add_a_photo,
                                    size: 40,
                                    color: primaryColor,
                                  ),
                                  SizedBox(height: 8),
                                  Body14px(
                                    text: 'คลิกเพื่อเลือกรูปคอร์ส',
                                    color: greyColor,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Title16px(text: "ชื่อคอร์ส"),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  child: TextFormField(
                    onChanged: (String? coursename) {
                      course.coursename = coursename!;
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      hintText: "ชื่อคอร์ส",
                      hintStyle: TextStyle(
                        fontFamily: 'Athiti',
                        fontSize: 16,
                      ),
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: MultiValidator([
                      RequiredValidator(errorText: "โปรดกรอกชื่อคอร์สของคุณ"),
                    ]),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Title16px(text: "รายละเอียดคอร์ส"),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  child: TextFormField(
                    keyboardType: TextInputType.multiline,
                    maxLines: 7,
                    onChanged: (String? description) {
                      course.description = description!;
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      hintText: "กรุณาใส่รายละเอียดคอร์ส...",
                      hintStyle: TextStyle(
                        fontFamily: 'Athiti',
                        fontSize: 16,
                      ),
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: MultiValidator([
                      RequiredValidator(errorText: "โปรดกรอกชื่อคอร์สของคุณ"),
                    ]),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Title16px(text: "เลือกระดับชั้น"),
                const SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: () {
                    showModalBottomSheet(
                        context: Get.context!,
                        builder: (context) {
                          return const BottomSheetForDropdown();
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
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            disabledBackgroundColor: primaryLighterColor,
                            backgroundColor: primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          onPressed: (() {
                            Get.toNamed('/createvideo', arguments: course);
                          }),
                          child: const Text("ต่อไป")),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
