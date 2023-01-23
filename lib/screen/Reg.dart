import 'dart:io';
import 'package:coursez/model/user.dart';
import 'package:coursez/screen/Register2.dart';
import 'package:coursez/screen/home.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../model/user.dart';

var uuid = const Uuid();

enum ProductTypeEnum { Donwloadable, Deliverable }

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
      birthDay: '',
      role: '',
      picture: '',
      point: 0);
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
    Reference ref =
        FirebaseStorage.instance.ref().child("/Images/" + uuid.v4());
    await ref.putFile(File(image!.path));
    ref.getDownloadURL().then((value) {
      print(value);
    });
  }

  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  validator() {
    if (formkey.currentState != null && formkey.currentState!.validate()) {
      return true;
    } else {
      return false;
    }
  }
  //final formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
            padding: const EdgeInsets.fromLTRB(22, 22, 22, 22),
            child: SingleChildScrollView(
              child: Column(
                  key: formkey,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "โปรดกรอกข้อมูลให้ครบถ้วน",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    const Text(
                      "ชื่อจริง-นามสกุล",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
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
                          hintStyle: TextStyle(fontSize: 20),
                        ),
                        validator: (String? value) {
                          if (value!.isEmpty || value.trim().isEmpty) {
                            return "Field is required";
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    const Text(
                      "ชื่อเล่น",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
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
                          hintStyle: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    const Text(
                      "อีเมล",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
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
                          hintStyle: TextStyle(fontSize: 20),
                        ),
                        validator: (String? value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Field is required";
                          }
                          if (!RegExp(
                                  "^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]")
                              .hasMatch(value)) {
                            return "Please Enter valid email";
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    const Text(
                      "รหัสผ่าน",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
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
                          hintStyle: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    const Text(
                      "วันเกิด",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      child: TextFormField(
                        onChanged: (String? birthDay) {
                          user.birthDay = birthDay!;
                        },
                        keyboardType: TextInputType.datetime,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          hintText: "วว/ดด/ปปปป(พุทธศักราช)",
                          hintStyle: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    const Text(
                      "ท่านคือใคร",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: RadioListTile<ProductTypeEnum>(
                              contentPadding: const EdgeInsets.all(0.0),
                              value: ProductTypeEnum.Deliverable,
                              groupValue: _productTypeEnum,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                              activeColor: const Color.fromRGBO(0, 216, 133, 1),
                              title: const Text("นักเรียน"),
                              onChanged: (val) {
                                setState(() {
                                  _productTypeEnum = val;
                                  user.role = "Student";
                                });
                              }),
                        ),
                        Expanded(
                          child: RadioListTile<ProductTypeEnum>(
                              contentPadding: const EdgeInsets.all(0.0),
                              value: ProductTypeEnum.Donwloadable,
                              groupValue: _productTypeEnum,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                              activeColor: const Color.fromRGBO(0, 216, 133, 1),
                              title: const Text("ติวเตอร์"),
                              onChanged: (val) {
                                setState(() {
                                  _productTypeEnum = val;
                                  user.role = "Tutor";
                                });
                              }),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    const Text(
                      "รูปประจำตัว",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return user.role == "ติวเตอร์"
                                  ? const RegisterPage2()
                                  : const MyHomePage();
                            }));
                          },
                          child: const Text(
                            "ลงทะเบียน",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          )),
                    )
                  ]),
            )));
  }
}
