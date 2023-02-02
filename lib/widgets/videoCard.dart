import 'package:coursez/utils/color.dart';
import 'package:coursez/widgets/text/body12px.dart';
import 'package:coursez/widgets/text/title12px.dart';
import 'package:flutter/material.dart';

class VideoCard extends StatelessWidget {
  final String image;
  final String name;
  final double width;
  final double height;
  final int price;
  final VoidCallback onPressed;
  const VideoCard(
      {super.key,
      required this.image,
      required this.name,
      required this.width,
      required this.height,
      required this.price,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: SizedBox(
        width: width,
        height: height,
        child: Column(
          children: [
            Stack(
              alignment: AlignmentDirectional.center,
              children: [
                ClipOval(
                    child: Image.network(
                  image,
                  width: 70,
                  height: 70,
                  fit: BoxFit.cover,
                )),
                (price > 0)
                    ? Positioned(
                        child: InkWell(
                        onTap: () {
                          debugPrint('lock');
                        },
                        child: ClipOval(
                          child: Container(
                            width: 70,
                            height: 70,
                            decoration: const BoxDecoration(
                              color: Color.fromRGBO(120, 120, 120, 0.8),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Body12px(
                                    text: '${price.toString()}.-',
                                    color: whiteColor),
                                const Icon(Icons.lock, color: whiteColor)
                              ],
                            ),
                          ),
                        ),
                      ))
                    : Container(),
              ],
            ),
            Title12px(text: name)
          ],
        ),
      ),
    );
  }
}
