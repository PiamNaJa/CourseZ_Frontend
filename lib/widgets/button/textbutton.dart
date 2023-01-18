import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class ButtonText extends StatelessWidget {
  final String text;
  final Color color;
  final double size;
  final TextAlign position;
  final TextOverflow overflow;
  final String route;

  const ButtonText(
      {super.key,
      required this.text,
      required this.color,
      required this.size,
      required this.position,
      required this.route,
      this.overflow = TextOverflow.ellipsis});

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () {
          Navigator.pushNamed(context, route);
        },
        child: Text(text,
            style: TextStyle(
              color: color,
              fontSize: size,
              fontWeight: FontWeight.w700,
              fontFamily: 'Athiti',
              height: 1.5,
            ),
            textAlign: position,
            overflow: overflow));
  }
}
