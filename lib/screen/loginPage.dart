import 'package:coursez/utils/color.dart';
import 'package:coursez/view_model/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:coursez/widgets/text/heading2_20px.dart';
import 'package:coursez/widgets/text/title16px.dart';
import 'package:get/get.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  late bool isEmailEmpty;
  late bool isPasswordEmpty;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late AuthViewModel authViewModel;
  late bool isVisiblePassword;

  @override
  void initState() {
    isEmailEmpty = true;
    isPasswordEmpty = true;
    emailController = TextEditingController();
    passwordController = TextEditingController();
    authViewModel = AuthViewModel();
    emailController.addListener(() {
      setState(() {
        isEmailEmpty = emailController.text.isEmpty;
      });
    });
    isVisiblePassword = false;
    passwordController.addListener(() {
      setState(() {
        isPasswordEmpty = passwordController.text.isEmpty;
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: primaryLighterColor,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: primaryLighterColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: primaryColor),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 40),
                    child: Image.asset('assets/images/CourseZ_logo.png'),
                  ),
                  const Heading20px(
                    text: 'ยินดีต้อนรับ',
                  ),
                  const Heading20px(text: 'โปรดเข้าสู่ระบบเพื่อใช้งาน'),
                ],
              ),
            ),
            Stack(children: [
              Container(
                height: screenHeight * 0.51,
                decoration: BoxDecoration(
                    color: whiteColor,
                    borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(30),
                        topLeft: Radius.circular(30)),
                    boxShadow: [
                      BoxShadow(
                          color: blackColor.withOpacity(0.4),
                          spreadRadius: 5,
                          blurRadius: 7)
                    ]),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    Form(
                        key: formKey,
                        child: Column(children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.only(bottom: 5),
                                  alignment: Alignment.centerLeft,
                                  child: const Heading20px(text: 'อีเมล'),
                                ),
                                TextFormField(
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20))),
                                    hintText: 'p@example.com',
                                  ),
                                  controller: emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: ((value) =>
                                      RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+')
                                              .hasMatch(value!)
                                          ? null
                                          : 'รูปแบบอีเมลไม่ถูกต้อง'),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.only(bottom: 5),
                                  alignment: Alignment.centerLeft,
                                  child: const Heading20px(text: 'รหัสผ่าน'),
                                ),
                                TextFormField(
                                  cursorColor: primaryColor,
                                  decoration: InputDecoration(
                                      border: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20))),
                                      hintText: 'รหัสผ่าน',
                                      suffixIcon: InkWell(
                                          onTap: () {
                                            setState(() {
                                              isVisiblePassword =
                                                  !isVisiblePassword;
                                            });
                                          },
                                          child: Icon(
                                            !isVisiblePassword
                                                ? Icons.visibility_off_outlined
                                                : Icons.visibility_outlined,
                                          ))),
                                  controller: passwordController,
                                  keyboardType: TextInputType.visiblePassword,
                                  obscureText:
                                      !isVisiblePassword ? true : false,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: !isEmailEmpty && !isPasswordEmpty
                                    ? () {
                                        authViewModel.login(
                                            emailController.text,
                                            passwordController.text,
                                            context);
                                      }
                                    : null,
                                style: ElevatedButton.styleFrom(
                                  disabledBackgroundColor: primaryLighterColor,
                                  backgroundColor: primaryColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                                child: const Title16px(
                                  text: 'เข้าสู่ระบบ',
                                  color: whiteColor,
                                ),
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Title16px(
                                text: 'ยังไม่มีบัญชีผู้ใช้?',
                                color: greyColor,
                              ),
                              TextButton(
                                  onPressed: () => Get.toNamed('/register'),
                                  child: const Title16px(
                                    text: 'ลงทะเบียน',
                                    color: primaryColor,
                                  )),
                            ],
                          )
                        ])),
                  ],
                ),
              )
            ])
          ],
        ),
      ),
    );
  }
}
