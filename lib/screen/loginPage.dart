import 'package:coursez/controllers/auth_controller.dart';
import 'package:coursez/screen/Reg.dart';
import 'package:coursez/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:coursez/widgets/text/heading2_20px.dart';
import 'package:form_field_validator/form_field_validator.dart';
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
  AuthController? authController;

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
                child: Image.asset('assets/images/CourseZ_logo.jpg'),
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
                              validator: RequiredValidator(
                                  errorText: 'อีเมลไม่ถูกต้อง')),
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
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(40))),
                                  hintText: 'รหัสผ่าน',
                                  suffixIcon:
                                      Icon(Icons.visibility_off_outlined)),
                              controller: passwordController,
                              keyboardType: TextInputType.visiblePassword,
                              obscureText: true,
                              validator: RequiredValidator(
                                  errorText: 'รหัสผ่านไม่ถูกต้อง')),
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
                                  await authController?.loginUser(
                                      emailController.text,
                                      passwordController.text);
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
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return const RegisterPage();
                    }));
                  },
                  child: const Title16px(
                    text: 'ลงทะเบียน',
                    color: primaryColor,
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
