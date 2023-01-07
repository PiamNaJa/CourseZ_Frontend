import 'dart:collection';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';

class AuthController {
  Future loginUser(String email, String password) async {
    const url = 'http://10.0.2.2:5000/api/user/login';
    Map data = {'email': email, 'password': password};

    var response = await http.post(Uri.parse(url),
        headers: {"Content-Type": "application/json"}, body: json.encode(data));

    if (response.statusCode == 200) {
      var loginArr = json.decode(response.body);
      var pee = JwtDecoder.decode(loginArr['token']);
      DateTime expirationDate = JwtDecoder.getExpirationDate(loginArr['token']);
      debugPrint(expirationDate.toString());
      debugPrint(loginArr.toString());
      debugPrint(JwtDecoder.isExpired(loginArr['token']).toString());
      //decode token
      debugPrint(pee.toString());
    } else {
      debugPrint('code: ' + response.statusCode.toString());
      debugPrint('Login Error');
      debugPrint(response.body);
    }
  }
}
