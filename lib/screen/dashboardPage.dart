import 'package:coursez/controllers/auth_controller.dart';
import 'package:coursez/model/payment.dart';
import 'package:coursez/utils/color.dart';
import 'package:coursez/view_model/dashboard_view_model.dart';
import 'package:coursez/widgets/appbar/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';

class PricePoint {
  final double x;
  final double y;

  PricePoint(this.x, this.y);

  get pricePoints {
    final List<double> data = [2, 4, 6, 8, 10];
    final List<PricePoint> pricePoints = [];
    for (int i = 0; i < data.length; i++) {
      pricePoints.add(PricePoint(i.toDouble(), data[i]));
    }
    return pricePoints;
  }
}

class DashBoardPage extends StatelessWidget {
  const DashBoardPage({super.key});

  @override
  Widget build(BuildContext context) {
    DashboardViewModel dashboardViewModel = DashboardViewModel();
    AuthController authController = Get.find<AuthController>();
    final List<double> data = [2, 4, 6, 8, 10];
    final List<PricePoint> pricePoints = [];
    for (int i = 0; i < data.length; i++) {
      pricePoints.add(PricePoint(i.toDouble(), data[i]));
    }
    return Scaffold(
      appBar: const CustomAppBar(title: "Dashboard"),
      body: Padding(
        padding: const EdgeInsets.only(right: 20),
        child: FutureBuilder(
          future: dashboardViewModel
              .getPaymentTransaction(authController.teacherId.toString()),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return barChart(snapshot.data!);
            } else {
              return const Center(
                  child: CircularProgressIndicator(
                color: primaryColor,
              ));
            }
          },
        ),
      ),
    );
  }

  Widget barChart(List<Payment> data) {
    for (var p in data) {
      print(DateTime.fromMillisecondsSinceEpoch(p.createdAt * 1000)
          .toString()
          .substring(0, 11));
    }
    return Container();
    // return AspectRatio(
    //   aspectRatio: 2,
    //   child: BarChart(
    //     BarChartData(
    //       titlesData: FlTitlesData(
    //         topTitles: AxisTitles(),
    //         rightTitles: AxisTitles(),
    //         bottomTitles: AxisTitles(
    //             sideTitles: SideTitles(
    //                 showTitles: true,
    //                 getTitlesWidget: (double value, meta) => Text(
    //                       value.toInt() % 1 == 0
    //                           ? value.toInt().toString()
    //                           : '',
    //                     ))),
    //       ),
    //       barGroups: pricePoints
    //           .map(
    //             (point) => BarChartGroupData(
    //               x: point.x.toInt(),
    //               barRods: [
    //                 BarChartRodData(
    //                   toY: point.y,
    //                   color: primaryColor,
    //                   width: 12,
    //                 ),
    //               ],
    //             ),
    //           )
    //           .toList(),
    //     ),
    //   ),
    // );
  }
}
