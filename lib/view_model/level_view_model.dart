import 'package:coursez/utils/fetchData.dart';
import '../model/subject.dart';

class LevelViewModel {
  Future<List<Map<String, dynamic>>> loadLevel(int level) async {
    List<Map<String, dynamic>> levelSubject = [];
    final s = await fecthData('subject');

    final subject = s.map((e) => Subject.fromJson(e)).toList();

    if (level == 0) {
      for (int i in [1, 2, 3, 4, 5, 6]) {
        levelSubject.add({
          'level': i,
          'levelName': 'มัธยมศึกษาปีที่ $i',
          'subject':
              subject.where((element) => element.classLevel == i).toList()
        });
      }
      levelSubject.add({
        'level': 7,
        'levelName': 'มหาวิทยาลัย',
        'subject': subject.where((subject) => subject.classLevel == 7).toList()
      });
    } else {
      levelSubject.add({
        'level': level,
        'levelName': (level == 7) ? 'มหาวิทยาลัย' : 'มัธยมศึกษาปีที่ $level',
        'subject':
            subject.where((element) => element.classLevel == level).toList()
      });
    }

    return levelSubject;
  }
}
