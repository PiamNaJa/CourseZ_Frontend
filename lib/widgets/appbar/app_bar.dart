import 'package:coursez/utils/color.dart';
import 'package:coursez/widgets/text/heading1_24px.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  const CustomAppBar({super.key, required this.title});

  @override
  PreferredSizeWidget build(BuildContext context) {
    return AppBar(
      elevation: 0.0,
      titleSpacing: 0.0,
      title: Heading24px(text: title),
      backgroundColor: Colors.transparent,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: primaryColor),
        onPressed: () {
          Get.back();
        },
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(60);
}
