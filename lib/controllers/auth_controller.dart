import 'package:coursez/model/user.dart';
import 'package:coursez/view_model/profile_view_model.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final _isLogin = false.obs;
  set isLogin(bool value) => _isLogin.value = value;
  bool get isLogin => _isLogin.value;

  final _userid = 0.obs;
  set userid(int value) => _userid.value = value;
  int get userid => _userid.value;

  final _username = ''.obs;
  set username(String value) => _username.value = value;
  String get username => _username.value;

  final _picture = ''.obs;
  set picture(String value) => _picture.value = value;
  String get picture => _picture.value;

  final _role = ''.obs;
  set role(String value) => _role.value = value;
  String get role => _role.value;

  final _point = 0.obs;
  set point(int value) => _point.value = value;
  int get point => _point.value;

  fetchUser(int userId) async {
    ProfileViewModel profile = ProfileViewModel();
    User user = await profile.fetchUser(userId);
    _isLogin.value = true;
    _userid.value = user.userId!;
    _username.value = user.nickName;
    _picture.value = user.picture;
    _role.value = user.role;
    _point.value = user.point;
  }
}
