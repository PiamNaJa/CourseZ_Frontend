import 'package:coursez/utils/color.dart';
import 'package:coursez/view_model/withdraw_view_model.dart';
import 'package:coursez/widgets/button/bank_button.dart';
import 'package:coursez/widgets/text/heading2_20px.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WithdrawPage extends StatelessWidget {
  const WithdrawPage({super.key});

  @override
  Widget build(BuildContext context) {
    final int balance = Get.arguments;

    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Heading20px(text: 'ยอดเงินคงเหลือ $balance บาท'),
            centerTitle: true,
            elevation: 0,
            
            backgroundColor: primaryLighterColor,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: primaryColor),
              onPressed: () {
                Get.back();
              },
            ),
            bottom: const TabBar(
                labelColor: blackColor,
                labelStyle: TextStyle(fontWeight: FontWeight.bold),
                unselectedLabelColor: greyColor,
                indicator: UnderlineTabIndicator(
                  borderSide: BorderSide(color: primaryColor, width: 5),
                  insets: EdgeInsets.symmetric(horizontal: 15),
                ),
                tabs: [
                  Tab(text: "รายการ"),
                  Tab(text: "ประวัติ"),
                ]),
          ),
          body: TabBarView(
            children: [
              Container(
                padding: const EdgeInsets.all(15),
                child: GridView(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  children: WithDrawViewModel.bankData
                      .map((bank) => BankButton(title: bank[0], image: bank[1], onPressed: () {
                        Get.toNamed('/withdrawForm',arguments: balance, parameters: {
                          'bank': bank[0],
                          'bankimage': bank[1],
                        });
                      }))
                      .toList(),
                ),
              ),
              Container(
                color: Colors.blue,
              ),
            ],
          ),
        ));
  }
}
