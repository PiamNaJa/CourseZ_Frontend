import 'dart:collection';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthController {
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
      //save token
      // storage.write(key: 'token', value: loginArr['token']);
      // await storage.write(key: 'token ', value: loginArr['token']);
      //get token
      // var token = await getToken('token');
      // debugPrint(token.toString());
      // DateTime expirationDate = JwtDecoder.getExpirationDate(loginArr['token']);
      // debugPrint(expirationDate.toString());
      // debugPrint(loginArr.toString());
      // debugPrint(JwtDecoder.isExpired(loginArr['token']).toString());
      //decode token
      debugPrint(decode.toString());
    } else {
      debugPrint('code: ${response.statusCode.toString()}');
      debugPrint('Login Error');
      debugPrint(response.body);
    }
  }

  // static Future storeToken(dynamic token) async {
  //   await const FlutterSecureStorage().write(key: 'token', value: token);
  // }

  // static Future<String?> getToken(String token) async {
  //   return await const FlutterSecureStorage().read(key: token);
  // }
}
