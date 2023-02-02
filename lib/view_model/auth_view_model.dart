import 'dart:convert';
import 'package:coursez/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../repository/auth_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class AuthViewModel {
  final AuthRepository _authRepository = AuthRepository();
  static final _authController = Get.find<AuthController>();
  void login(String email, String password, BuildContext context) {
    int statusCode = 0;
    _authRepository.loginUser(email, password).then((response) async {
      statusCode = response.statusCode;
      if (statusCode == 200) {
        var data = json.decode(response.body);
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('token', data['token']);
        prefs.setString('refreshToken', data['refreshToken']);
        _authController.isLogin = true;
        Get.back();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('รหัสผ่านไม่ถูกต้อง กรุณาลองใหม่อีกครั้ง'),
              backgroundColor: Colors.red,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10)),
        );
      }
    });
  }

  // static Future<void> checkToken(String token) async {
  //   final data = JwtDecoder.decode(token);
  //   _authController.userid = data['user_id'];
  //   final exp = data['exp'];
  //   if (exp < DateTime.now().toUtc().millisecondsSinceEpoch) {
  //     final String refreshToken = await getRefreshToken();
  //     AuthRepository().getNewToken(refreshToken).then((response) async {
  //       final data = json.decode(response.body);
  //       final prefs = await SharedPreferences.getInstance();
  //       prefs.setString('token', data['token']);
  //       prefs.setString('refreshToken', data['refreshToken']);
  //       token = data['token'];
  //     });
  //   }
  // }

  static Future<String> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('refreshToken')!;
  }

  static Future<bool> checkAuth() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token != null) {
      final data = JwtDecoder.decode(token);
      _authController.userid = data['user_id'];
      // await checkToken(token);
      _authController.isLogin = true;
      return true;
    } else {
      _authController.isLogin = false;
      return false;
    }
  }
}
