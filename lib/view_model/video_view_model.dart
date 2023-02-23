import 'package:coursez/model/course.dart';
import 'package:coursez/model/user.dart';
import 'package:coursez/model/userTeacher.dart';
import 'package:coursez/model/video.dart';
import 'package:coursez/utils/fetchData.dart';
import 'package:jiffy/jiffy.dart';

class VideoViewModel {
  Future<Video> loadVideoById(int courseid, int videoid) async {
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

  String formatReviewDate(int createdAt) {
    var date = DateTime.fromMillisecondsSinceEpoch(createdAt * 1000);
    return date.toString().substring(0, 16);
  }

  String formatVideoDate(int createdAt) {
    var date = DateTime.fromMillisecondsSinceEpoch(createdAt * 1000);
    String timeago = Jiffy(date).fromNow();
    if (timeago.contains('minutes')) {
      timeago = timeago.replaceAll('minutes', 'นาที');
    } else if (timeago.contains('hours')) {
      timeago = timeago.replaceAll('hours', 'ชั่วโมง');
    } else if (timeago.contains('days')) {
      timeago = timeago.replaceAll('days', 'วัน');
    } else if (timeago.contains('months')) {
      timeago = timeago.replaceAll('months', 'เดือน');
    } else if (timeago.contains('years')) {
      timeago = timeago.replaceAll('years', 'ปี');
    } else if (timeago.contains('minute')) {
      timeago = timeago.replaceAll('minute', 'นาที');
    } else if (timeago.contains('hour')) {
      timeago = timeago.replaceAll('hour', 'ชั่วโมง');
    } else if (timeago.contains('day')) {
      timeago = timeago.replaceAll('day', 'วัน');
    } else if (timeago.contains('month')) {
      timeago = timeago.replaceAll('month', 'เดือน');
    } else if (timeago.contains('year')) {
      timeago = timeago.replaceAll('year', 'ปี');
    }
    timeago = timeago.replaceAll(' ago', 'ที่แล้ว');

    return timeago;
  }
}
