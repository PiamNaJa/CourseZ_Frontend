import 'package:coursez/controllers/auth_controller.dart';
import 'package:coursez/controllers/reward_controller.dart';
import 'package:coursez/model/rewardItem.dart';
import 'package:coursez/utils/color.dart';
import 'package:coursez/view_model/address_view_model.dart';
import 'package:coursez/view_model/reward_view_model.dart';
import 'package:coursez/widgets/text/heading1_24px.dart';
import 'package:coursez/widgets/text/heading1_30px.dart';
import 'package:coursez/widgets/text/title14px.dart';
import 'package:coursez/widgets/text/title16px.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RewardPage extends StatelessWidget {
  RewardPage({super.key});
  final RewardVIewModel rewardVIewModel = RewardVIewModel();

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find();
    return Scaffold(
        backgroundColor: primaryLighterColor,
        appBar: AppBar(
          elevation: 0.0,
          titleSpacing: 0.0,
          title: const Heading24px(text: 'คะแนนของฉัน'),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: primaryColor),
            onPressed: () {
              Get.back();
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(CupertinoIcons.tickets_fill, color: blackColor),
              onPressed: () {
                Get.toNamed('/myreward');
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Obx(() {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 25),
                    child: Heading30px(
                      text: '${authController.point.toString()} แต้ม',
                      color: primaryColor,
                    ),
                  ),
                );
              }),
              Container(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height * 0.8,
                  minWidth: MediaQuery.of(context).size.width,
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: FutureBuilder(
                  future: rewardVIewModel.loadReward(),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      return (snapshot.data.length == 0)
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Title16px(
                                      text:
                                          'ขออภัยครับ/ ค่ะ ขณะนี้ยังไม่มีรางวัลให้แลก',
                                      color: greyColor),
                                  Icon(
                                    Icons.sentiment_dissatisfied_outlined,
                                    color: greyColor,
                                    size: 50,
                                  )
                                ],
                              ),
                            )
                          : Column(
                              children: [
                                const Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 12),
                                      child:
                                          Heading24px(text: 'ของรางวัลทั้งหมด'),
                                    )),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                  child: Center(
                                    child: Wrap(
                                      spacing:
                                          MediaQuery.of(context).size.width *
                                              0.08,
                                      runSpacing:
                                          MediaQuery.of(context).size.width *
                                              0.08,
                                      children: [
                                        for (var item in snapshot.data)
                                          rewardList(item)
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            );
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              )
            ],
          ),
        ));
  }

  Widget rewardList(RewardItem item) {
    final AddressViewModel addressViewModel = AddressViewModel();
    final AuthController authController = Get.find();
    final RewardController rewardController = Get.put(RewardController());

    return InkWell(
      onTap: () {
        showDialog(
            context: Get.context!,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Heading24px(text: 'รายละเอียดรางวัล'),
                content: SingleChildScrollView(
                  child: Column(
                    children: [
                      ClipRRect(
                        child: Image.network(
                          item.itempicture,
                          height: 400,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Align(
                          alignment: Alignment.centerRight,
                          child:
                              Heading24px(text: 'ราคา ${item.itemCost} แต้ม')),
                      const SizedBox(height: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.itemName,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            item.itemTitle,
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: const Title16px(
                      text: 'กลับ',
                      color: greyColor,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      //alert dialog
                      showDialog(
                          context: Get.context!,
                          builder: ((BuildContext context) {
                            return AlertDialog(
                                title: const Heading24px(text: 'แลกรางวัล'),
                                content: const Text(
                                    'คุณต้องการแลกรางวัลนี้ใช่หรือไม่'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Get.back();
                                    },
                                    child: const Title16px(
                                      text: 'ยกเลิก',
                                      color: greyColor,
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      if (authController.point <
                                          item.itemCost) {
                                        Get.back();
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: const Heading24px(
                                                  text: 'แจ้งเตือน'),
                                              content: const Text(
                                                  'คุณมีแต้มไม่เพียงพอ ต้องไปทำแบบฝึกหัดก่อนนะจ๊ะ'),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Get.back();
                                                  },
                                                  child: const Title16px(
                                                    text: 'ตกลง',
                                                    color: primaryColor,
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                        return;
                                      }
                                      Get.back();
                                      Get.back();
                                      rewardController.itemid = item.itemId;
                                      await (addressViewModel.checkAddress(
                                              authController.userid))
                                          ? Get.toNamed('/rewardbill')
                                          : Get.toNamed('/address');
                                      // Get.toNamed();
                                    },
                                    child: const Title16px(
                                      text: 'ยืนยัน',
                                      color: primaryColor,
                                    ),
                                  ),
                                ]);
                          }));
                    },
                    child: const Title16px(
                      text: 'แลกรางวัล',
                      color: primaryColor,
                    ),
                  ),
                ],
              );
            });
      },
      child: Container(
        width: MediaQuery.of(Get.context!).size.width * 0.4,
        decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                child: Image.network(
                  item.itempicture,
                  width: MediaQuery.of(Get.context!).size.width * 0.4,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Title16px(
                    text: '${item.itemCost} แต้ม',
                    color: whiteColor,
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Title14px(text: item.itemName),
                Text(
                  item.itemTitle,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                )
              ],
            ),
          )
        ]),
      ),
    );
  }
}
