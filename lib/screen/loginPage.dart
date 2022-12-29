import 'package:coursez/utils/color.dart';
import 'package:coursez/widget/button/button.dart';
import 'package:coursez/widget/text/title16px.dart';
import 'package:flutter/material.dart';
import 'package:coursez/widget/text/heading2_20px.dart';
import 'package:coursez/widget/textField/Textformfield.dart';

class loginPage extends StatefulWidget {
  const loginPage({super.key});

  @override
  State<loginPage> createState() => _loginPageState();
}

class _loginPageState extends State<loginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: primaryColor),
          onPressed: () {
            // Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30),
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
              const Textformfield(
                icon: Icon(Icons.email),
                hintText: 'p@example.com',
                labelText: 'อีเมลหรือเบอร์โทรศัพท์',
              ),
              const Textformfield(
                  icon: Icon(Icons.password),
                  hintText: 'รหัสผ่าน',
                  labelText: 'รหัสผ่าน'),
              const Bt(text: 'เข้าสู่ระบบ', color: primaryColor),
              TextButton(
                  onPressed: () {},
                  child: const Title16px(
                    text: 'ลงทะเบียน',
                    color: primaryColor,
                  )
              )
            ],
          ),
        ),
      ),
    );
  }
}
