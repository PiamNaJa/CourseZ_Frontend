import 'package:coursez/screen/home.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
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
  Experience experience = Experience(
    title: '',
    evidence: '',
  );
  File? image;

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);

      if (image == null) return;

      final imageTemp = File(image.path);

      setState(() => this.image = imageTemp);
    } on PlatformException catch (e) {
      print("Fail to pick image : $e");
    }
    Reference ref =
        FirebaseStorage.instance.ref().child("/Images/" + uuid.v4());
    await ref.putFile(File(image!.path));
    ref.getDownloadURL().then((value) {
      print(value);
    });
  }

  final formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios,
              color: Color.fromRGBO(0, 216, 133, 1)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(22, 22, 22, 22),
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
            const SizedBox(
              height: 20,
            ),
            const Text(
              "1.ประสบการณ์ที่ผ่านมา",
              style: TextStyle(
                  fontFamily: 'Athiti',
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 12,
            ),
            SizedBox(
              child: TextFormField(
                onChanged: (String? title) {
                  experience.title = title!;
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  hintText: "วุฒิการศึกษา/เคยเป็นวิทยากรที่ไหน/เข้าร่วมกิจกรรม",
                  hintStyle: TextStyle(fontFamily: 'Athiti', fontSize: 14),
                ),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            const Text(
              "1.หลักฐาน",
              style: TextStyle(
                  fontFamily: 'Athiti',
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            const Text(
              "-ใบประกาศณียบัตร",
              style: TextStyle(
                  fontFamily: 'Athiti',
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            const Text(
              "-ภาพกิจกรรมที่ท่านได้เข้าร่วม",
              style: TextStyle(
                  fontFamily: 'Athiti',
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 12,
            ),
            Center(
              child: image != null
                  ? Image.file(image!)
                  : Container(
                      height: 200,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          pickImage();
                        },
                        child: Icon(
                          size: 100,
                          Icons.add_photo_alternate_outlined,
                          color: Colors.grey,
                        ),
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            )),
                            side: MaterialStateProperty.all<BorderSide>(
                                BorderSide(color: Colors.grey, width: 1)),
                            backgroundColor: MaterialStatePropertyAll<Color>(
                                Color.fromARGB(255, 250, 250, 250))),
                      ),
                    ),
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
              child: image != null
                  ? Image.file(image!)
                  : Container(
                      height: 200,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          pickImage();
                        },
                        child: Icon(
                          size: 100,
                          Icons.add_photo_alternate_outlined,
                          color: Colors.grey,
                        ),
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            )),
                            side: MaterialStateProperty.all<BorderSide>(
                                BorderSide(color: Colors.grey, width: 1)),
                            backgroundColor: MaterialStatePropertyAll<Color>(
                                Color.fromARGB(255, 250, 250, 250))),
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
              child: image != null
                  ? Image.file(image!)
                  : Container(
                      height: 200,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          pickImage();
                        },
                        child: Icon(
                          size: 100,
                          Icons.add_photo_alternate_outlined,
                          color: Colors.grey,
                        ),
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            )),
                            side: MaterialStateProperty.all<BorderSide>(
                                BorderSide(color: Colors.grey, width: 1)),
                            backgroundColor: MaterialStatePropertyAll<Color>(
                                Color.fromARGB(255, 250, 250, 250))),
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
              child: image != null
                  ? Image.file(image!)
                  : Container(
                      height: 200,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          pickImage();
                        },
                        child: Icon(
                          size: 100,
                          Icons.add_photo_alternate_outlined,
                          color: Colors.grey,
                        ),
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            )),
                            side: MaterialStateProperty.all<BorderSide>(
                                BorderSide(color: Colors.grey, width: 1)),
                            backgroundColor: MaterialStatePropertyAll<Color>(
                                Color.fromARGB(255, 250, 250, 250))),
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
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return const MyHomePage();
                    }));
                    formkey.currentState?.save();
                  },
                  child: const Text(
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
}
