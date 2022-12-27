import 'package:coursez/widgets/text/title16px.dart';
import 'package:flutter/material.dart';

class IconBt extends StatelessWidget {
  final String text;
  final double width;
  final Color color;
  final Color fontcolor;
  const IconBt(
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
          child: ElevatedButton.icon(
            icon: const Icon(Icons.add_circle_outline, size: 25,),
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            label: Title16px(
              text: text,
              color: fontcolor,
            ),
          ),
        ),
      ],
    );
  }
}
