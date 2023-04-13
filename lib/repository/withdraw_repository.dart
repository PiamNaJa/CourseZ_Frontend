import 'dart:convert';
import 'package:coursez/model/withdraw.dart';
import 'package:coursez/utils/network.dart';
import 'package:http/http.dart' as http;

class WithdrawRepository{
  Future<bool> addWithdraw(Withdraw withdraw, String token)async{
    const url = '${Network.baseUrl}/api/withdraw';
    
    final res = await http.post(Uri.parse(url),
        headers: {"Authorization": token, "Content-Type": "application/json"},
        body: json.encode(withdraw.toJson()));

    if (res.statusCode == 201) {
      return true;
    }
    return false;
  }
}