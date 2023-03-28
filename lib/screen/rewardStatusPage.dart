import 'package:coursez/controllers/auth_controller.dart';
import 'package:coursez/model/address.dart';
import 'package:coursez/model/rewardInfo.dart';
import 'package:coursez/model/rewardItem.dart';
import 'package:coursez/model/user.dart';
import 'package:coursez/screen/home.dart';
import 'package:coursez/utils/color.dart';
import 'package:coursez/view_model/rewardInfo_view_model.dart';
import 'package:coursez/widgets/button/button.dart';
import 'package:coursez/widgets/text/body14px.dart';
import 'package:coursez/widgets/text/body16.dart';
import 'package:coursez/widgets/text/heading2_20px.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import '../widgets/text/body10px.dart';
import '../widgets/text/heading1_24px.dart';
import '../widgets/text/title12px.dart';
import '../widgets/text/title14px.dart';
import '../widgets/text/title16px.dart';

class RewardStatusPage extends StatefulWidget {
  const RewardStatusPage({super.key});

  @override
  State<RewardStatusPage> createState() => _RewardStatusPageState();
}

class _RewardStatusPageState extends State<RewardStatusPage> {
  final authController = Get.find<AuthController>();
  RewardInfoViewModel rewardInfoViewModel = RewardInfoViewModel();
  String rewardID = Get.parameters["reward_id"]!;
  late Future<RewardInfo> dataReward;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            elevation: 0.0,
            title: const Heading20px(text: "สถานะการจัดส่ง"),
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
          future: rewardInfoViewModel.getRewardInfoByID(rewardID.toString()),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return rewardStatusDetail(snapshot.data!);
            } else {
              return const Center(
                  child: CircularProgressIndicator(
                color: primaryColor,
              ));
            }
          },
        ));
  }

  Widget rewardStatusDetail(RewardInfo rewardData) {
    return Container(
      child: Column(
        children: [
          // Container(
          //   padding: EdgeInsets.only(
          //     left: MediaQuery.of(Get.context!).size.width * 0.02,
          //   ),
          //   color: primaryLightColor,
          //   height: 70,
          //   child: LayoutBuilder(builder: (context, constraints) {
          //     return Column(
          //       children: [
          //         Row(
          //           children: [
          //             Padding(
          //               padding:
          //                   EdgeInsets.only(top: 20, left: 10.0, right: 70),
          //               child: Title16px(text: authController.username),
          //             ),
          //           ],
          //         ),
          //         const SizedBox(height: 15),
          //       ],
          //     );
          //   }),
          // ),
          const PreferredSize(
            preferredSize: Size.fromHeight(2.0),
            child: Divider(
              height: 1,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 15),
          Row(children: [
            Container(
              padding: EdgeInsets.only(
                left: MediaQuery.of(Get.context!).size.width * 0.02,
              ),
              // color: Colors.red,
              width: MediaQuery.of(Get.context!).size.width * 0.93,
              child: LayoutBuilder(builder: (context, constraints) {
                return Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.network(
                        rewardData.item!.itempicture,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                      width: constraints.maxWidth * 0.65,
                      decoration: const BoxDecoration(
                        color: whiteColor,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(15),
                          bottomRight: Radius.circular(15),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 20),
                        child: SizedBox(
                            width: constraints.maxWidth * 0.62 - 10,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Title16px(text: rewardData.item!.itemName),
                                Text(
                                  rewardData.item!.itemTitle,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      color: blackColor,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w400),
                                ),
                              ],
                            )),
                      ),
                    ),
                  ],
                );
              }),
            )
          ]),
          const SizedBox(height: 15),
          const PreferredSize(
            preferredSize: Size.fromHeight(2.0),
            child: Divider(
              height: 1,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 15),
          Container(
            padding: EdgeInsets.only(
              left: MediaQuery.of(Get.context!).size.width * 0.02,
            ),
            // color: Colors.red,
            width: MediaQuery.of(Get.context!).size.width * 0.93,
            child: LayoutBuilder(builder: (context, constraints) {
              return Column(
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 10.0, right: 220.0),
                        child: Title14px(text: "คะเเนนที่ใช้"),
                      ),
                      Body14px(text: rewardData.item!.itemCost.toString()),
                    ],
                  ),
                  const SizedBox(height: 15),
                ],
              );
            }),
          ),
          const PreferredSize(
            preferredSize: Size.fromHeight(2.0),
            child: Divider(
              height: 1,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 15),
          Container(
            padding: EdgeInsets.only(
              left: MediaQuery.of(Get.context!).size.width * 0.02,
            ),
            // color: Colors.red,
            width: MediaQuery.of(Get.context!).size.width * 0.93,
            child: LayoutBuilder(builder: (context, constraints) {
              return Column(
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 10.0, right: 240.0),
                        child: Title14px(text: "ค่าจัดส่ง"),
                      ),
                      Body14px(text: "ฟรี", color: primaryColor),
                    ],
                  ),
                  const SizedBox(height: 15),
                ],
              );
            }),
          ),
          const PreferredSize(
            preferredSize: Size.fromHeight(2.0),
            child: Divider(
              height: 1,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 15),
          Container(
            padding: EdgeInsets.only(
              left: MediaQuery.of(Get.context!).size.width * 0.02,
            ),
            // color: Colors.red,
            width: MediaQuery.of(Get.context!).size.width * 0.93,
            child: LayoutBuilder(builder: (context, constraints) {
              return Column(
                children: [
                  Row(children: [
                    Image.network(
                      "https://png.pngtree.com/png-vector/20190507/ourmid/pngtree-vector-fast-van-icon-png-image_1025173.jpg",
                      width: 30,
                      height: 30,
                      fit: BoxFit.cover,
                    ),
                    Title16px(text: "ข้อมูลการจัดส่ง"),
                  ]),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 10.0, right: 8.0),
                        child: Image.network(
                          "https://cdn.shopify.com/s/files/1/0474/2732/2017/products/7fab1d3c44440e75a5b336449fc03ac1_1024x1024.jpg?v=1620961679",
                          width: 10,
                          height: 10,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Body14px(text: "อยู่ระหว่างการจัดส่ง"),
                    ],
                  ),
                  const SizedBox(height: 15),
                ],
              );
            }),
          ),
          const PreferredSize(
            preferredSize: Size.fromHeight(2.0),
            child: Divider(
              height: 1,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
