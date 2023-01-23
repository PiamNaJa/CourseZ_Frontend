import 'package:coursez/utils/fetchData.dart';
import '../model/subject.dart';

class LevelViewModel {
  Future<List<Map<String, dynamic>>> loadLevel(int level) async {
    List<Map<String, dynamic>> level = [];
    final s = await fecthData('subject');

    final subject = s.map((e) => Subject.fromJson(e)).toList();
    for (int i in [1, 2, 3, 4, 5, 6]) {
      level.add({
        'levelName': 'มัธยมศึกษาปีที่ $i',
        'subject': subject.where((element) => element.classLevel == i).toList()
      });
    }
    level.add({
      'levelName': 'มหาวิทยาลัย',
      'subject': subject.where((subject) => subject.classLevel == 7).toList()
    });
    return level;
  }
}
