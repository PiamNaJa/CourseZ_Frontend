import 'package:coursez/model/user.dart';
import 'package:coursez/model/userTeacher.dart';
import 'package:coursez/model/video.dart';
import 'package:coursez/repository/history_repository.dart';
import 'package:coursez/utils/fetchData.dart';
import 'package:coursez/view_model/date_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VideoViewModel {
  HistoryRepository historyRepository = HistoryRepository();
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

  String formatReviewDate(int createdAt) {
    var date = DateTime.fromMillisecondsSinceEpoch(createdAt * 1000);
    return date.toString().substring(0, 16);
  }

  String formatVideoDate(int createdAt) {
    DateViewModel dateViewModel = DateViewModel();
    String timeago = dateViewModel.formatDate(createdAt);
    timeago = timeago.replaceAll(' ago', 'ที่แล้ว');

    return timeago;
  }

  Future<int> getVideoHistoryDuration(String videoId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token')!;
    final h = await fecthData("history/$videoId", authorization: token);
    if (h.runtimeType == String && h.contains("not found")) {
      return 0;
    }
    return h;
  }

  Future<void> addVideoHistory(String videoId, int duration) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token')!;
    final res =
        await historyRepository.addVideoHistory(videoId, duration, token);
    if (res.statusCode == 201) {
      print("add video history success");
    } else {
      print(res.body);
    }
  }
}
