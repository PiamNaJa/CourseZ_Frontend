import 'package:coursez/model/tutor.dart';
import 'package:coursez/model/user.dart';
import 'package:coursez/utils/fetchData.dart';

class TutorViewModel {
  Future<List<dynamic>> loadTutor(int level) async {
    List<dynamic> tutorLevel = [];
    if (level != 0) {
      final t = await fecthData('user/teacher/class/$level');
      t.map((e) => tutorLevel.add(e)).toList();
    } else {
      final t = await fecthData('user/teacher');
      t.forEach((e) => tutorLevel.add(e));
    }
    return tutorLevel;
  }

  Future<User> loadTutorById(String teacherId) async {
    final t = await fecthData('user/teacher/$teacherId');
    return User.fromJson(t);
  }
}
