import 'dart:io';
import 'package:coursez/model/user.dart';
import 'package:coursez/screen/Register2.dart';
import 'package:coursez/view_model/auth_view_model.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

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
      debugPrint("Fail to pick image : $e");
    }
  }

  final formkey = GlobalKey<FormState>();
  final AuthViewModel authViewModel = AuthViewModel();

  onSubmit() async {
    if (formkey.currentState!.validate()) {
      formkey.currentState!.save();
      if (image == null) {
        Get.snackbar("กรุณาเลือกรูปภาพ", "กรุณาเลือกรูปภาพ",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white);
        return;
      }
      user.role == "Tutor"
          ? Get.toNamed('/register2',
              arguments: user, parameters: {'image': image!.path})
          : authViewModel.registerStudent(user, image);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
            padding: const EdgeInsets.fromLTRB(22, 22, 22, 22),
            child: Form(
              key: formkey,
              child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "โปรดกรอกข้อมูลให้ครบถ้วน",
                        style: TextStyle(
                            fontFamily: 'Athiti',
                            fontSize: 24,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Center(
                          child: image != null
                              ? Stack(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: ClipOval(
                                          child: Image.file(
                                        image!,
                                        height: 150,
                                        width: 150,
                                        fit: BoxFit.cover,
                                      )),
                                    ),
                                    Positioned(
                                      bottom: 120,
                                      left: 110,
                                      child: RawMaterialButton(
                                        onPressed: () {
                                          pickImage();
                                        },
                                        elevation: 2.0,
                                        fillColor: const Color.fromRGBO(
                                            0, 216, 133, 1),
                                        padding: const EdgeInsets.all(15.0),
                                        shape: const CircleBorder(),
                                        child: const Icon(
                                          color: Colors.white,
                                          Icons.edit,
                                          size: 35.0,
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
                                    height: 200,
                                    decoration: const BoxDecoration(
                                        color: Colors.grey,
                                        shape: BoxShape.circle),
                                    child: const Center(
                                      child: Icon(
                                        Icons.add_a_photo_outlined,
                                        size: 100,
                                      ),
                                    ),
                                  ),
                                )),
                      const Text(
                        "ชื่อจริง-นามสกุล",
                        style: TextStyle(
                            fontFamily: 'Athiti',
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
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
                            hintStyle:
                                TextStyle(fontFamily: 'Athiti', fontSize: 20),
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
                      const Text(
                        "ชื่อเล่น",
                        style: TextStyle(
                            fontFamily: 'Athiti',
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
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
                            hintStyle:
                                TextStyle(fontFamily: 'Athiti', fontSize: 20),
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
                      const Text(
                        "อีเมล",
                        style: TextStyle(
                            fontFamily: 'Athiti',
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
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
                            hintStyle:
                                TextStyle(fontFamily: 'Athiti', fontSize: 20),
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
                      const Text(
                        "รหัสผ่าน",
                        style: TextStyle(
                            fontFamily: 'Athiti',
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
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
                              hintStyle:
                                  TextStyle(fontFamily: 'Athiti', fontSize: 20),
                            ),
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: ((value) {
                              if (value!.isEmpty) {
                                return "โปรดกรอกรหัสผ่านของคุณ";
                              } else if (value.length < 6) {
                                return "รหัสผ่านควรยาวกว่า 6 ตัว";
                              }
                              return null;
                            })),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      const Text(
                        "ท่านคือใคร",
                        style: TextStyle(
                            fontFamily: 'Athiti',
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
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
                                activeColor:
                                    const Color.fromRGBO(0, 216, 133, 1),
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
                                activeColor:
                                    const Color.fromRGBO(0, 216, 133, 1),
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

                      /*ElevatedButton.icon(
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
                      ),*/
                      const SizedBox(
                        height: 12,
                      ),
                      SizedBox(
                        height: 40,
                        width: double.infinity,
                        child: ElevatedButton(
                            style: const ButtonStyle(
                                backgroundColor:
                                    MaterialStatePropertyAll<Color>(
                                        Color.fromRGBO(0, 216, 133, 1))),
                            onPressed: onSubmit,
                            child: const Text(
                              "ลงทะเบียน",
                              style: TextStyle(
                                  fontFamily: 'Athiti',
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            )),
                      )
                    ]),
              ),
            )));
  }
}
