import 'package:coursez/controllers/auth_controller.dart';
import 'package:coursez/controllers/reward_controller.dart';
import 'package:coursez/model/address.dart';
import 'package:coursez/model/rewardInfo.dart';
import 'package:coursez/model/rewardItem.dart';
import 'package:coursez/utils/color.dart';
import 'package:coursez/view_model/address_view_model.dart';
import 'package:coursez/view_model/reward_view_model.dart';
import 'package:coursez/widgets/button/button.dart';
import 'package:coursez/widgets/text/body12px.dart';
import 'package:coursez/widgets/text/body14px.dart';
import 'package:coursez/widgets/text/body16.dart';
import 'package:coursez/widgets/text/heading1_24px.dart';
import 'package:coursez/widgets/text/heading2_20px.dart';
import 'package:coursez/widgets/text/title14px.dart';
import 'package:coursez/widgets/text/title16px.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RewardBillPage extends StatelessWidget {
  const RewardBillPage({super.key});

  @override
  Widget build(BuildContext context) {
    final RewardController rewardController = Get.find();
    final AuthController authController = Get.find();
    final AddressViewModel addressViewModel = AddressViewModel();
    final RewardVIewModel rewardVIewModel = RewardVIewModel();

    onSubmit() async {
      rewardVIewModel.addRewardInfo(
          rewardController.itemid);
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        titleSpacing: 0.0,
        title: const Heading24px(text: 'ยืนยันข้อมูล'),
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: primaryColor),
          onPressed: () {
            showDialog(
                context: context,
                builder: ((context) {
                  return AlertDialog(
                    title: const Heading20px(text: 'ยืนยันการยกเลิก'),
                    content: const Body16px(
                        text: 'คุณต้องการยกเลิกการสั่งซื้อหรือไม่'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Get.back();
                        },
                        child: const Body14px(text: 'ดำเนินการต่อ'),
                      ),
                      TextButton(
                        onPressed: () {
                          Get.back();
                          Get.back();
                        },
                        child: const Title14px(
                            text: 'ยกเลิกคำสั่งซื้อ', color: Colors.red),
                      ),
                    ],
                  );
                }));
          },
        ),
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [
          Container(
            decoration: const BoxDecoration(color: primaryLightColor),
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Heading20px(text: 'การจัดส่งของรางวัล'),
                    Body16px(text: 'จะจัดส่งภายใน 1-2 วัน')
                  ],
                ),
                const Icon(
                  Icons.local_shipping,
                  color: blackColor,
                  size: 75,
                )
              ],
            ),
          ),
          FutureBuilder(
              future:
                  addressViewModel.loadAddressByuserId(authController.userid),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  return userInfo(snapshot.data);
                } else {
                  return const CircularProgressIndicator();
                }
              }),
          FutureBuilder(
              future: rewardVIewModel.loadRewardById(rewardController.itemid),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  return rewardInfo(snapshot.data);
                } else {
                  return const CircularProgressIndicator();
                }
              }),
        ],
      )),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(width: 1, color: primaryDarkColor),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Body16px(text: 'รวมทั้งหมด'),
            const SizedBox(
              width: 10,
            ),
            FutureBuilder(
                future: rewardVIewModel.loadRewardById(rewardController.itemid),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return Title14px(
                      text: '${snapshot.data.itemCost.toString()} แต้ม',
                      color: primaryColor,
                    );
                  } else {
                    return const CircularProgressIndicator();
                  }
                }),
            const SizedBox(
              width: 10,
            ),
            SizedBox(
                width: MediaQuery.of(context).size.width * 0.2,
                child: Bt(
                    text: 'ยืนยัน',
                    color: primaryColor,
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: ((context) {
                            return AlertDialog(
                              title:
                                  const Heading20px(text: 'ยืนยันการสั่งซื้อ'),
                              content: const Body16px(
                                  text: 'คุณต้องการสั่งซื้อหรือไม่'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Get.back();
                                  },
                                  child: const Body14px(
                                    text: 'ยกเลิก',
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    onSubmit();
                                    
                                  },
                                  child: const Title14px(
                                      text: 'สั่งซื้อ', color: primaryColor),
                                ),
                              ],
                            );
                          }));
                    }))
          ],
        ),
      ),
    );
  }

  Widget userInfo(Address address) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: greyColor,
            width: 1,
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(
                Icons.location_on_outlined,
                size: 40,
              ),
              const SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Heading20px(text: 'ที่อยู่สำหรับจัดส่ง'),
                  Body12px(text: 'บ้านเลขที่ ${address.houseNo}'),
                  Body12px(
                      text:
                          'ตำบล ${address.subDistrict} อำเภอ ${address.district} '),
                  Body12px(
                      text: 'จังหวัด ${address.province} ${address.postal}')
                ],
              ),
            ],
          ),
          IconButton(
            icon: const Icon(
              Icons.edit,
              size: 30,
            ),
            onPressed: () {
              Get.toNamed('/address', arguments: address, parameters: {
                'isEdit': 'true',
              });
            },
          )
        ],
      ),
    );
  }

  Widget rewardInfo(RewardItem item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 20),
          child: Heading24px(text: 'ของรางวัล'),
        ),
        Container(
          decoration: const BoxDecoration(
            border: Border(
                bottom: BorderSide(
                  color: greyColor,
                  width: 1,
                ),
                top: BorderSide(
                  color: greyColor,
                  width: 1,
                )),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          child: ListTile(
            leading: Image.network(item.itempicture),
            title: Text(
              item.itemName,
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
            trailing: Title14px(text: '${item.itemCost} แต้ม'),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Title16px(text: 'คะแนนที่ใช้'),
              Title14px(text: '${item.itemCost} แต้ม'),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Body16px(text: 'ค่าจัดส่ง'),
              Body14px(text: 'ฟรี', color: primaryColor),
            ],
          ),
        ),
      ],
    );
  }
}
