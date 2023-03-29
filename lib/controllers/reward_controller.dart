import 'package:get/get.dart';

class RewardController extends GetxController {
  final _itemid = 0.obs;
  set itemid(int value) => _itemid.value = value;
  int get itemid => _itemid.value;
}
