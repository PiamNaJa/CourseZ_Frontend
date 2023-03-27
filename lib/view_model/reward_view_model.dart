import 'package:coursez/controllers/auth_controller.dart';
import 'package:coursez/model/rewardItem.dart';
import 'package:coursez/repository/reward_repository.dart';
import 'package:coursez/utils/color.dart';
import 'package:coursez/utils/fetchData.dart';
import 'package:coursez/widgets/text/body14px.dart';
import 'package:coursez/widgets/text/heading2_20px.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RewardVIewModel {
  Future<List<RewardItem>> loadReward() async {
    List<RewardItem> reward = [];
    final r = await fecthData("reward/item");
    reward = List.from(r.map((e) => RewardItem.fromJson(e)).toList());
    return reward;
  }

  Future<RewardItem> loadRewardById(int itemid) async {
    final r = await fecthData("reward/item/$itemid");
    return RewardItem.fromJson(r);
  }

  Future<void> addRewardInfo(int itemid) async {
    AuthController authController = Get.find();
    RewardRepository rewardRepository = RewardRepository();
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token')!;
    final bool isPass = await rewardRepository.addRewardInfo(itemid, token);
    if (!isPass) {
      Get.snackbar('ผิดพลาด', 'มีบางอย่างผิดพลาด',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: whiteColor);
    } else {
      Get.back();
      showDialog(
          context: Get.context!,
          builder: ((context) {
            return AlertDialog(
              title: Row(
                children: const [
                  Heading20px(text: 'สั่งซื้อสำเร็จ'),
                  SizedBox(
                    width: 10,
                  ),
                  Icon(
                    Icons.check_circle,
                    color: primaryColor,
                  ),
                ],
              ),
              content: const Text(
                  'คุณสามารถตรวจสอบสถานะการสั่งซื้อได้ที่คูปองของฉันหน้าแลกของรางวัล'),
              actions: [
                TextButton(
                  onPressed: () {
                    Get.back();
                    Get.back();
                    authController.fetchUser(authController.userid);
                  },
                  child: const Body14px(
                    text: 'ตกลง',
                    color: primaryColor,
                  ),
                ),
              ],
            );
          }));
    }
  }
}
