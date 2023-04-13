import 'package:coursez/model/tutor.dart';
import 'package:coursez/model/user.dart';
import 'package:coursez/utils/fetchData.dart';

class TutorViewModel {
  Future<List<dynamic>> loadTutor(int level) async {
    List<Tutor> tutor = [];
    if (level != 0) {
      final t = await fecthData('user/teacher/class/$level');
      tutor = List.from(t.map((e) => Tutor.fromJson(e)).toList());
    } else {
      final t = await fecthData('user/teacher');
      tutor = List.from(t.map((e) => Tutor.fromJson(e)).toList());
    }
    return tutor;
  }

  Future<User> loadTutorById(String teacherId) async {
    final t = await fecthData('user/teacher/$teacherId');
    return User.fromJson(t);
  }
}
