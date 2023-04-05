import 'dart:convert';

import 'package:coursez/utils/network.dart';
import 'package:http/http.dart' as http;

class RewardRepository{
  Future<bool> addRewardInfo(int itemid, String token) async {
    const url = '${Network.baseUrl}/api/reward/info/';
    final Map<String, dynamic> data = {
      "item_id": itemid,
    };
    final res = await http.post(Uri.parse(url),
        headers: {"Authorization": token, "Content-Type": "application/json"},
        body: json.encode(data));

    if (res.statusCode == 201) {
      return true;
    }
    return false;
  }
}