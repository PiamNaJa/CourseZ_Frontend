import 'dart:io';
import 'package:coursez/model/experience.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

var uuid = const Uuid();

class RegisterPeople extends StatefulWidget {
  const RegisterPeople({super.key});

  @override
  State<RegisterPeople> createState() => _RegisterPeopleState();
}

class _RegisterPeopleState extends State<RegisterPeople> {
  Experience experience = Experience(title: '', evidence: '');
  File? image;

  void pickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);

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

  final Uri url = Uri.parse("https://testyourself.psychtests.com/testid/4176");

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
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
              "1.ประสบการณ์ที่ผ่านมา",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                  hintStyle: TextStyle(fontSize: 14),
                ),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            const Text(
              "1.หลักฐาน",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Text(
              "-ใบประกาศณียบัตร",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Text(
              "-ภาพกิจกรรมที่ท่านได้เข้าร่วม",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 12,
            ),
            image != null
                ? Image.file(image!)
                : const Text("No image selected"),
            ElevatedButton.icon(
              style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll<Color>(
                      Color.fromARGB(255, 218, 217, 217))),
              icon: const Icon(
                Icons.add_photo_alternate_outlined,
                color: Colors.black,
              ),
              onPressed: () {
                pickImage();
              },
              label: const Text(
                "แนบรูปภาพ",
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
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
              "ท่านต้องผ่านการทดสอบจิตวิทยาที่นี่",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              width: 150,
              child: ElevatedButton(
                  style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll<Color>(
                          Color.fromARGB(255, 120, 122, 122))),
                  onPressed: () {
                    launchUrl(url);
                  },
                  child: const Text(
                    "ทำแบบสอบถาม",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  )),
            ),
            const SizedBox(
              height: 12,
            ),
            const Text(
              "ส่งผลทดสอบจิตวิทยา",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            image != null
                ? Image.file(image!)
                : const Text("No image selected"),
            ElevatedButton.icon(
              style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll<Color>(
                      Color.fromARGB(255, 218, 217, 217))),
              icon: const Icon(
                Icons.add_photo_alternate_outlined,
                color: Colors.black,
              ),
              onPressed: () {
                pickImage();
              },
              label: const Text(
                "แนบรูปภาพ",
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            const Text(
              "บัตรประชาชน",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            image != null
                ? Image.file(image!)
                : const Text("No image selected"),
            ElevatedButton.icon(
              style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll<Color>(
                      Color.fromARGB(255, 218, 217, 217))),
              icon: const Icon(
                Icons.add_photo_alternate_outlined,
                color: Colors.black,
              ),
              onPressed: () {
                pickImage();
              },
              label: const Text(
                "แนบรูปภาพ",
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            SizedBox(
              height: 40,
              width: double.infinity,
              child: ElevatedButton(
                  style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll<Color>(
                          Color.fromRGBO(0, 216, 133, 1))),
                  onPressed: () {
                    formkey.currentState?.save();
                  },
                  child: const Text(
                    "ลงทะเบียน",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  )),
            ),
          ]),
        ),
      ),
    );
  }
}
