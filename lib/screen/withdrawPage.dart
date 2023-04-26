import 'package:coursez/controllers/auth_controller.dart';
import 'package:coursez/model/withdraw.dart';
import 'package:coursez/utils/color.dart';
import 'package:coursez/view_model/withdraw_view_model.dart';
import 'package:coursez/widgets/button/bank_button.dart';
import 'package:coursez/widgets/text/body16.dart';
import 'package:coursez/widgets/text/heading2_20px.dart';
import 'package:coursez/widgets/text/title16px.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WithdrawPage extends StatelessWidget {
  const WithdrawPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();
    final WithDrawViewModel withDrawViewModel = WithDrawViewModel();
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Obx(
              () => Heading20px(
                  text: 'ยอดเงินคงเหลือ ${authController.money} บาท'),
            ),
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
                  Tab(text: "ประวัติการถอนเงิน"),
                ]),
          ),
          body: Padding(
            padding: const EdgeInsets.all(15),
            child: TabBarView(
              children: [
                banklist(WithDrawViewModel.bankData),
                FutureBuilder(
                    future: withDrawViewModel
                        .getWithdrawHistory(authController.teacherId),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return withdrawHistory(snapshot.data ?? []);
                      } else {
                        return const Center(
                            child: CircularProgressIndicator(
                          color: primaryColor,
                        ));
                      }
                    }),
              ],
            ),
          ),
        ));
  }

  Widget banklist(List<List<String>> bankData) {
    return GridView(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      children: bankData
          .map((bank) => BankButton(
              title: bank[0],
              image: bank[1],
              onPressed: () {
                Get.toNamed('/withdrawForm', parameters: {
                  'bank': bank[0],
                  'bankimage': bank[1],
                });
              }))
          .toList(),
    );
  }

  Widget withdrawHistory(List<Withdraw> datas) {
    if (datas.isEmpty) {
      return const Center(child: Title16px(text: 'ไม่มีรายการถอนเงิน'));
    }
    return Column(
      children: datas.map(
        (data) {
          final date =
              DateTime.fromMillisecondsSinceEpoch(data.createAt * 1000);
          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Title16px(text: '${date.day}/${date.month}/${date.year}'),
                  Text('- ${data.money} บาท',
                      style: const TextStyle(
                          fontSize: 16,
                          color: Colors.red,
                          fontWeight: FontWeight.bold)),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Body16px(text: 'ธนาคาร${data.bankName}'),
                  Body16px(text: 'เลขที่บัญชี : ${data.bankNumber}'),
                ],
              ),
              const Divider(
                color: greyColor,
                height: 10,
                thickness: 1,
              )
              // const SizedBox(height: 10),
            ],
          );
        },
      ).toList(),
    );
  }
}
