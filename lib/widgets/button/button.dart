import 'package:flutter/material.dart';
import '../../widgets/text/title16px.dart';

class Bt extends StatelessWidget {
  final String text;
  final Color color;
  final Color fontcolor;

  const Bt({
    super.key,
    required this.text,
    required this.color,
    this.fontcolor = const Color(0xFFFFFFFF),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: () {},
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
      ),
    );
  }
}
