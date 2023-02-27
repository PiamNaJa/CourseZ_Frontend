import 'package:coursez/model/course.dart';
import 'package:coursez/model/user.dart';
import 'package:coursez/model/userTeacher.dart';
import 'package:coursez/model/video.dart';
import 'package:coursez/utils/fetchData.dart';

class VideoViewModel {
  Future<Video> loadVideoById(String courseid, String videoid) async {
    final v = await fecthData("course/$courseid/video/$videoid");

    return Video.fromJson(v);
  }

  double loadVideoRating(Video video) {
    double rating = 0;
    int count = 0;
    for (var i = 0; i < video.reviews.length; i++) {
      rating += video.reviews[i].rating;
      count++;
    }
    if (count != 0) return (rating / count);

    return 0;
  }

  int loadVideoRatingByStar(Video video, int star) {
    int count = 0;
    for (var i = 0; i < video.reviews.length; i++) {
      if (video.reviews[i].rating == star) count++;
    }
    return count;
  }

  double loadPercentRating(Video video, int star) {
    int count = 0;
    for (var i = 0; i < video.reviews.length; i++) {
      if (video.reviews[i].rating == star) count++;
    }
    if (video.reviews.isNotEmpty) {
      return (count / video.reviews.length);
    }

    return 0;
  }

  Future<User> getTeacherName(int teacherid) async {
    final t = await fecthData("user/teacher/$teacherid");
    final dynamic teacher = User.fromJson(t);

    return teacher;
  }

  double getTutorRating(UserTeacher teacher) {
    double rating = 0;
    if (teacher.reviews!.isEmpty) {
      return 0;
    } else {
      for (var i = 0; i < teacher.reviews!.length; i++) {
        rating += teacher.reviews![i].rating;
      }
      return (rating / teacher.reviews!.length);
    }
  }
}
