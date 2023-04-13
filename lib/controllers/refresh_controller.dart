import 'package:get/get.dart';

class RefreshController extends GetxController {
  final RxBool _trigerRefresh = false.obs;
  set trigerRefresh(bool value) => _trigerRefresh.value = value;
  void toggleRefresh() => trigerRefresh = !trigerRefresh;
  bool get trigerRefresh => _trigerRefresh.value;
}
