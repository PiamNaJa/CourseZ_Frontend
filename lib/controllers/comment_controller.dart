import 'package:get/get.dart';

class CommentController extends GetxController {
  final _comment = ''.obs;
  set comment(String value) => _comment.value = value;
  String get comment => _comment.value;

}
