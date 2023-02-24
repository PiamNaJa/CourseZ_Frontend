import 'package:coursez/model/exercise.dart';
import 'package:coursez/utils/fetchData.dart';

class ExerciseViewModel{
  Future<List<Exercise>> fetchExercise(String courseId, String videoId) async {
    final e = await fecthData('course/$courseId/video/$videoId/exercise');
    final List<Exercise> exercise = List.from(e.map((e) => Exercise.fromJson(e)).toList());
    return exercise;
  }
}