import 'package:get/get.dart';
class LevelController extends GetxController {
  final _level = 0.obs;
  set level(int value) => _level.value = value;
  int get level => _level.value;
}