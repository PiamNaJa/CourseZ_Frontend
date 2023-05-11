import 'dart:convert';
import 'package:coursez/model/reviewTutor.dart';
import 'package:coursez/model/tutor.dart';
import 'package:coursez/model/user.dart';
import 'package:coursez/model/userTeacher.dart';
import 'package:coursez/utils/color.dart';
import 'package:coursez/utils/fetchData.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../repository/review_repository.dart';

class TutorViewModel {
  final ReviewRepository _reviewRepository = ReviewRepository();
  Future<List<dynamic>> loadTutor(int level) async {
    List<Tutor> tutor = [];
    if (level != 0) {
      final t = await fecthData('user/teacher/class/$level');
      tutor = List.from(t.map((e) => Tutor.fromJson(e)).toList());
    } else {
      final t = await fecthData('user/teacher');
      tutor = List.from(t.map((e) => Tutor.fromJson(e)).toList());
    }
    return tutor;
  }

  

  Future<User> loadTutorById(String teacherId) async {
    final t = await fecthData('user/teacher/$teacherId');
    return User.fromJson(t);
  }

  Future<User> getTeacherName(int teacherid) async {
    final t = await fecthData("user/teacher/$teacherid");
    final dynamic teacher = User.fromJson(t);

    return teacher;
  }

  double getTutorRating(User user) {
    double rating = 0;
    if (user.userTeacher!.reviews!.isEmpty) {
      return 0;
    } else {
      for (var i = 0; i < user.userTeacher!.reviews!.length; i++) {
        rating += user.userTeacher!.reviews![i].rating;
      }
      return (rating / user.userTeacher!.reviews!.length);
    }
  }

  double loadPercentRating(User user, int star) {
    int count = 0;
    for (var i = 0; i < user.userTeacher!.reviews!.length; i++) {
      if (user.userTeacher!.reviews![i].rating == star) count++;
    }
    if (user.userTeacher!.reviews!.isNotEmpty) {
      return (count / user.userTeacher!.reviews!.length);
    }

    return 0;
  }

  int loadTutorRatingByStar(User user, int star) {
    int count = 0;
    for (var i = 0; i < user.userTeacher!.reviews!.length; i++) {
      if (user.userTeacher!.reviews![i].rating == star) count++;
    }
    return count;
  }

  String formatReviewDate(int createdAt) {
    var date = DateTime.fromMillisecondsSinceEpoch(createdAt * 1000);
    return date.toString().substring(0, 16);
  }

  Future<void> createReviewTutor(
      String teacherId, double rating, String comment) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token')!;
    final bool isPass = await _reviewRepository.createReviewTutor(
        teacherId, rating, comment, token);
    if (!isPass) {
      Get.snackbar('ผิดพลาด', 'มีบางอย่างผิดพลาด',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: whiteColor);
    } else {
      Get.back();
    }
  }

  Future<List<ReviewTutor>> loadReviewTutor(String teacherId) async {
    final p = await fecthData('review/teacher/$teacherId');
    List<ReviewTutor> review =
        List.from(p.map((e) => ReviewTutor.fromJson(e)).toList());
    review.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    if (teacherId.isEmpty) {
      return review;
    } else {
      return review.where((element) => element.teacherId == teacherId).toList();
    }
  }
}
