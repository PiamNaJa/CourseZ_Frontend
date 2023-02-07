import 'package:coursez/model/experience.dart';
import 'package:coursez/model/user.dart';
import 'package:coursez/utils/color.dart';
import 'package:coursez/view_model/auth_view_model.dart';
import 'package:coursez/widgets/button/button.dart';
import 'package:coursez/widgets/button/radiobutton.dart';
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
  // User user = User(
  //     email: '',
  //     password: '',
  //     fullName: '',
  //     nickName: '',
  //     role: '',
  //     picture: '',
  //     point: 0);
  String? image = Get.parameters['image'];
  bool isTeacher = true, isTutor = false, isWaiting = false;
  List<Experience> experiences =
      List.filled(1, Experience(title: '', evidence: ''), growable: true);
  List<File?> experienceImages = List.filled(1, null, growable: true);
  int experienceLength = 1;
  File? teacherLicense, transcript, idCard, psychologicalTest;
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
    if (experienceImages.length == 1 &&
        experienceImages[0] == null &&
        experiences[0].title == '') {
      Get.snackbar('Error', 'กรุณาเพิ่มประสบการณ์',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      return;
    }
    if (teacherLicense == null) {
      Get.snackbar('Error', 'โปรดเพิ่มใบประกอบวิชาชีพครู',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      return;
    }
    if (transcript == null) {
      Get.snackbar('Error', 'โปรดเพิ่มเอกสารรับรองผลการศึกษา',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      return;
    }
    if (idCard == null) {
      Get.snackbar('Error', 'โปรดเพิ่มบัตรประชาชน',
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
    if (experienceImages.length == 1 &&
        experienceImages[0] == null &&
        experiences[0].title == '') {
      Get.snackbar('Error', 'กรุณาเพิ่มประสบการณ์',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      return;
    }
    if (psychologicalTest == null) {
      Get.snackbar('Error', 'โปรดส่งผลการทดสอบจิตวิทยา',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      return;
    }
    if (idCard == null) {
      Get.snackbar('Error', 'โปรดเพิ่มบัตรประชาชน',
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
                const Text(
                  "ประสบการณ์ของท่าน",
                  style: TextStyle(
                      fontFamily: 'Athiti',
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 12,
                  child: Container(
                      decoration: const BoxDecoration(
                          border:
                              Border(bottom: BorderSide(color: greyColor)))),
                ),
                for (var i = 0; i < experiences.length; i++) experienceForm(i),
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
                  height: 40,
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
                          : const Text(
                              "ลงทะเบียน",
                              style: TextStyle(
                                  fontFamily: 'Athiti',
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
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
            ? Image.file(teacherLicense!)
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
            ? Image.file(transcript!)
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
            ? Image.file(idCard!)
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
        const Text(
          "ท่านต้องผ่านการทดสอบจิตวิทยาที่นี่",
          style: TextStyle(
              fontFamily: 'Athiti', fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          width: 150,
          child: ElevatedButton(
              style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll<Color>(
                      Color.fromARGB(255, 120, 122, 122))),
              onPressed: () {
                launchUrl(uri);
              },
              child: const Text(
                "ทำแบบสอบถาม",
                style: TextStyle(
                    fontFamily: 'Athiti',
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              )),
        ),
        const SizedBox(
          height: 12,
        ),
        const Text(
          "ส่งผลทดสอบจิตวิทยา",
          style: TextStyle(
              fontFamily: 'Athiti', fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 12,
        ),
        Center(
          child: psychologicalTest != null
              ? Image.file(psychologicalTest!)
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
              ? Image.file(idCard!)
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
        Text(
          "${index + 1}.ประสบการณ์ที่ผ่านมา",
          style: const TextStyle(
              fontFamily: 'Athiti', fontSize: 20, fontWeight: FontWeight.bold),
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
        ),
        const SizedBox(
          height: 12,
        ),
        const Text(
          "หลักฐาน",
          style: TextStyle(
              fontFamily: 'Athiti', fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const Text(
          "-ใบประกาศณียบัตร",
          style: TextStyle(
              fontFamily: 'Athiti', fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const Text(
          "-ภาพกิจกรรมที่ท่านได้เข้าร่วม",
          style: TextStyle(
              fontFamily: 'Athiti', fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 12,
        ),
        Center(
          child: experienceImages[index] != null
              ? Image.file(experienceImages[index]!)
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
