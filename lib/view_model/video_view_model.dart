import 'package:coursez/model/course.dart';
import 'package:coursez/model/reviewVideo.dart';
import 'package:coursez/model/user.dart';
import 'package:coursez/model/userTeacher.dart';
import 'package:coursez/model/video.dart';
import 'package:coursez/repository/review_repository.dart';
import 'package:coursez/utils/fetchData.dart';
import 'package:coursez/view_model/date_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:jiffy/jiffy.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VideoViewModel {
  final ReviewRepository _reviewRepository = ReviewRepository();

  get whiteColor => null;
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

  Future<void> createReviewVideo(
      String videoId, double rating, String comment) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token')!;
    final bool isPass = await _reviewRepository.createReviewVideo(
        videoId, rating, comment, token);
    if (!isPass) {
      Get.snackbar('ผิดพลาด', 'มีบางอย่างผิดพลาด',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: whiteColor);
    } else {
      Get.back();
      Get.back();
      Get.back();
    }
  }
}
