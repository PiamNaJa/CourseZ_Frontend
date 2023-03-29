import 'dart:convert';

import 'package:coursez/model/address.dart';
import 'package:coursez/utils/network.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddressRepository {
  Future<bool> addAddress(Address address, String token, int userid) async {
    final url = '${Network.baseUrl}/api/user/$userid/address';
    final Map<String, dynamic> data = {
      "house_no": address.houseNo,
      "lane": address.lane,
      "village_no": address.villageNo,
      "village": address.village,
      "road": address.road,
      "sub_district": address.subDistrict,
      "district": address.district,
      "province": address.province,
      "postal": address.postal,
    };
    final res = await http.post(Uri.parse(url),
        headers: {"Authorization": token, "Content-Type": "application/json"},
        body: json.encode(data));
    if (res.statusCode == 200) {
      return true;
    }
    debugPrint(res.body);
    return false;
  }
}
