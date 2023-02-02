import 'package:coursez/controllers/auth_controller.dart';
import 'package:coursez/utils/color.dart';
import 'package:coursez/widgets/alert/alert.dart';
import 'package:coursez/widgets/text/body12px.dart';
import 'package:coursez/widgets/text/title12px.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VideoCard extends StatelessWidget {
  final String image;
  final String name;
  final double width;
  final double height;
  final int price;
  final VoidCallback onTap;
  VideoCard(
      {super.key,
      required this.image,
      required this.name,
      required this.width,
      required this.height,
      required this.price,
      required this.onTap});
  AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
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
                        child: ClipOval(
                        child: InkWell(
                          onTap: () {
                            if (!authController.isLogin) {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return const AlertLogin(
                                      body: 'กรุณาเข้าสู่ระบบเพื่อซื้อวีดิโอ',
                                      action: 'เข้าสู่ระบบ',
                                    );
                                  });
                            }
                          },
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
