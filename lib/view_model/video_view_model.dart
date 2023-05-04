import 'dart:io';

import 'package:coursez/controllers/refresh_controller.dart';
import 'package:coursez/model/user.dart';
import 'package:coursez/model/userTeacher.dart';
import 'package:coursez/model/video.dart';
import 'package:coursez/repository/history_repository.dart';
import 'package:coursez/repository/video_repository.dart';
import 'package:coursez/utils/fetchData.dart';
import 'package:coursez/view_model/date_view_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../repository/review_repository.dart';
import '../utils/color.dart';

class VideoViewModel {
  final ReviewRepository _reviewRepository = ReviewRepository();
  final HistoryRepository historyRepository = HistoryRepository();
  final VideoRepository videoRepository = VideoRepository();
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
      debugPrint("add video history success");
    } else {
      debugPrint(res.body);
    }
  }

  Future<void> deleteVideo(String courseId, String videoId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token')!;
    final isPass = await videoRepository.deleteVideo(courseId, videoId, token);
    if (isPass) {
      Get.find<RefreshController>().toggleRefresh();
      Get.back();
      Get.back(result: true);
    } else {
      Get.snackbar('ผิดพลาด', 'มีบางอย่างผิดพลาด',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: whiteColor);
    }
  }

  Future<void> createVideo(int courseId, List<File?> coverImage,
      List<Video> videos, List<File?> videoFile, List<File?> pdfFile) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token')!;

    const uuid = Uuid();
    final List<String> coverImageUrls = [];
    final List<String> videoUrls = [];
    final List<String> pdfUrls = [];
    for (var i = 0; i < videos.length; i++) {
      final coverImageref = FirebaseStorage.instance
          .ref()
          .child('Course_$courseId/Video_${uuid.v4()}');

      await coverImageref.putFile(coverImage[i]!);
      coverImageUrls.add(await coverImageref.getDownloadURL());

      final videoFileref = FirebaseStorage.instance
          .ref()
          .child('Course_$courseId/Video_${uuid.v4()}');

      await videoFileref.putFile(videoFile[i]!);
      videoUrls.add(await videoFileref.getDownloadURL());

      final pdfFileref = FirebaseStorage.instance
          .ref()
          .child('Course_$courseId/Video_${uuid.v4()}');

      await pdfFileref.putFile(pdfFile[i]!);
      pdfUrls.add(await pdfFileref.getDownloadURL());

      videos[i].picture = coverImageUrls[i];
      videos[i].url = videoUrls[i];
      videos[i].sheet = pdfUrls[i];
    }

    final isPass = await videoRepository.createVideo(
        courseId, videos, token);

    if (isPass == true) {
      Get.back();
      Get.back();
      Get.back();
    } else {
      Get.snackbar('ผิดพลาด', 'มีบางอย่างผิดพลาด',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: whiteColor);
    }
  }
}
