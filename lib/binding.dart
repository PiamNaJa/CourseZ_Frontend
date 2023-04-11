import 'package:coursez/controllers/auth_controller.dart';
import 'package:coursez/controllers/level_controller.dart';
import 'package:coursez/controllers/post_controller.dart';
import 'package:coursez/controllers/inboxcontroller.dart';
import 'package:coursez/controllers/refresh_controller.dart';
import 'package:get/get.dart';

class FirstBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthController(), permanent: true);
    Get.put(LevelController(), permanent: true);
    Get.put(PostController(), permanent: true);
    Get.put(InboxController(), permanent: true);
    Get.put(RefreshController(), permanent: true);
  }
}
