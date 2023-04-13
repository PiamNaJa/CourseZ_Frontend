import 'package:coursez/utils/color.dart';
import 'package:coursez/widgets/text/body16.dart';
import 'package:flutter/material.dart';

class BankButton extends StatelessWidget {
  String title;
  String image;
  VoidCallback onPressed;
  BankButton(
      {super.key,
      required this.title,
      required this.image,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          color: primaryLightColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(children: [
          ClipOval(
              child: Image.network(image,
                  width: 40, height: 40, fit: BoxFit.cover)),
          const SizedBox(width: 20),
          Body16px(text: title)
        ]),
      ),
    );
  }
}
