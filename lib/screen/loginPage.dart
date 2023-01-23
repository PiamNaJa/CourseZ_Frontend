import 'package:coursez/controllers/auth_controller.dart';
import 'package:coursez/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:coursez/widgets/text/heading2_20px.dart';
import 'package:coursez/screen/Registerpage.dart';
import 'package:coursez/widgets/text/title16px.dart';

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
  late AuthController authController;
  int statusCode = 0;
  bool obsecureText = true;
  Icon visiblePassword = const Icon(Icons.visibility_off_outlined);

  @override
  void initState() {
    isEmailEmpty = true;
    isPasswordEmpty = true;
    emailController = TextEditingController();
    passwordController = TextEditingController();
    authController = AuthController();
    emailController.addListener(() {
      setState(() {
        isEmailEmpty = emailController.text.isEmpty;
      });
    });
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
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: Image.asset('assets/images/CourseZ_logo.png'),
              ),
              const Heading20px(
                text: 'ยินดีต้อนรับ',
                color: primaryColor,
              ),
              const Heading20px(text: 'โปรดเข้าสู่ระบบเพื่อใช้งาน'),
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
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(40))),
                                hintText: 'p@example.com',
                              ),
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (
                                format,
                              ) {
                                if (RegExp(
                                        r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+')
                                    .hasMatch(format!)) {
                                  return null;
                                } else {
                                  return 'รูปแบบอีเมลไม่ถูกต้อง';
                                }
                              }),
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
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(40))),
                                hintText: 'รหัสผ่าน',
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      obsecureText = !obsecureText;
                                      visiblePassword = obsecureText
                                          ? const Icon(
                                              Icons.visibility_off_outlined)
                                          : const Icon(
                                              Icons.visibility_outlined);
                                    });
                                  },
                                  icon: visiblePassword,
                                )),
                            controller: passwordController,
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: obsecureText,
                          )
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
                              ? () async {
                                  await authController.loginUser(
                                      emailController.text,
                                      passwordController.text);
                                  setState(() {
                                    statusCode = authController.statusCode;
                                  });
                                  if (statusCode == 200) {
                                    Navigator.popAndPushNamed(context, '/home');
                                  } else {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: const Text(
                                                'เข้าสู่ระบบไม่สำเร็จ'),
                                            content: const Text(
                                                'อีเมลหรือรหัสผ่านไม่ถูกต้อง'),
                                            actions: [
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                    passwordController.clear();
                                                  },
                                                  child: const Text('ตกลง'))
                                            ],
                                          );
                                        });
                                  }
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
                    )
                    // Bt(text: 'เข้าสู่ระบบ', color: primaryColor),
                  ])),
              TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/register');
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Title16px(
                        text: 'ยังไม่มีบัญชีผู้ใช้? ',
                        color: greyColor,
                      ),
                      Title16px(
                        text: 'ลงทะเบียน',
                        color: primaryColor,
                      )
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
