import 'package:coursez/model/course.dart';

import '../model/user.dart';
import '../utils/fetchData.dart';

class ProfileViewModel {
  Future<User> fetchUser(int userID) async {
    final u = await fecthData('user/$userID');

    final user = User.fromJson(u);
    for (var i = 0; i < user.likeCourses.length; i++) {
      user.likeCourses[i].rating =
          await calRatingByCourseId(user.likeCourses[i].courseId);
    }
    return user;
  }

  Future<double> calRatingByCourseId(int courseId) async {
    final c = await fecthData('course/$courseId');
    final course = Course.fromJson(c);

    for (var i = 0; i < course.videos.length; i++) {
      double rating = 0;
      int count = 0;
      for (var j = 0; j < course.videos[i].reviews.length; j++) {
        rating += course.videos[i].reviews[j].rating;
        count++;
      }
      if (count != 0) {
        course.rating = rating / count;
      }
    }

    return course.rating;
  }
}
