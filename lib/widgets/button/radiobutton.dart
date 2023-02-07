import 'package:coursez/utils/color.dart';
import 'package:flutter/material.dart';

class RadioBt extends StatelessWidget {
  final String text;
  final Color fontcolor;
  final Color backgroundColor;
  final Color borderColor;
  final VoidCallback onPressed;
  const RadioBt(
      {super.key,
      required this.text,
      this.fontcolor = whiteColor,
      required this.onPressed,
      required this.backgroundColor,
      required this.borderColor});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(backgroundColor),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        side: MaterialStateProperty.all<BorderSide>(
          BorderSide(
            color: borderColor,
            width: 1,
          ),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(fontFamily: 'Athiti', color: fontcolor, fontSize: 14),
      ),
    );
  }
}
