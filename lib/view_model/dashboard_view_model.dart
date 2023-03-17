import 'package:coursez/model/payment.dart';
import 'package:coursez/utils/fetchData.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardViewModel {
  Future<List<Payment>> getPaymentTransaction(String teacherId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token')!;
    final p = await fecthData('payment/teacher/$teacherId', authorization: token);
    final List<Payment> payments = List.from(p.map((e) => Payment.fromJson(e))) ;
    return payments;
  }
}
