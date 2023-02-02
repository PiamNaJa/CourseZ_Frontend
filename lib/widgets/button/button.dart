import 'package:flutter/material.dart';
import '../../widgets/text/title16px.dart';

class Bt extends StatelessWidget {
  final String text;
  final Color color;
  final Color fontcolor;
  final VoidCallback onPressed;

  const Bt(
      {super.key,
      required this.text,
      required this.color,
      this.fontcolor = const Color(0xFFFFFFFF),
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        child: Title16px(
          text: text,
          color: fontcolor,
        ),
      ),
    );
  }
}
