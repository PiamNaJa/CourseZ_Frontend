import 'package:coursez/controllers/auth_controller.dart';
import 'package:get/get.dart';

class FirstBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthController(), permanent: true);
  }
}
