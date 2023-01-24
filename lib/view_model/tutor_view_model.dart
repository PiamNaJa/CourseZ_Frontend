import 'package:coursez/model/user.dart';
import 'package:coursez/utils/fetchData.dart';

class TutorViewModel {
  Future<List<User>> loadTutor(int level) async {
    final t = await fecthData('user/teacher');
    final tutor = t.map((e) => User.fromJson(e)).toList();
    List<User> tutorLevel = [];
    tutor.forEach((e) => tutorLevel.add(e));
    return tutorLevel;
  }
}
