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
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import '../model/rewardItem.dart';
import '../widgets/text/body10px.dart';
import '../widgets/text/title12px.dart';
import '../widgets/text/title14px.dart';

class MyRewardPage extends StatefulWidget {
  const MyRewardPage({super.key});

  @override
  State<MyRewardPage> createState() => _MyRewardPageState();
}

class _MyRewardPageState extends State<MyRewardPage> {
  final authController = Get.find<AuthController>();
  RewardInfoViewModel rewardInfoViewModel = RewardInfoViewModel();
  late Future<List<RewardInfo>> dataReward;
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
                future: rewardInfoViewModel
                    .getRewardInfoByUser(authController.userid.toString()),
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

  Widget myRewardDetail(List<RewardItem> rewardData) {
    return LayoutBuilder(
      builder: (BuildContext context, Constraints constraints) {
        return SingleChildScrollView(
          child: Container(
            height: 720,
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: rewardData.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Get.toNamed('/reward/${rewardData[index].itemId}/status');
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: whiteColor,
                        border: Border.all(color: greyColor, width: 0.6),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(
                            color: greyColor,
                            blurRadius: 5,
                            offset: Offset(0, 1),
                          )
                        ]),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10)),
                            child: Image.network(
                              rewardData[index].itempicture,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Title12px(
                                text: rewardData[index].itemName,
                              ),
                              Body10px(
                                text: rewardData[index].itemTitle,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget MyRewardIsEmpty() {
    return Container(
      decoration: const BoxDecoration(color: whiteColor),
      child: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Image.network(
            'https://flyerbonus.bangkokair.com/images/icons/icon-compare-redeem-awards.png',
            fit: BoxFit.cover,
            height: 80,
          ),
          Title14px(text: "ไม่มีรายละเอียดรางวัลของคุณ"),
          SizedBox(height: 15),
        ]),
      ),
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
