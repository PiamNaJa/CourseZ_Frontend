import 'package:coursez/controllers/auth_controller.dart';
import 'package:coursez/utils/color.dart';
import 'package:coursez/model/rewardInfo.dart';
import 'package:coursez/view_model/rewardInfo_view_model.dart';
import 'package:coursez/widgets/button/button.dart';
import 'package:coursez/widgets/text/heading2_20px.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import '../widgets/text/body10px.dart';
import '../widgets/text/body16.dart';
import '../widgets/text/title12px.dart';
import '../widgets/text/title14px.dart';

class MyRewardPage extends StatefulWidget {
  const MyRewardPage({super.key});

  @override
  State<MyRewardPage> createState() => _MyRewardPageState();
}

class _MyRewardPageState extends State<MyRewardPage> {
  final authController = Get.find<AuthController>();
  final RewardInfoViewModel rewardInfoViewModel = RewardInfoViewModel();
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
                  bottom: const PreferredSize(
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
                  if (snapshot.hasData &&
                      snapshot.data != null &&
                      snapshot.data!.isNotEmpty) {
                    return myRewardDetail(snapshot.data!);
                  } else {
                    return myRewardIsEmpty();
                  }
                },
              ));
        }
        return notLoginUI();
      },
    );
  }

  Widget myRewardDetail(List<RewardInfo> rewardData) {
    return LayoutBuilder(
      builder: (BuildContext context, Constraints constraints) {
        return SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            height: 720,
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: rewardData.length,
              itemBuilder: (context, index) {
                final rewardTime = rewardInfoViewModel
                    .formatReviewDate(rewardData[index].createdAt);
                final rewardDate = DateTime.parse(rewardTime);
                final now = DateTime.now();
                final differenceInDays = now.difference(rewardDate).inDays;
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
                              rewardData[index].item!.itempicture,
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
                                text: rewardData[index].item!.itemName,
                              ),
                              Body10px(text: rewardData[index].item!.itemTitle),
                              const SizedBox(height: 5),
                              (differenceInDays > 2)
                                  ? const Body16px(
                                      text: "รางวัลจัดส่งสำเร็จแล้ว",
                                      color: primaryColor,
                                    )
                                  : const Body16px(
                                      text: "กำลังจัดส่งรางวัล",
                                      color: tertiaryColor),
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

  Widget myRewardIsEmpty() {
    return Container(
      decoration: const BoxDecoration(color: whiteColor),
      child: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Image.network(
            'https://firebasestorage.googleapis.com/v0/b/coursez-50fb3.appspot.com/o/Images%2Ficon-compare-redeem-awards.png?alt=media&token=2e76f9ec-e732-4f09-937a-ea1495d6a183',
            fit: BoxFit.cover,
            height: 80,
          ),
          const Title14px(text: "ไม่มีรายละเอียดรางวัลของคุณ"),
          const SizedBox(height: 15),
        ]),
      ),
    );
  }

  Widget notLoginUI() {
    return Container(
      decoration: const BoxDecoration(color: whiteColor),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Title14px(text: "กรุณาเข้าสู่ระบบเพื่อดูรายละเอียดรางวัลของคุณ"),
        const SizedBox(height: 15),
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
