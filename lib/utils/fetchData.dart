import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


Future<Map<String, dynamic>> fecthData(String route) async {
  http.Response response = await http.get(Uri.parse('http://10.0.2.2:5000/api/$route/'));
  Map<String, dynamic> res = {"data" : null, "err" : null};
  if (response.statusCode == 200) {
    var decodedData = await jsonDecode(utf8.decode(response.bodyBytes));
    res["data"] = decodedData;
  } else {
    res["err"] = response.statusCode;
  }
  return res;
}
