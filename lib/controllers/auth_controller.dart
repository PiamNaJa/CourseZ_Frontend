import 'dart:collection';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthController {
  int statusCode = 0;
  final storage = const FlutterSecureStorage(
      aOptions: AndroidOptions(
    encryptedSharedPreferences: true,
  ));
  Future loginUser(String email, String password) async {
    const url = 'http://10.0.2.2:5000/api/user/login';
    Map data = {'email': email, 'password': password};

    var response = await http.post(Uri.parse(url),
        headers: {"Content-Type": "application/json"}, body: json.encode(data));

    if (response.statusCode == 200) {
      var loginArr = json.decode(response.body);
      var decode = JwtDecoder.decode(loginArr['token']);
      getData(decode['user_id'].toString());
    } else {
      debugPrint('code: ${response.statusCode.toString()}');
      debugPrint('Login Error');
      debugPrint(response.body);
    }
  }

  Future getData(String id) async {
    String url = 'http://10.0.2.2:5000/api/user/$id';

    var response = await http
        .get(Uri.parse(url), headers: {"Content-Type": "application/json"});

    if (response.statusCode == 200) {
      statusCode = response.statusCode;
      var data = json.decode(response.body);
      debugPrint(data.toString());
    } else {
      statusCode = response.statusCode;
      debugPrint('code: ${response.statusCode.toString()}');
      debugPrint('Error getting data');
      debugPrint(response.body);
    }
  }
}
