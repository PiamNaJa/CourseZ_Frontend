import 'package:coursez/utils/color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class BorderIcon extends StatelessWidget {
  final Widget child;
  final double width;
  final double height;
  const BorderIcon(
      {super.key,
      required this.child,
      required this.width,
      required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: whiteColor.withOpacity(0.8),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Center(
        child: child,
      ),
    );
  }
}
