import 'dart:io';

import 'package:coursez/controllers/refresh_controller.dart';
import 'package:coursez/model/course.dart';
import 'package:coursez/model/payment.dart';
import 'package:coursez/model/video.dart';
import 'package:coursez/repository/auth_repository.dart';
import 'package:coursez/view_model/auth_view_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../controllers/auth_controller.dart';
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
    for (var i = 0; i < user.courseHistory.length; i++) {
      user.courseHistory[i].courses.rating =
          await calRatingByCourseId(user.courseHistory[i].courses.courseId);
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

  Future<void> updateUser(File? picture, User user) async {
    if (picture != null) {
      const uuid = Uuid();
      final ref = FirebaseStorage.instance.ref().child("Image/${uuid.v4()}");
      await ref.putFile(picture);
      user.picture = await ref.getDownloadURL();
    }
    final AuthController authController = Get.find<AuthController>();
    final RefreshController refreshController = Get.find<RefreshController>();
    final AuthRepository authRepository = AuthRepository();
    final pref = await SharedPreferences.getInstance();
    final token = pref.getString('token')!;
    final res =
        await authRepository.updateUser(user, authController.userid, token);
    if (res.statusCode != 200) {
      Get.snackbar('Error', 'Something went wrong',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      return;
    }
    authController.fetchUser(authController.userid);
    refreshController.toggleRefresh();
    Get.back();
  }

  Future<List<Video>> getPaidVideoObject() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final List<dynamic> c =
        await fecthData('payment/paid/videos/object', authorization: token!);
    final List<Video> video =
        List.from(c.map((e) => Video.fromJson(e)).toList());
    return video;
  }
}
