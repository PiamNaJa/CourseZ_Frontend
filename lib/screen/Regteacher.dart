import 'package:coursez/model/user.dart';
import 'package:coursez/screen/home.dart';
import 'package:coursez/utils/color.dart';
import 'package:coursez/view_model/auth_view_model.dart';
import 'package:coursez/widgets/button/button.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '../model/experience.dart';

var uuid = const Uuid();

class RegisterTeacher extends StatefulWidget {
  const RegisterTeacher({super.key});

  @override
  State<RegisterTeacher> createState() => _RegisterTeacherState();
}

class _RegisterTeacherState extends State<RegisterTeacher> {
  User user = Get.arguments;
  List<Experience> experiences =
      List.filled(1, Experience(title: '', evidence: ''), growable: true);
  List<File?> experienceImages = List.filled(1, null, growable: true);
  int experienceLength = 1;
  File? teacherLicense, transcript, idCard;
  final image = Get.parameters['image'];
  File picture = File('');
  bool isWaiting = false;
  @override
  initState() {
    super.initState();
    picture = File(image!);
  }

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

  onSubmit() {
    if (experienceImages.length == 1 &&
        experienceImages[0] == null &&
        experiences[0].title == '') {
      Get.snackbar('Error', 'กรุณาเพิ่มประสบการณ์',
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
    if (transcript == null) {
      Get.snackbar('Error', 'โปรดเพิ่มเอกสารรับรองผลการศึกษา',
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
    setState(() {
      isWaiting = true;
    });
    AuthViewModel().registerTeacher(user, teacherLicense, transcript, idCard,
        picture, experienceImages, experiences);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0.0),
          child: isWaiting ? const LinearProgressIndicator() : Container(),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios,
              color: Color.fromRGBO(0, 216, 133, 1)),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(22, 0, 22, 22),
        child: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Image.asset(width: 1200, height: 120, "assets/images/Kunkru.png"),
            const SizedBox(
              height: 20,
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
                      border: Border(bottom: BorderSide(color: Colors.grey)))),
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
                      border: Border(bottom: BorderSide(color: Colors.grey)))),
            ),
            const SizedBox(
              height: 12,
            ),
            const Text(
              "ใบประกอบวิชาชีพครู",
              style: TextStyle(
                  fontFamily: 'Athiti',
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
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
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            )),
                            side: MaterialStateProperty.all<BorderSide>(
                                const BorderSide(color: Colors.grey, width: 1)),
                            backgroundColor:
                                const MaterialStatePropertyAll<Color>(
                                    Color.fromARGB(255, 250, 250, 250))),
                        child: const Icon(
                          size: 100,
                          Icons.add_photo_alternate_outlined,
                          color: Colors.grey,
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
                  fontFamily: 'Athiti',
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
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
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            )),
                            side: MaterialStateProperty.all<BorderSide>(
                                const BorderSide(color: Colors.grey, width: 1)),
                            backgroundColor:
                                const MaterialStatePropertyAll<Color>(
                                    Color.fromARGB(255, 250, 250, 250))),
                        child: const Icon(
                          size: 100,
                          Icons.add_photo_alternate_outlined,
                          color: Colors.grey,
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
                  fontFamily: 'Athiti',
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
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
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            )),
                            side: MaterialStateProperty.all<BorderSide>(
                                const BorderSide(color: Colors.grey, width: 1)),
                            backgroundColor:
                                const MaterialStatePropertyAll<Color>(
                                    Color.fromARGB(255, 250, 250, 250))),
                        child: const Icon(
                          size: 100,
                          Icons.add_photo_alternate_outlined,
                          color: Colors.grey,
                        ),
                      ),
                    ),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 40,
              width: double.infinity,
              child: ElevatedButton(
                  style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll<Color>(
                          Color.fromRGBO(0, 216, 133, 1))),
                  onPressed: isWaiting ? null : onSubmit,
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
          ]),
        ),
      ),
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
                      color: Colors.grey,
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
