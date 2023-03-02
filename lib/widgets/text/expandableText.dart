import 'package:coursez/utils/color.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';

class ExpandText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final int maxLines;
  const ExpandText({
    super.key,
    required this.text,
    required this.style,
    required this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return ExpandableText(
      text,
      style: style,
      expandText: 'ดูเพิ่มเติม',
      collapseText: 'ดูน้อยลง',
      expandOnTextTap: true,
      collapseOnTextTap: true,
      maxLines: maxLines,
      animation: true,
      linkColor: secondaryColor,
    );
  }
}
