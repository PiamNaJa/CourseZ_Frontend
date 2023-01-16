import 'package:coursez/widgets/text/title12px.dart';
import 'package:flutter/material.dart';

class VideoCard extends StatelessWidget {
  final String image;
  final String name;
  final double width;
  final double height;
  final VoidCallback onPressed;
  const VideoCard(
      {super.key,
      required this.image,
      required this.name,
      required this.width,
      required this.height,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return InkWell(
        onTap: onPressed,
        child: SizedBox(
          width: width,
          height: height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Image.network(image), Title12px(text: name)],
          ),
        ),
      );
    });
  }
}
