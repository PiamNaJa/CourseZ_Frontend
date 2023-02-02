import 'package:get/get.dart';

class AuthController extends GetxController{
  final _isLogin = false.obs;
  set isLogin(bool value) => _isLogin.value = value;
  bool get isLogin => _isLogin.value;

  final _userid = 0.obs;
  set userid(int value) => _userid.value = value;
  int get userid => _userid.value;
}


