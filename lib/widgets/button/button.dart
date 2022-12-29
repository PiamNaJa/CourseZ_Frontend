import 'package:coursez/widgets/text/title16px.dart';
import 'package:flutter/material.dart';

class Bt extends StatelessWidget {
  final String text;
  final double width;
  final Color color;
  final Color fontcolor;
  const Bt(
      {super.key,
      required this.text,
      required this.width,
      required this.color,
      this.fontcolor = const Color(0xFFFFFFFF)});

  @override
  Widget build(BuildContext context) {
    return ButtonBar(
      alignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: width,
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
      ],
    );
  }
}
