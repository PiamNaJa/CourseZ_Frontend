import 'package:coursez/controllers/auth_controller.dart';
import 'package:coursez/model/withdraw.dart';
import 'package:coursez/repository/withdraw_repository.dart';
import 'package:coursez/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WithDrawViewModel {
  static const List<List<String>> bankData = [
    ['กสิกรไทย', 'https://upload.wikimedia.org/wikipedia/th/d/d6/KBANK.png'],
    [
      'กรุงเทพ',
      'https://www.jobbkk.com/upload/employer/0E/E7E/007E7E/images/323822.jpg'
    ],
    [
      'กรุงไทย',
      'https://upload.wikimedia.org/wikipedia/en/thumb/f/f0/Krung_Thai_Bank_logo.svg/1200px-Krung_Thai_Bank_logo.svg.png'
    ],
    [
      'กรุงศรี',
      'https://i.pinimg.com/originals/ed/80/c6/ed80c67f6f6b484e3a09c85801a5e3c2.png'
    ],
    [
      'ไทยพาณิชย์',
      'https://www.isranews.org/images/2015/thaireform/01/scb.jpg'
    ],
    [
      'ออมสิน',
      'https://upload.wikimedia.org/wikipedia/th/thumb/4/4a/Logo_GSB_Thailand.svg/640px-Logo_GSB_Thailand.svg.png'
    ],
    [
      'ทรูวอลเล็ต',
      'https://download-th.com/wp-content/uploads/2021/02/True-money.jpg'
    ],
    [
      'พร้อมเพย์',
      'https://play-lh.googleusercontent.com/wK1lclwIGGTwAXGjHS6qYXk7R-_RQ7WtHY21KCbSNIIC079s3Yfbe8jaU4-hBTodfw'
    ],
  ];

  Future<void> createWithdraw(Withdraw withdraw) async {
    final AuthController authController = Get.find();
    final WithdrawRepository withdrawRepository = WithdrawRepository();
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token')!;
    final bool isPass = await withdrawRepository.addWithdraw(withdraw, token);
    if (!isPass) {
      Get.snackbar('ผิดพลาด', 'มีบางอย่างผิดพลาด',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: whiteColor);
    } else {
      authController.fetchUser(authController.userid);
      Get.back();
      Get.snackbar('สำเร็จ', 'ส่งคำร้องเรียบร้อย',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: primaryColor,
          colorText: whiteColor);
    }
  }
}
