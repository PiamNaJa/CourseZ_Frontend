import 'package:coursez/model/experience.dart';
import 'package:coursez/model/user.dart';
import 'package:coursez/utils/color.dart';
import 'package:coursez/view_model/auth_view_model.dart';
import 'package:coursez/widgets/button/button.dart';
import 'package:coursez/widgets/button/radiobutton.dart';
import 'package:coursez/widgets/text/heading2_20px.dart';
import 'package:coursez/widgets/text/title16px.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:url_launcher/url_launcher.dart';

class RegisterPage2 extends StatefulWidget {
  const RegisterPage2({super.key});

  @override
  State<RegisterPage2> createState() => _RegisterPage2State();
}

class _RegisterPage2State extends State<RegisterPage2> {
  User user = Get.arguments;
  String? image = Get.parameters['image'];
  bool isTeacher = true, isTutor = false, isWaiting = false;
  List<Experience> experiences =
      List.filled(1, Experience(title: '', evidence: ''), growable: true);
  List<File?> experienceImages = List.filled(1, null, growable: true);
  int experienceLength = 1;
  File? teacherLicense, transcript, idCard, psychologicalTest;
  final formkey = GlobalKey<FormState>();
  final uri = Uri.parse("https://testyourself.psychtests.com/testid/4176");
  pickImage() async {
    try {
      var image = await ImagePicker().pickImage(source: ImageSource.gallery);

      if (image == null) return null;

      final imageTemp = File(image.path);

      return imageTemp;
    } on PlatformException catch (e) {
      debugPrint("Fail to pick image : $e");
    }
  }

  onTeacherSubmit() {
    if (formkey.currentState!.validate() == false) {
      Get.snackbar('เกิดข้อผิดพลาด', 'กรุณากรอกข้อมูลให้ครบถ้วน',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      return;
    }

    if (experienceImages.length == 1 && experienceImages[0] == null) {
      Get.snackbar('เกิดข้อผิดพลาด', 'กรุณาเพิ่มประสบการณ์',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      return;
    }
    if (teacherLicense == null) {
      Get.snackbar('เกิดข้อผิดพลาด', 'โปรดเพิ่มใบประกอบวิชาชีพครู',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      return;
    }
    if (transcript == null) {
      Get.snackbar('เกิดข้อผิดพลาด', 'โปรดเพิ่มเอกสารรับรองผลการศึกษา',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      return;
    }
    if (idCard == null) {
      Get.snackbar('เกิดข้อผิดพลาด', 'โปรดเพิ่มบัตรประชาชน',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      return;
    }
    setState(() {
      isWaiting = true;
    });
    AuthViewModel().registerTeacher(user, teacherLicense, transcript, idCard,
        image!, experienceImages, experiences);
  }

  onTutorSubmit() {
    if (formkey.currentState!.validate() == false) {
      Get.snackbar('เกิดข้อผิดพลาด', 'กรุณากรอกข้อมูลให้ครบถ้วน',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      return;
    }
    if (experienceImages.length == 1 && experienceImages[0] == null) {
      Get.snackbar('เกิดข้อผิดพลาด', 'กรุณาเพิ่มประสบการณ์',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      return;
    }
    if (psychologicalTest == null) {
      Get.snackbar('เกิดข้อผิดพลาด', 'โปรดส่งผลการทดสอบจิตวิทยา',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      return;
    }
    if (idCard == null) {
      Get.snackbar('เกิดข้อผิดพลาด', 'โปรดเพิ่มบัตรประชาชน',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      return;
    }
    setState(() {
      isWaiting = true;
    });
    AuthViewModel().registerTutor(
        user, psychologicalTest, idCard, image!, experienceImages, experiences);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: primaryColor),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(22, 0, 22, 22),
            child: Column(
              children: [
                SizedBox(
                  width: 1200.0,
                  height: 120.0,
                  child: Image.asset("assets/images/Kunkru.png"),
                ),
                const SizedBox(
                  height: 12,
                ),
                const Text(
                  "ท่านเป็นครู/อาจารย์ หรือ บุคคลทั่วไป",
                  style: TextStyle(
                      fontFamily: 'Athiti',
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 12,
                ),
                LayoutBuilder(builder: (context, constraints) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: constraints.maxWidth / 2 - 10,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: RadioBt(
                            text: 'คุณครู/ อาจารย์',
                            onPressed: () {
                              setState(() {
                                isTeacher = true;
                                isTutor = false;
                                user.role = "Teacher";
                              });
                            },
                            backgroundColor:
                                isTeacher ? primaryColor : whiteColor,
                            borderColor: isTeacher ? primaryColor : greyColor,
                            fontcolor: isTeacher ? whiteColor : blackColor,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: SizedBox(
                          width: constraints.maxWidth / 2 - 10,
                          child: RadioBt(
                            text: 'บุคคลทั่วไป',
                            onPressed: () {
                              setState(() {
                                isTeacher = false;
                                isTutor = true;
                                user.role = "Tutor";
                              });
                            },
                            backgroundColor:
                                isTutor ? primaryColor : whiteColor,
                            borderColor: isTutor ? primaryColor : greyColor,
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
                const Heading20px(text: 'ประสบการณ์ของท่าน'),
                SizedBox(
                  height: 12,
                  child: Container(
                      decoration: const BoxDecoration(
                          border:
                              Border(bottom: BorderSide(color: greyColor)))),
                ),
                Form(
                    key: formkey,
                    child: Column(
                      children: [
                        for (var i = 0; i < experiences.length; i++)
                          experienceForm(i),
                      ],
                    )),
                Bt(
                  text: "เพิ่มประสบการณ์",
                  color: primaryColor,
                  onPressed: () => setState(() {
                    experiences.add(Experience(title: '', evidence: ''));
                    experienceImages.add(null);
                    experienceLength++;
                  }),
                ),
                const SizedBox(
                  height: 12,
                ),
                SizedBox(
                  height: 12,
                  child: Container(
                      decoration: const BoxDecoration(
                          border:
                              Border(bottom: BorderSide(color: greyColor)))),
                ),
                const SizedBox(
                  height: 12,
                ),
                (isTeacher) ? teacherReg() : peopleReg(),
                const SizedBox(
                  height: 24,
                ),
                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                      style: const ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll<Color>(primaryColor)),
                      onPressed: isWaiting
                          ? null
                          : isTeacher
                              ? onTeacherSubmit
                              : onTutorSubmit,
                      child: isWaiting
                          ? const CircularProgressIndicator(
                              color: whiteColor,
                            )
                          : const Title16px(
                              text: 'ลงทะเบียน',
                              color: whiteColor,
                            )),
                ),
              ],
            ),
          ),
        ));
  }

  Widget teacherReg() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text(
        "ใบประกอบวิชาชีพครู",
        style: TextStyle(
            fontFamily: 'Athiti', fontSize: 20, fontWeight: FontWeight.bold),
      ),
      const SizedBox(
        height: 12,
      ),
      Center(
        child: teacherLicense != null
            ? Stack(
                alignment: AlignmentDirectional.topEnd,
                // fit: StackFit.passthrough,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Image.file(
                      teacherLicense!,
                      height: 250,
                      fit: BoxFit.cover,
                      // width: MediaQuery.of(context).size.width * 0.8,
                    ),
                  ),
                  SizedBox(
                    width: 50,
                    child: RawMaterialButton(
                      onPressed: () {
                        pickImage().then((value) => setState(
                              () => teacherLicense = value,
                            ));
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
            : SizedBox(
                height: 200,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => pickImage().then((value) => setState(
                        () => teacherLicense = value,
                      )),
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      )),
                      side: MaterialStateProperty.all<BorderSide>(
                          const BorderSide(color: Colors.grey, width: 1)),
                      backgroundColor: const MaterialStatePropertyAll<Color>(
                          Color.fromARGB(255, 250, 250, 250))),
                  child: const Icon(
                    size: 100,
                    Icons.add_photo_alternate_outlined,
                    color: greyColor,
                  ),
                ),
              ),
      ),
      const SizedBox(
        height: 12,
      ),
      const Text(
        "เอกสารรับรองผลการศึกษา",
        style: TextStyle(
            fontFamily: 'Athiti', fontSize: 20, fontWeight: FontWeight.bold),
      ),
      const SizedBox(
        height: 12,
      ),
      Center(
        child: transcript != null
            ? Stack(
                alignment: AlignmentDirectional.topEnd,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Image.file(
                      transcript!,
                      height: 250,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(
                    width: 50,
                    child: RawMaterialButton(
                      onPressed: () {
                        pickImage().then((value) {
                          setState(() {
                            transcript = value;
                          });
                        });
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
            : SizedBox(
                height: 200,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => pickImage().then((value) => setState(
                        () => transcript = value,
                      )),
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      )),
                      side: MaterialStateProperty.all<BorderSide>(
                          const BorderSide(color: Colors.grey, width: 1)),
                      backgroundColor: const MaterialStatePropertyAll<Color>(
                          Color.fromARGB(255, 250, 250, 250))),
                  child: const Icon(
                    size: 100,
                    Icons.add_photo_alternate_outlined,
                    color: greyColor,
                  ),
                ),
              ),
      ),
      const SizedBox(
        height: 12,
      ),
      const Text(
        "บัตรประชาชน",
        style: TextStyle(
            fontFamily: 'Athiti', fontSize: 20, fontWeight: FontWeight.bold),
      ),
      const SizedBox(
        height: 12,
      ),
      Center(
        child: idCard != null
            ? Stack(
                alignment: AlignmentDirectional.topEnd,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Image.file(
                      idCard!,
                      height: 250,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(
                    width: 50,
                    child: RawMaterialButton(
                      onPressed: () {
                        pickImage().then((value) {
                          setState(() {
                            idCard = value;
                          });
                        });
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
            : SizedBox(
                height: 200,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => pickImage().then((value) => setState(
                        () => idCard = value,
                      )),
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      )),
                      side: MaterialStateProperty.all<BorderSide>(
                          const BorderSide(color: Colors.grey, width: 1)),
                      backgroundColor: const MaterialStatePropertyAll<Color>(
                          Color.fromARGB(255, 250, 250, 250))),
                  child: const Icon(
                    size: 100,
                    Icons.add_photo_alternate_outlined,
                    color: greyColor,
                  ),
                ),
              ),
      ),
    ]);
  }

  Widget peopleReg() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Heading20px(text: 'ท่านต้องผ่านการทดสอบจิตวิทยาที่นี่'),
        const SizedBox(
          height: 12,
        ),
        SizedBox(
          width: 150,
          child: Bt(
              text: 'ทำแบบทดสอบ',
              color: secondaryColor,
              onPressed: () => launchUrl(uri)),
        ),
        const SizedBox(
          height: 12,
        ),
        const Heading20px(text: 'ส่งผลทดสอบจิตวิทยา'),
        const SizedBox(
          height: 12,
        ),
        Center(
          child: psychologicalTest != null
              ? Stack(
                  alignment: AlignmentDirectional.topEnd,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Image.file(
                        psychologicalTest!,
                        height: 250,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(
                      width: 50,
                      child: RawMaterialButton(
                        onPressed: () {
                          pickImage().then((value) {
                            setState(() {
                              psychologicalTest = value;
                            });
                          });
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
              : SizedBox(
                  height: 200,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      pickImage().then((value) {
                        setState(() {
                          psychologicalTest = value;
                        });
                      });
                    },
                    style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        )),
                        side: MaterialStateProperty.all<BorderSide>(
                            const BorderSide(color: Colors.grey, width: 1)),
                        backgroundColor: const MaterialStatePropertyAll<Color>(
                            Color.fromARGB(255, 250, 250, 250))),
                    child: const Icon(
                      size: 100,
                      Icons.add_photo_alternate_outlined,
                      color: greyColor,
                    ),
                  ),
                ),
        ),
        const SizedBox(
          height: 12,
        ),
        const Heading20px(text: 'บัตรประชาชน'),
        const SizedBox(
          height: 12,
        ),
        Center(
          child: idCard != null
              ? Stack(
                  alignment: AlignmentDirectional.topEnd,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Image.file(
                        idCard!,
                        height: 250,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(
                      width: 50,
                      child: RawMaterialButton(
                        onPressed: () {
                          pickImage().then((value) {
                            setState(() {
                              idCard = value;
                            });
                          });
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
              : SizedBox(
                  height: 200,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      pickImage().then((value) {
                        setState(() {
                          idCard = value;
                        });
                      });
                    },
                    style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        )),
                        side: MaterialStateProperty.all<BorderSide>(
                            const BorderSide(color: Colors.grey, width: 1)),
                        backgroundColor: const MaterialStatePropertyAll<Color>(
                            Color.fromARGB(255, 250, 250, 250))),
                    child: const Icon(
                      size: 100,
                      Icons.add_photo_alternate_outlined,
                      color: greyColor,
                    ),
                  ),
                ),
        ),
      ],
    );
  }

  Widget experienceForm(int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Heading20px(text: '${index + 1}.ประสบการณ์ที่ผ่านมา'),
            (index > 0)
                ? IconButton(
                    onPressed: () =>
                        setState(() => experiences.removeAt(index)),
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                  )
                : const SizedBox(),
          ],
        ),
        const SizedBox(
          height: 12,
        ),
        TextFormField(
          onChanged: (String? title) =>
              setState(() => experiences[index].title = title!),
          decoration: const InputDecoration(
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(20))),
            hintText: "วุฒิการศึกษา/เคยเป็นวิทยากรที่ไหน/เข้าร่วมกิจกรรม",
            hintStyle: TextStyle(fontFamily: 'Athiti', fontSize: 14),
          ),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'กรุณากรอกข้อมูล';
            }
            return null;
          },
        ),
        const SizedBox(
          height: 12,
        ),
        const Heading20px(text: 'หลักฐาน'),
        const Heading20px(text: '- ใบประกาศณียบัตร'),
        const Heading20px(text: '- ภาพกิจกรรมที่ท่านได้เข้าร่วม'),
        const SizedBox(
          height: 12,
        ),
        Center(
          child: experienceImages[index] != null
              ? Stack(
                  alignment: AlignmentDirectional.topEnd,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Image.file(
                        experienceImages[index]!,
                        height: 250,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(
                      width: 50,
                      child: RawMaterialButton(
                        onPressed: () {
                          pickImage().then((value) {
                            setState(() {
                              experienceImages[index] = value;
                            });
                          });
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
              : SizedBox(
                  height: 200,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      pickImage().then((value) {
                        setState(() {
                          experienceImages[index] = value;
                        });
                      });
                    },
                    style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        )),
                        side: MaterialStateProperty.all<BorderSide>(
                            const BorderSide(color: Colors.grey, width: 1)),
                        backgroundColor: const MaterialStatePropertyAll<Color>(
                            Color.fromARGB(255, 250, 250, 250))),
                    child: const Icon(
                      size: 100,
                      Icons.add_photo_alternate_outlined,
                      color: greyColor,
                    ),
                  ),
                ),
        ),
        const SizedBox(
          height: 15,
        )
      ],
    );
  }
}
