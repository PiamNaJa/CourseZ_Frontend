import 'package:coursez/model/course.dart';
import 'package:coursez/utils/fetchData.dart';

class CourseViewModel {
  Future<List<Course>> loadCourse(int level) async {
    final c = await fecthData('course');
    final course = c.map((e) => Course.fromJson(e)).toList();
    List<Course> courseLevel = [];
    if (level != 0) {
      final cl = course
          .where((element) => element.subject?.classLevel == level)
          .toList();
      cl.forEach((e) => courseLevel.add(e));
    } else {
      course.forEach((e) => courseLevel.add(e));
    }
    return courseLevel;
  }
}
