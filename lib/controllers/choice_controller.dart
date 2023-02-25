import 'package:coursez/model/choice.dart';
import 'package:get/get.dart';

class ChoiceController extends GetxController {
   final Map<int, Choice> _choice = <int, Choice>{}.obs;
  void setchoice(int index, Choice value) => _choice[index] = value;
  Map<int, Choice> get getchoice => _choice;

  final _points = 0.obs;
  set points(int value) => _points.value = value;
  int get points => _points.value;

  final _correctCount = 0.obs;
  set correctCount(int value) => _correctCount.value = value;
  int get correctCount => _correctCount.value;
}