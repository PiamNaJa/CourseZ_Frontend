import 'package:coursez/model/exercise.dart';
import 'package:coursez/repository/exercise_repository.dart';
import 'package:coursez/utils/color.dart';
import 'package:coursez/utils/fetchData.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExerciseViewModel {
  final ExerciseRepository _exerciseRepository = ExerciseRepository();
  Future<List<Exercise>> fetchExercise(String courseId, String videoId) async {
    final e = await fecthData('course/$courseId/video/$videoId/exercise');
    final List<Exercise> exercise =
        List.from(e.map((e) => Exercise.fromJson(e)).toList());
    return exercise;
  }

  isDoneExercise(String courseId, String videoId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token')!;
    final bool isDone = await fecthData(
        'course/$courseId/video/$videoId/exercise/isdone',
        authorization: token);
    return isDone;
  }

  Future<void> addPoint(String courseId, String videoId, int point) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token')!;
    final isPass =
        await _exerciseRepository.addPoints(courseId, videoId, point, token);
    if (!isPass) {
      Get.snackbar('ผิดพลาด', 'มีบางอย่างผิดพลาด',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: whiteColor);
    }
  }
}
