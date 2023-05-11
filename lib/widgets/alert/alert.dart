import 'package:coursez/utils/color.dart';
import 'package:coursez/widgets/text/body14px.dart';
import 'package:coursez/widgets/text/heading1_24px.dart';
import 'package:coursez/widgets/text/title14px.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';

class AlertLogin extends StatelessWidget {
  final String body;
  final String action;
  const AlertLogin({super.key, required this.body, required this.action});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Heading24px(text: 'กรุณาเข้าสู่ระบบ'),
      content: Container(
          height: MediaQuery.of(context).size.height * 0.05,
          alignment: Alignment.center,
          child: Body14px(text: body)),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context, false);
          },
          child: const Title14px(
            text: 'ย้อนกลับ',
            color: greyColor,
          ),
        ),
        TextButton(
          onPressed: () {
            // Get.toNamed('/login');
            Navigator.pop(context, false);
            Navigator.pushNamed(context, '/login');
          },
          child: Title14px(
            text: action,
            color: primaryColor,
          ),
        )
      ],
    );
  }
}
