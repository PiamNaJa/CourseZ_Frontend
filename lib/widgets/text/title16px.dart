import 'package:flutter/material.dart';

class Title16px extends StatelessWidget {
  final Color color;
  final String text;
  final double size;
  final TextOverflow overflow;
  const Title16px(
      {super.key,
      this.color = const Color(0xFF000000),
      required this.text,
      this.size = 16,
      this.overflow = TextOverflow.ellipsis});

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: TextStyle(
            color: color,
            fontSize: size,
            fontWeight: FontWeight.w700,
            fontFamily: 'Athiti',
            height: 1.5),
        overflow: overflow);
  }
}
