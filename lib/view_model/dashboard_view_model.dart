import 'dart:math';
import 'package:coursez/model/payment.dart';
import 'package:coursez/utils/fetchData.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaymentTransaction {
  final int day;
  final double money;

  PaymentTransaction(this.day, this.money);
}

class DashboardViewModel {
  Future<List<Payment>> getPaymentTransaction(String teacherId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token')!;
    final p =
        await fecthData('payment/teacher/$teacherId', authorization: token);
    final List<Payment> payments = List.from(p.map((e) => Payment.fromJson(e)));
    return payments;
  }

  List<PaymentTransaction> paymentDataToInterface(List<Payment> data) {
    final List<PaymentTransaction> paymentTransaction = [];
    for (int i = 0; i < 7; i++) {
      double money = 0;
      for (var p in data) {
        if (DateTime.fromMillisecondsSinceEpoch(p.createdAt * 1000).day ==
            DateTime.now().add(Duration(days: -i)).day) {
          money += p.money;
        }
      }
      paymentTransaction.add(PaymentTransaction(
          DateTime.now().add(Duration(days: -i)).millisecondsSinceEpoch ~/ 1000,
          money));
    }
    return paymentTransaction.reversed.toList();
  }

  int totalMoney(List<Payment> data) {
    int total = 0;
    for (var p in data) {
      total += p.money;
    }
    return total;
  }

  test() {
    // Set the range for the dates
    DateTime endDate = DateTime.now().subtract(const Duration(days: 7));
    DateTime startDate = DateTime.now();

    // Generate 10 random dates within the range
    List<DateTime> randomDates = List.generate(
      100,
      (index) {
        // Generate a random number within the range of milliseconds between the two dates
        int randomMilliseconds =
            Random().nextInt(startDate.difference(endDate).inMilliseconds);

        // Add the random number of milliseconds to the end date to get a random date within the range
        return endDate.add(Duration(milliseconds: randomMilliseconds));
      },
    );

    final List<PaymentTransaction> paymentTransaction = [];
    for (int i = 0; i < 7; i++) {
      double money = 0;
      for (var p in randomDates) {
        if (p.day == DateTime.now().add(Duration(days: -i)).day) {
          money += Random().nextInt(50);
        }
      }
      paymentTransaction.add(PaymentTransaction(
          DateTime.now().add(Duration(days: -i)).millisecondsSinceEpoch ~/ 1000,
          money));
    }
    return paymentTransaction.reversed.toList();
  }
}
