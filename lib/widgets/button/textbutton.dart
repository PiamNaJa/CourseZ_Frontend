import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';

class ButtonText extends StatelessWidget {
  final String text;
  final Color color;
  final double size;
  final TextAlign position;
  final TextOverflow overflow;
  final String route;
  final bool isloadcourse;

  const ButtonText(
      {super.key,
      required this.text,
      required this.color,
      required this.size,
      required this.position,
      required this.route,
      required this.isloadcourse,
      this.overflow = TextOverflow.ellipsis});

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () {
          Get.toNamed(route, arguments: isloadcourse);
        },
        child: Text(text,
            style: TextStyle(
              color: color,
              fontSize: size,
              fontWeight: FontWeight.w700,
              fontFamily: 'Athiti',
              height: 1.5,
            ),
            textAlign: position,
            overflow: overflow));
  }
}
