import 'dart:io';
import 'package:coursez/model/user.dart';
import 'package:coursez/utils/color.dart';
import 'package:coursez/view_model/auth_view_model.dart';
import 'package:coursez/widgets/appbar/app_bar.dart';
import 'package:coursez/widgets/button/button.dart';
import 'package:coursez/widgets/button/radiobutton.dart';
import 'package:coursez/widgets/text/heading2_20px.dart';
import 'package:coursez/widgets/text/title16px.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  User user = User(
      email: '',
      password: '',
      fullName: '',
      nickName: '',
      role: '',
      picture: '',
      point: 0,
      likeCourses: [],
      likeVideos: [],
      paidVideos: [],
       videoHistory: [], courseHistory: []);
  File? image;
  Color radioColor = greyColor;
  Color bgRadioColor = whiteColor;
  Color radioTextColor = blackColor;
  bool isTutor = false;
  bool isStudent = false;

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

  final formkey = GlobalKey<FormState>();
  final AuthViewModel authViewModel = AuthViewModel();

  onSubmit() async {
    if (formkey.currentState!.validate()) {
      formkey.currentState!.save();
      user.role == "Tutor"
          ? Get.toNamed('/register2',
              arguments: user,
              parameters: {'image': image != null ? image!.path : ''})
          : await authViewModel.registerStudent(user, image);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const CustomAppBar(
          title: 'ลงทะเบียน',
        ),
        body: Padding(
            padding: const EdgeInsets.fromLTRB(22, 0, 22, 22),
            child: Form(
              key: formkey,
              child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Column(
                          children: const [
                            Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Title16px(
                                text: 'โปรดกรอกข้อมูลให้ครบถ้วน',
                                color: greyColor,
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Center(
                          child: image != null
                              ? Stack(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(15),
                                      child: ClipOval(
                                          child: Image.file(
                                        image!,
                                        height: 120,
                                        width: 120,
                                        fit: BoxFit.cover,
                                      )),
                                    ),
                                    Positioned(
                                      top: 10,
                                      left: 75,
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
                                  child: Container(
                                    height: 100,
                                    decoration: const BoxDecoration(
                                        color: greyColor,
                                        shape: BoxShape.circle),
                                    child: const Center(
                                      child: Icon(
                                        Icons.add_a_photo_outlined,
                                        size: 50,
                                      ),
                                    ),
                                  ),
                                )),
                      const Heading20px(text: 'ชื่อจริง - นามสกุล'),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        child: TextFormField(
                          onChanged: (String? fullName) {
                            user.fullName = fullName!;
                          },
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            hintText: "ชื่อจริง-นามสกุล",
                            hintStyle: TextStyle(
                              fontFamily: 'Athiti',
                              fontSize: 16,
                            ),
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: MultiValidator([
                            RequiredValidator(errorText: "โปรดกรอกชื่อของคุณ"),
                          ]),
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      const Heading20px(text: 'ชื่อเล่น'),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        child: TextFormField(
                          onChanged: (String? nickName) {
                            user.nickName = nickName!;
                          },
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            hintText: "ชื่อเล่น",
                            hintStyle: TextStyle(
                              fontFamily: 'Athiti',
                              fontSize: 16,
                            ),
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: MultiValidator([
                            RequiredValidator(
                                errorText: "โปรดกรอกชื่อเล่นของคุณ"),
                          ]),
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      const Heading20px(text: 'อีเมล'),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        child: TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          onChanged: (String? email) {
                            user.email = email!;
                          },
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            hintText: "P@example.com",
                            hintStyle: TextStyle(
                              fontFamily: 'Athiti',
                              fontSize: 16,
                            ),
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: MultiValidator([
                            RequiredValidator(
                                errorText: "โปรดกรอกอีเมลล์ของคุณ"),
                            EmailValidator(errorText: "อีเมลล์ของคุณผิด")
                          ]),
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      const Heading20px(text: 'รหัสผ่าน'),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        child: TextFormField(
                            obscureText: true,
                            onChanged: (String? password) {
                              user.password = password!;
                            },
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              hintText: "รหัสผ่าน",
                              hintStyle: TextStyle(
                                fontFamily: 'Athiti',
                                fontSize: 16,
                              ),
                            ),
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: ((value) {
                              if (value!.isEmpty) {
                                return "โปรดกรอกรหัสผ่านของคุณ";
                              } else if (value.length < 6) {
                                return "รหัสผ่านค้องมีความยาว 6 ตัวขึ้นไป";
                              }
                              return null;
                            })),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      const Heading20px(text: 'ท่านคือใคร'),
                      const SizedBox(
                        height: 10,
                      ),
                      LayoutBuilder(builder: (context, constraints) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: SizedBox(
                                width: constraints.maxWidth / 2 - 10,
                                height: 45,
                                child: RadioBt(
                                  text: 'นักเรียน',
                                  onPressed: () {
                                    setState(() {
                                      isStudent = true;
                                      isTutor = false;
                                      user.role = "Student";
                                    });
                                  },
                                  backgroundColor:
                                      isStudent ? primaryColor : whiteColor,
                                  borderColor:
                                      isStudent ? primaryColor : greyColor,
                                  fontcolor:
                                      isStudent ? whiteColor : blackColor,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: SizedBox(
                                width: constraints.maxWidth / 2 - 10,
                                height: 45,
                                child: RadioBt(
                                  text: 'ติวเตอร์',
                                  onPressed: () {
                                    setState(() {
                                      isStudent = false;
                                      isTutor = true;
                                      user.role = "Tutor";
                                    });
                                  },
                                  backgroundColor:
                                      isTutor ? primaryColor : whiteColor,
                                  borderColor:
                                      isTutor ? primaryColor : greyColor,
                                  fontcolor: isTutor ? whiteColor : blackColor,
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                      const SizedBox(
                        height: 24,
                      ),
                      Center(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: greyColor),
                          ),
                          width: MediaQuery.of(context).size.width * 0.8,
                          height: 1,
                        ),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      SizedBox(
                        height: 50,
                        width: double.infinity,
                        child: Bt(
                            text: 'ลงทะเบียน',
                            color: primaryColor,
                            onPressed: onSubmit),
                      )
                    ]),
              ),
            )));
  }
}
