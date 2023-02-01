import 'package:coursez/utils/color.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';

class CoursePage extends StatelessWidget {
  CoursePage({super.key});
  final data = Get.arguments;

  @override
  Widget build(BuildContext context) {
    debugPrint(data.toString());
    return Container(
      color: whiteColor,
    );
  }
}
