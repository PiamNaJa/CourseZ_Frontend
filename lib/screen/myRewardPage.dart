import 'package:coursez/controllers/auth_controller.dart';
import 'package:coursez/model/user.dart';
import 'package:coursez/utils/color.dart';
import 'package:coursez/model/rewardInfo.dart';
import 'package:coursez/view_model/rewardInfo_view_model.dart';
import 'package:coursez/widgets/button/button.dart';
import 'package:coursez/widgets/text/body12px.dart';
import 'package:coursez/widgets/text/heading1_24px.dart';
import 'package:coursez/widgets/text/heading2_20px.dart';
import 'package:coursez/widgets/text/title16px.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/text/title14px.dart';

class MyRewardPage extends StatefulWidget {
  const MyRewardPage({super.key});

  @override
  State<MyRewardPage> createState() => _MyRewardPageState();
}

class _MyRewardPageState extends State<MyRewardPage> {
  final authController = Get.find<AuthController>();
  rewardInfoViewModel RewardInfoViewModel = rewardInfoViewModel();
  late Future<RewardInfo> dataReward;
  late Future<User> dataUser;
  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        if (authController.isLogin) {
          return Scaffold(
              appBar: AppBar(
                  elevation: 0.0,
                  title: const Heading20px(text: "รางวัลของฉัน"),
                  backgroundColor: whiteColor,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: primaryColor),
                    onPressed: () {
                      Get.back();
                    },
                  ),
                  bottom: PreferredSize(
                    preferredSize: Size.fromHeight(5.0),
                    child: Divider(
                      height: 1,
                      color: Colors.black,
                    ),
                  )),
              body: FutureBuilder(
                future: RewardInfoViewModel.getRewardInfoByUser(
                    authController.userid.toString()),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return myRewardDetail(snapshot.data!);
                  } else {
                    return MyRewardIsEmpty();
                  }
                },
              ));
        }
        return notLoginUI();
      },
    );
  }

  Widget myRewardDetail(RewardInfo rewardData) {
    return Center(
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 20),
            child: const Heading24px(text: "รางวัลของฉัน"),
          ),
          Container(
            margin: const EdgeInsets.only(top: 20),
            child: const Title16px(text: "รางวัลที่ได้รับ"),
          ),
          Container(
            margin: const EdgeInsets.only(top: 20),
            child: const Body12px(
                text: "รางวัลที่ได้รับจากการเข้าเรียนและทำแบบทดสอบ"),
          ),
          Container(
            margin: const EdgeInsets.only(top: 20),
            child: const Title16px(text: "รางวัลที่สะสมได้"),
          ),
          Container(
            margin: const EdgeInsets.only(top: 20),
            child: const Body12px(
                text: "รางวัลที่สะสมได้จากการเข้าเรียนและทำแบบทดสอบ"),
          ),
          Container(
            margin: const EdgeInsets.only(top: 20),
            child: const Title16px(text: "รางวัลที่สะสมได้"),
          ),
          Container(
            margin: const EdgeInsets.only(top: 20),
            child: const Body12px(
                text: "รางวัลที่สะสมได้จากการเข้าเรียนและทำแบบทดสอบ"),
          ),
        ],
      ),
    );
  }

  Widget MyRewardIsEmpty() {
    return Container(
      decoration: const BoxDecoration(color: whiteColor),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Image.network(
          'https://flyerbonus.bangkokair.com/images/icons/icon-compare-redeem-awards.png',
          fit: BoxFit.cover,
          height: 80,
        ),
        Title14px(text: "ไม่มีรายละเอียดรางวัลของคุณ"),
        SizedBox(height: 15),
      ]),
    );
  }

  Widget notLoginUI() {
    return Container(
      decoration: const BoxDecoration(color: whiteColor),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Title14px(text: "กรุณาเข้าสู่ระบบเพื่อดูรายละเอียดรางวัลของคุณ"),
        SizedBox(height: 15),
        Bt(
          onPressed: () {
            Get.toNamed('/login');
          },
          text: "ลงทะเบียน / เข้าสู่ระบบ",
          color: primaryColor,
        )
      ]),
    );
  }
}
