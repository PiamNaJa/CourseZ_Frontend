import 'dart:io';

import 'package:coursez/controllers/auth_controller.dart';
import 'package:coursez/controllers/refresh_controller.dart';
import 'package:coursez/model/course.dart';
import 'package:coursez/model/video.dart';
import 'package:coursez/repository/course_repository.dart';
import 'package:coursez/view_model/video_view_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:coursez/repository/payment.dart';
import 'package:coursez/utils/color.dart';
import 'package:coursez/utils/fetchData.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../model/video.dart';

class CourseViewModel {
  final CourseRepository courseRepository = CourseRepository();
  final AuthController authController = Get.find<AuthController>();
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

    for (var i = 0; i < courseLevel.length; i++) {
      courseLevel[i] = calculateCourseRating(courseLevel[i]);
    }
    final sortedCourses = courseInsertionSort(courseLevel);
    return sortedCourses;
  }

  Future<List<Course>> loadCourseBySubject(int subjectId) async {
    final c = await fecthData('course');
    final course = c.map((e) => Course.fromJson(e)).toList();
    final cs = course
        .where((element) => element.subject?.subjectId == subjectId)
        .toList();
    List<Course> courseSubject = List.from(cs);
    for (int i = 0; i < courseSubject.length; i++) {
      courseSubject[i] = calculateCourseRating(courseSubject[i]);
    }
    final sortedCourses = courseInsertionSort(courseSubject);
    return sortedCourses;
  }

  Future<List<Course>> loadRecommendCourse() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token')!;
    final c = await fecthData('course/recommend/user/${authController.userid}',
        authorization: token);
    if (c is String) {
      final AuthController authController = Get.find<AuthController>();
      authController.logout();
      return [];
    }
    final List<Course> courses = List.from(c.map((e) => Course.fromJson(e)));
    return courses;
  }

  Course calculateCourseRating(Course course) {
    double rating = 0;
    int count = 0;
    for (int i = 0; i < course.videos.length; i++) {
      for (int j = 0; j < course.videos[i].reviews.length; j++) {
        rating += course.videos[i].reviews[j].rating;
        count++;
      }
    }
    if (count != 0) {
      course.rating = rating / count;
    } else {
      course.rating = 0;
    }
    return course;
  }

  List<Course> courseInsertionSort(List<Course> courses) {
    for (int i = 0; i < courses.length; i++) {
      final key = courses[i];
      int j = i - 1;
      while (j >= 0 && courses[j].rating < key.rating) {
        courses[j + 1] = courses[j];
        j = j - 1;
      }
      courses[j + 1] = key;
    }
    return courses;
  }

  Future<Course> loadCourseById(int courseId) async {
    final c = await fecthData('course/$courseId');
    final course = Course.fromJson(c);
    course.videos.sort((a, b) => a.videoId.compareTo(b.videoId));

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

    return course;
  }

  Future<void> deleteCourse(int courseId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token')!;
    final isPass = await courseRepository.deleteCourse(courseId, token);
    if (!isPass) {
      Get.snackbar('ผิดพลาด', 'มีบางอย่างผิดพลาด',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: whiteColor);
    } else {
      final RefreshController refreshController = Get.find<RefreshController>();
      refreshController.toggleRefresh();
      Get.back();
      Get.back();
      Get.snackbar('สำเร็จ', 'ลบคอร์สเรียบร้อย',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: primaryColor,
          colorText: whiteColor);
    }
  }

  Future<List> allVideoPriceInCourse(Course course) async {
    num price = 0;
    List<int> videosId = [];
    final AuthController authController = Get.find<AuthController>();
    for (var element in course.videos) {
      if (element.price == 0 || authController.teacherId == course.teacherId) {
        continue;
      }
      price += element.price;
      videosId.add(element.videoId);
    }
    if (authController.isLogin) {
      final value = await getPaidVideo();
      for (var id in value) {
        if (videosId.contains(id)) {
          price -=
              course.videos.firstWhere((video) => video.videoId == id).price;
          videosId.remove(id);
        }
      }
    }
    debugPrint(price.toString());
    return [price.toInt(), videosId];
  }

  Future<void> buyAllVideoInCourse(Course course) async {
    try {
      var videos = await allVideoPriceInCourse(course);
      final paymentIntent =
          await PaymentApi.createPaymentIntent((videos.first * 100).toString());
      await PaymentApi.makePayment(paymentIntent['client_secret']);
      await PaymentApi.showPayment(paymentIntent['client_secret']);
      await PaymentApi.savePayment(videos.last);
      Get.snackbar('สำเร็จ', 'ชำระเงินสำเร็จ',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: primaryColor,
          colorText: whiteColor);
    } on Exception catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> buyVideo(int price, int videoId) async {
    try {
      List<int> videos = List.filled(1, videoId);
      final paymentIntent =
          await PaymentApi.createPaymentIntent((price * 100).toString());
      await PaymentApi.makePayment(paymentIntent['client_secret']);
      await PaymentApi.showPayment(paymentIntent['client_secret']);
      await PaymentApi.savePayment(videos);
      Get.snackbar('สำเร็จ', 'ชำระเงินสำเร็จ',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: primaryColor,
          colorText: whiteColor);
    } on Exception catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<List<dynamic>> getPaidVideo() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final List<dynamic> c =
        await fecthData('payment/paid/videos', authorization: token!);
    return c;
  }

  Future<void> likeOrUnlikeCourse(String courseId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final bool isPass =
        await courseRepository.likeOrUnlikeCourse(courseId, token!);

    if (!isPass) {
      Get.snackbar('ผิดพลาด', 'มีบางอย่างผิดพลาด',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: whiteColor);
    }
  }

  Future<bool> checkIsLikeCourse(String courseId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final bool isLike =
        await fecthData('course/$courseId/islike', authorization: token!);
    return isLike;
  }

  Future<void> createCourse(
      File courseImage,
      Course course,
      List<File?> coverImage,
      List<Video> videos,
      List<File?> videoFile,
      List<File?> pdfFile) async {
    VideoViewModel videoViewModel = VideoViewModel();
    final uuid = const Uuid().v4();
    final Reference ref = FirebaseStorage.instance.ref().child("/Course_$uuid");
    await ref.putFile(courseImage);
    final String courseImageURL = await ref.getDownloadURL();
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final int courseId =
        await courseRepository.createCourse(course, courseImageURL, token!);
    if (courseId == -1) {
      Get.snackbar('ผิดพลาด', 'มีบางอย่างผิดพลาด',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: whiteColor);
      return;
    }
    videoViewModel.createVideo(
        courseId, coverImage, videos, videoFile, pdfFile);
  }

  Future<void> updatecourse(
    File? courseImage,
    int subjectId,
    Course course,
  ) async {
    final uuid = const Uuid().v4();
    if (courseImage != null) {
      final Reference ref =
          FirebaseStorage.instance.ref().child("/Course_$uuid");
      await ref.putFile(courseImage);
      final String courseImageURL = await ref.getDownloadURL();
      course.picture = courseImageURL;
    }
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    print(subjectId);
    final bool isPass =
        await courseRepository.updatecourse(course, subjectId, token!);
    if (!isPass) {
      Get.snackbar('ผิดพลาด', 'มีบางอย่างผิดพลาด',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: whiteColor);
      return;
    }
    RefreshController refreshController = Get.find();
    refreshController.toggleRefresh();
    Get.back();
  }
}
