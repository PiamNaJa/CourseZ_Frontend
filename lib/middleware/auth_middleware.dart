import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:coursez/controllers/auth_controller.dart';

class AuthMiddleware extends GetMiddleware {
final AuthController _authController = Get.find<AuthController>();
  @override
  // RouteSettings? redirect(String? route) {
  //   final AuthController authController = Get.find();
  //   if (!authController.isLogin) {
  //     return const RouteSettings(name: '/login');
  //   }
  //   return null;
  // }
  RouteSettings? redirect(String? route) {
    if (_authController.isLogin) return const RouteSettings(name: '/peerawat');
    return null;
  }
}
