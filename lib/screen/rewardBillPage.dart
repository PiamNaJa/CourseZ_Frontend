import 'package:coursez/utils/color.dart';
import 'package:coursez/widgets/button/button.dart';
import 'package:coursez/widgets/text/body12px.dart';
import 'package:coursez/widgets/text/body14px.dart';
import 'package:coursez/widgets/text/body16.dart';
import 'package:coursez/widgets/text/heading1_24px.dart';
import 'package:coursez/widgets/text/heading2_20px.dart';
import 'package:coursez/widgets/text/title14px.dart';
import 'package:coursez/widgets/text/title16px.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';

class RewardBillPage extends StatelessWidget {
  const RewardBillPage({super.key});

  @override
  Widget build(BuildContext context) {
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
                context: Get.context!,
                builder: ((context) {
                  return AlertDialog(
                    title: const Heading20px(text: 'ยืนยันการยกเลิก'),
                    content: const Body16px(
                        text: 'คุณต้องการยกเลิกการสั่งซื้อหรือไม่'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Get.back();
                          Get.back();
                        },
                        child: const Body14px(text: 'ยืนยัน'),
                      ),
                      TextButton(
                        onPressed: () {
                          Get.back();
                        },
                        child:
                            const Title14px(text: 'ยกเลิก', color: Colors.red),
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
          rewardInfo(),
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
            const Title14px(text: '1000 แต้ม', color: primaryColor),
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
                          context: Get.context!,
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
                                    Get.back();
                                    showDialog(
                                        context: Get.context!,
                                        builder: ((context) {
                                          return AlertDialog(
                                            title: const Heading20px(
                                                text: 'สั่งซื้อสำเร็จ'),
                                            content: const Text(
                                                'คุณสามารถตรวจสอบสถานะการสั่งซื้อได้ที่คูปองของฉันหน้าแลกของรางวัล'),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Get.back();
                                                },
                                                child: const Body14px(
                                                  text: 'ตกลง',
                                                ),
                                              ),
                                            ],
                                          );
                                        }));
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

  Widget rewardInfo() {
    return Column(
      children: [
        Container(
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
                    children: const [
                      Heading20px(text: 'ที่อยู่สำหรับจัดส่ง'),
                      Body12px(text: 'บ้านเลขที่ 1/1 หมู่ 1 ตำบล บางขุนเทียน'),
                      Body12px(text: 'อำเภอ บางขุนเทียน จังหวัด นนทบุรี 11110'),
                    ],
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(
                  Icons.edit,
                  size: 30,
                ),
                onPressed: () {},
              )
            ],
          ),
        ),
        const Heading24px(text: 'ของรางวัล'),
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
            leading: Image.network(
                'https://serazu.com/library/products/2315/XXXXXL9786164871359.jpg'),
            title: const Body16px(text: 'หนังสือ 9 วิชาสามัญ รวมทุกวิชา'),
            trailing: const Title14px(text: '1000 แต้ม'),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Title16px(text: 'คะแนนที่ใช้'),
              Title14px(text: '1000 แต้ม'),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Body16px(text: 'ค่าจัดส่ง'),
              Body14px(text: 'ฟรี'),
            ],
          ),
        ),
      ],
    );
  }
}
