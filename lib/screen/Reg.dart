import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:coursez/Screen/Register2.dart';
import 'package:coursez/model/profile.dart';
import 'package:image_picker/image_picker.dart';

enum ProductTypeEnum { Donwloadable, Deliverable }

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  Profile profile = Profile(email: '', password: '');
  ProductTypeEnum? _productTypeEnum;
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
            padding: const EdgeInsets.fromLTRB(22, 22, 22, 22),
            child: SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "โปรดกรอกข้อมูลให้ครบถ้วน",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Text(
                      "ชื่อจริง-นามสกุล",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 50,
                      child: TextFormField(
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(20, 0, 0, 20),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(width: 1),
                          ),
                          hintText: "ชื่อจริง-นามสกุล",
                          hintStyle: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Text(
                      "ชื่อเล่น",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 50,
                      child: TextFormField(
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(20, 0, 0, 20),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(width: 1),
                          ),
                          hintText: "ชื่อเล่น",
                          hintStyle: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Text(
                      "อีเมล",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 50,
                      child: TextFormField(
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(20, 0, 0, 20),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(width: 1),
                          ),
                          hintText: "P@example.com",
                          hintStyle: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Text(
                      "รหัสผ่าน",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 50,
                      child: TextFormField(
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(20, 0, 0, 20),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(width: 1),
                          ),
                          hintText: "รหัสผ่าน",
                          hintStyle: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Text(
                      "วันเกิด",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 50,
                      child: TextFormField(
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(20, 0, 0, 20),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(width: 1),
                          ),
                          hintText: "วว/ดด/ปปปป(พุทธศักราช)",
                          hintStyle: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Text(
                      "ท่านคือใคร",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: RadioListTile<ProductTypeEnum>(
                              contentPadding: EdgeInsets.all(0.0),
                              value: ProductTypeEnum.Deliverable,
                              groupValue: _productTypeEnum,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                              activeColor: Color.fromRGBO(0, 216, 133, 1),
                              title: Text("นักเรียน"),
                              onChanged: (val) {
                                setState(() {
                                  _productTypeEnum = val;
                                });
                              }),
                        ),
                        Expanded(
                          child: RadioListTile<ProductTypeEnum>(
                              contentPadding: EdgeInsets.all(0.0),
                              value: ProductTypeEnum.Donwloadable,
                              groupValue: _productTypeEnum,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                              activeColor: Color.fromRGBO(0, 216, 133, 1),
                              title: Text("ติวเตอร์"),
                              onChanged: (val) {
                                setState(() {
                                  _productTypeEnum = val;
                                });
                              }),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Text(
                      "รูปประจำตัว",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    image != null
                        ? Image.file(image!)
                        : Text("No image selected"),
                    ElevatedButton.icon(
                      style: ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll<Color>(
                              Color.fromARGB(255, 218, 217, 217))),
                      icon: const Icon(
                        Icons.add_photo_alternate_outlined,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        pickImage();
                      },
                      label: Text(
                        "แนบรูปภาพ",
                        style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    SizedBox(
                      height: 40,
                      width: double.infinity,
                      child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll<Color>(
                                  Color.fromRGBO(0, 216, 133, 1))),
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return RegisterPage2();
                            }));
                          },
                          child: Text(
                            "ลงทะเบียน",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          )),
                    )
                  ]),
            )));
  }
}
