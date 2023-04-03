import 'package:coursez/controllers/auth_controller.dart';
import 'package:coursez/model/rewardInfo.dart';
import 'package:coursez/utils/color.dart';
import 'package:coursez/view_model/rewardInfo_view_model.dart';
import 'package:coursez/widgets/text/body14px.dart';
import 'package:coursez/widgets/text/body16.dart';
import 'package:coursez/widgets/text/heading2_20px.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
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
    final rewardTime =
        rewardInfoViewModel.formatReviewDate(rewardData.createdAt);
    final rewardDate = DateTime.parse(rewardTime);
    final now = DateTime.now();
    final differenceInDays = now.difference(rewardDate).inDays;
    if (differenceInDays < 2) {
      return Column(
        children: [
          Container(
            padding: EdgeInsets.only(
              left: MediaQuery.of(Get.context!).size.width * 0.02,
            ),
            color: tertiaryLightColor,
            height: 110,
            child: LayoutBuilder(builder: (context, constraints) {
              return Column(
                children: [
                  Row(
                    children: const [
                      Padding(
                        padding:
                            EdgeInsets.only(top: 15, left: 10.0, right: 80),
                        child: Title16px(
                            text: "ของรางวัลนี้กำลังอยู่ระหว่างจัดส่ง"),
                      ),
                    ],
                  ),
                  Row(
                    children: const [
                      Padding(
                        padding: EdgeInsets.only(left: 10.0, right: 80),
                        child: Body16px(
                            text:
                                "คุณจะได้รับรางวัลภายใน 1-2 วัน\nหลังจากทำการเเลกของรางวัล"),
                      ),
                      Icon(
                        Icons.local_shipping,
                        color: Colors.black,
                        size: 50,
                      )
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
          Container(
            color: const Color.fromARGB(255, 242, 240, 238),
            height: 15,
            child: LayoutBuilder(builder: (context, constraints) {
              return Column(
                children: [
                  Row(
                    children: const [
                      Padding(
                        padding:
                            EdgeInsets.only(top: 10, left: 10.0, right: 70),
                      ),
                    ],
                  ),
                ],
              );
            }),
          ),
          Container(
            padding: EdgeInsets.only(
              left: MediaQuery.of(Get.context!).size.width * 0.02,
            ),
            width: MediaQuery.of(Get.context!).size.width * 0.93,
            child: LayoutBuilder(builder: (context, constraints) {
              return Column(
                children: const [
                  Padding(
                    padding: EdgeInsets.only(left: 10.0, right: 220.0),
                    child: Title16px(text: "รายละเอียด"),
                  ),
                  SizedBox(height: 10),
                ],
              );
            }),
          ),
          Container(
            padding: EdgeInsets.only(
              left: MediaQuery.of(Get.context!).size.width * 0.02,
            ),
            width: MediaQuery.of(Get.context!).size.width * 0.93,
            child: LayoutBuilder(builder: (context, constraints) {
              return Column(
                children: [
                  Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 10.0, right: 242.0),
                        child: Body14px(text: "ชื่อผู้รับ"),
                      ),
                      Body14px(text: authController.username),
                    ],
                  ),
                  const SizedBox(height: 15),
                ],
              );
            }),
          ),
          Container(
            padding: EdgeInsets.only(
              left: MediaQuery.of(Get.context!).size.width * 0.02,
            ),
            width: MediaQuery.of(Get.context!).size.width * 0.93,
            child: LayoutBuilder(builder: (context, constraints) {
              return Column(
                children: [
                  Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 10.0, right: 220.0),
                        child: Body14px(text: "คะเเนนที่ใช้"),
                      ),
                      Body14px(text: rewardData.item!.itemCost.toString()),
                    ],
                  ),
                  const SizedBox(height: 10),
                ],
              );
            }),
          ),
          const SizedBox(height: 10),
          Container(
            padding: EdgeInsets.only(
              left: MediaQuery.of(Get.context!).size.width * 0.02,
            ),
            width: MediaQuery.of(Get.context!).size.width * 0.93,
            child: LayoutBuilder(builder: (context, constraints) {
              return Column(
                children: [
                  Row(
                    children: const [
                      Padding(
                        padding: EdgeInsets.only(left: 10.0, right: 240.0),
                        child: Body14px(text: "ค่าจัดส่ง"),
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
          Container(
            color: const Color.fromARGB(255, 242, 240, 238),
            height: 15,
            child: LayoutBuilder(builder: (context, constraints) {
              return Column(
                children: [
                  Row(
                    children: const [
                      Padding(
                        padding:
                            EdgeInsets.only(top: 10, left: 10.0, right: 70),
                      ),
                    ],
                  ),
                ],
              );
            }),
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
                      "https://firebasestorage.googleapis.com/v0/b/coursez-50fb3.appspot.com/o/Images%2Fshoppingcar.png?alt=media&token=cf1a29de-b715-407c-9681-90fb778a5b29",
                      width: 30,
                      height: 30,
                      fit: BoxFit.cover,
                    ),
                    const Title16px(text: "ข้อมูลการจัดส่ง"),
                  ]),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0, right: 8.0),
                        child: Image.network(
                          "https://firebasestorage.googleapis.com/v0/b/coursez-50fb3.appspot.com/o/Images%2Fgreendot.png?alt=media&token=198f89e8-f40a-42c0-b869-f501ab58aca3",
                          width: 10,
                          height: 10,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const Body14px(text: "อยู่ระหว่างการจัดส่ง"),
                    ],
                  ),
                  const SizedBox(height: 5),
                ],
              );
            }),
          ),
          Container(
            padding: EdgeInsets.only(
              left: MediaQuery.of(Get.context!).size.width * 0.02,
            ),
            width: MediaQuery.of(Get.context!).size.width * 0.93,
            child: LayoutBuilder(builder: (context, constraints) {
              return Column(
                children: [
                  SizedBox(
                    height: 70,
                    child: Row(
                      children: const [
                        Padding(
                          padding: EdgeInsets.only(left: 7.0),
                        ),
                        VerticalDivider(
                          color: Colors.grey,
                          thickness: 2,
                          endIndent: 5,
                        )
                      ],
                    ),
                  ),
                ],
              );
            }),
          ),
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
                        padding: const EdgeInsets.only(left: 10.0, right: 8.0),
                        child: Image.network(
                          "https://firebasestorage.googleapis.com/v0/b/coursez-50fb3.appspot.com/o/Images%2Fgreydot.png?alt=media&token=b4fd5780-ad0c-455d-8faf-344875abaa9a",
                          width: 10,
                          height: 10,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const Body14px(text: "จัดส่งสินค้าสำเร็จ"),
                    ],
                  ),
                ],
              );
            }),
          ),
          Container(
            color: const Color.fromARGB(255, 242, 240, 238),
            height: 15,
            child: LayoutBuilder(builder: (context, constraints) {
              return Column(
                children: [
                  Row(
                    children: const [
                      Padding(
                        padding:
                            EdgeInsets.only(top: 10, left: 10.0, right: 70),
                      ),
                    ],
                  ),
                ],
              );
            }),
          ),
        ],
      );
    } else {
      return Column(
        children: [
          Container(
            padding: EdgeInsets.only(
              left: MediaQuery.of(Get.context!).size.width * 0.02,
            ),
            color: primaryLightColor,
            height: 110,
            child: LayoutBuilder(builder: (context, constraints) {
              return Column(
                children: [
                  Row(
                    children: const [
                      Padding(
                        padding:
                            EdgeInsets.only(top: 15, left: 10.0, right: 80),
                        child: Title16px(text: "จัดส่งของรางวัลสำเร็จ"),
                      ),
                    ],
                  ),
                  Row(
                    children: const [
                      Padding(
                        padding: EdgeInsets.only(left: 10.0, right: 80),
                        child: Body16px(
                            text: "ของรางวัลนี้ได้ถูกจัดส่งให้กับคุณเเล้ว"),
                      ),
                      Icon(
                        Icons.local_shipping,
                        color: Colors.black,
                        size: 50,
                      )
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
          Container(
            color: const Color.fromARGB(255, 242, 240, 238),
            height: 15,
            child: LayoutBuilder(builder: (context, constraints) {
              return Column(
                children: [
                  Row(
                    children: const [
                      Padding(
                        padding:
                            EdgeInsets.only(top: 10, left: 10.0, right: 70),
                      ),
                    ],
                  ),
                ],
              );
            }),
          ),
          Container(
            padding: EdgeInsets.only(
              left: MediaQuery.of(Get.context!).size.width * 0.02,
            ),
            width: MediaQuery.of(Get.context!).size.width * 0.93,
            child: LayoutBuilder(builder: (context, constraints) {
              return Column(
                children: [
                  Row(
                    children: const [
                      Padding(
                        padding: EdgeInsets.only(left: 10.0, right: 220.0),
                        child: Title16px(text: "รายละเอียด"),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                ],
              );
            }),
          ),
          Container(
            padding: EdgeInsets.only(
              left: MediaQuery.of(Get.context!).size.width * 0.02,
            ),
            width: MediaQuery.of(Get.context!).size.width * 0.93,
            child: LayoutBuilder(builder: (context, constraints) {
              return Column(
                children: [
                  Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 10.0, right: 242.0),
                        child: Body14px(text: "ชื่อผู้รับ"),
                      ),
                      Body14px(text: authController.username),
                    ],
                  ),
                  const SizedBox(height: 15),
                ],
              );
            }),
          ),
          Container(
            padding: EdgeInsets.only(
              left: MediaQuery.of(Get.context!).size.width * 0.02,
            ),
            width: MediaQuery.of(Get.context!).size.width * 0.93,
            child: LayoutBuilder(builder: (context, constraints) {
              return Column(
                children: [
                  Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 10.0, right: 220.0),
                        child: Body14px(text: "คะเเนนที่ใช้"),
                      ),
                      Body14px(text: rewardData.item!.itemCost.toString()),
                    ],
                  ),
                  const SizedBox(height: 10),
                ],
              );
            }),
          ),
          const SizedBox(height: 10),
          Container(
            padding: EdgeInsets.only(
              left: MediaQuery.of(Get.context!).size.width * 0.02,
            ),
            width: MediaQuery.of(Get.context!).size.width * 0.93,
            child: LayoutBuilder(builder: (context, constraints) {
              return Column(
                children: [
                  Row(
                    children: const [
                      Padding(
                        padding: EdgeInsets.only(left: 10.0, right: 240.0),
                        child: Body14px(text: "ค่าจัดส่ง"),
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
          Container(
            color: const Color.fromARGB(255, 242, 240, 238),
            height: 15,
            child: LayoutBuilder(builder: (context, constraints) {
              return Column(
                children: [
                  Row(
                    children: const [
                      Padding(
                        padding:
                            EdgeInsets.only(top: 10, left: 10.0, right: 70),
                      ),
                    ],
                  ),
                ],
              );
            }),
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
                      "https://firebasestorage.googleapis.com/v0/b/coursez-50fb3.appspot.com/o/Images%2Fshoppingcar.png?alt=media&token=cf1a29de-b715-407c-9681-90fb778a5b29",
                      width: 30,
                      height: 30,
                      fit: BoxFit.cover,
                    ),
                    const Title16px(text: "ข้อมูลการจัดส่ง"),
                  ]),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0, right: 8.0),
                        child: Image.network(
                          "https://firebasestorage.googleapis.com/v0/b/coursez-50fb3.appspot.com/o/Images%2Fgreydot.png?alt=media&token=b4fd5780-ad0c-455d-8faf-344875abaa9a",
                          width: 10,
                          height: 10,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const Body14px(text: "อยู่ระหว่างการจัดส่ง"),
                    ],
                  ),
                  const SizedBox(height: 5),
                ],
              );
            }),
          ),
          Container(
            padding: EdgeInsets.only(
              left: MediaQuery.of(Get.context!).size.width * 0.02,
            ),
            width: MediaQuery.of(Get.context!).size.width * 0.93,
            child: LayoutBuilder(builder: (context, constraints) {
              return Column(
                children: [
                  SizedBox(
                    height: 70,
                    child: Row(
                      children: const [
                        Padding(
                          padding: EdgeInsets.only(left: 7.0),
                        ),
                        VerticalDivider(
                          color: Colors.grey,
                          thickness: 2,
                          endIndent: 5,
                        )
                      ],
                    ),
                  ),
                ],
              );
            }),
          ),
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
                        padding: const EdgeInsets.only(left: 10.0, right: 8.0),
                        child: Image.network(
                          "https://firebasestorage.googleapis.com/v0/b/coursez-50fb3.appspot.com/o/Images%2Fgreendot.png?alt=media&token=e9ffe090-4e52-4768-94fb-aeb1d249d260",
                          width: 10,
                          height: 10,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const Body14px(text: "จัดส่งสินค้าสำเร็จ"),
                    ],
                  ),
                ],
              );
            }),
          ),
          Container(
            color: const Color.fromARGB(255, 242, 240, 238),
            height: 15,
            child: LayoutBuilder(builder: (context, constraints) {
              return Column(
                children: [
                  Row(
                    children: const [
                      Padding(
                        padding:
                            EdgeInsets.only(top: 10, left: 10.0, right: 70),
                      ),
                    ],
                  ),
                ],
              );
            }),
          ),
        ],
      );
    }
  }
}
                      // 'เผยแพร่เมื่อ ${rewardInfoViewModel.formatReviewDate(rewardData.createdAt)}',