import 'dart:math';

import 'package:coursez/controllers/auth_controller.dart';
import 'package:coursez/model/payment.dart';
import 'package:coursez/utils/color.dart';
import 'package:coursez/view_model/dashboard_view_model.dart';
import 'package:coursez/widgets/appbar/app_bar.dart';
import 'package:coursez/widgets/text/body12px.dart';
import 'package:coursez/widgets/text/heading1_24px.dart';
import 'package:coursez/widgets/text/title14px.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';

class DashBoardPage extends StatelessWidget {
  const DashBoardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final DashboardViewModel dashboardViewModel = DashboardViewModel();
    final AuthController authController = Get.find<AuthController>();
    return Scaffold(
      appBar: const CustomAppBar(title: "รายได้ของคุณในช่วง 7 วันที่ผ่านมา"),
      body: FutureBuilder(
        future: dashboardViewModel
            .getPaymentTransaction(authController.teacherId.toString()),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: barChart(snapshot.data!),
                ),
                Text(
                  "รายได้ 7 วันที่ผ่านมา : ${dashboardViewModel.totalMoney(snapshot.data!)} บาท",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                if (snapshot.data!.isNotEmpty)
                  transactionList(snapshot.data!)
                else
                  const Center(
                    child: Heading24px(
                      color: greyColor,
                      text: "ไม่มีรายการใน 7 วันล่าสุด",
                    ),
                  )
              ],
            );
          } else {
            return const Center(
                child: CircularProgressIndicator(
              color: primaryColor,
            ));
          }
        },
      ),
    );
  }

  Widget barChart(List<Payment> data) {
    final DashboardViewModel dashboardViewModel = DashboardViewModel();
    final List<PaymentTransaction> paymentTransaction =
        dashboardViewModel.paymentDataToInterface(data);
    final List<double> values =
        paymentTransaction.map((e) => e.money.toDouble()).toList();
    final double maxValue = values.reduce(max);
    final double maxY = (maxValue / 100).ceil() * 100;
    // final List<PaymentTransaction> paymentTransaction =
    //     dashboardViewModel.paymentDataToInterface(data);
    // return Container();
    return AspectRatio(
      aspectRatio: 2,
      child: BarChart(
        BarChartData(
            titlesData: FlTitlesData(
              topTitles: AxisTitles(),
              rightTitles: AxisTitles(),
              bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (double value, meta) {
                        final DateTime date =
                            DateTime.fromMillisecondsSinceEpoch(
                                value.toInt() * 1000);
                        return Text(
                          "${date.day}/${date.month}",
                        );
                      })),
            ),
            barGroups: paymentTransaction
                .map(
                  (e) => BarChartGroupData(
                    x: e.day,
                    barRods: [
                      BarChartRodData(
                        toY: e.money.toDouble(),
                        color: primaryColor,
                        width: 12,
                      )
                    ],
                  ),
                )
                .toList(),
            maxY: maxY),
      ),
    );
  }

  Widget transactionList(List<Payment> data) {
    return Expanded(
      child: ListView.separated(
        separatorBuilder: (context, index) => const Divider(
          color: Colors.black,
          height: 0,
        ),
        itemCount: data.length,
        itemBuilder: (context, index) {
          final DateTime date =
              DateTime.fromMillisecondsSinceEpoch(data[index].createdAt * 1000);
          return ListTile(
            title: Title14px(text: data[index].video.videoName),
            subtitle: Body12px(
                text:
                    "วันที่ ${date.day}/${date.month}/${date.year} เวลา ${date.hour}:${date.minute}"),
            trailing: Title14px(
              text: '+${data[index].money}',
              color: primaryColor,
            ),
          );
        },
      ),
    );
  }
}
