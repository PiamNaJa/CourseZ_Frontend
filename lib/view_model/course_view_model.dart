import 'package:coursez/model/course.dart';
import 'package:flutter/material.dart';
import 'package:coursez/model/video.dart';
import 'package:coursez/repository/payment.dart';
import 'package:coursez/utils/color.dart';
import 'package:coursez/utils/fetchData.dart';
import 'package:get/get.dart';

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

    for (var i = 0; i < courseLevel.length; i++) {
      double rating = 0;
      int count = 0;
      for (var j = 0; j < courseLevel[i].videos.length; j++) {
        for (var k = 0; k < courseLevel[i].videos[j].reviews.length; k++) {
          rating += courseLevel[i].videos[j].reviews[k].rating;
          count++;
        }
      }
      if (count != 0) {
        courseLevel[i].rating = rating / count;
      } else {
        courseLevel[i].rating = 0;
      }
    }
    return courseLevel;
  }

  Future<List<Course>> loadCourseBySubject(int subjectId) async {
    final c = await fecthData('course');
    final course = c.map((e) => Course.fromJson(e)).toList();
    List<Course> courseSubject = [];
    final cs = course
        .where((element) => element.subject?.subjectId == subjectId)
        .toList();
    cs.forEach((e) => courseSubject.add(e));
    for (var i = 0; i < courseSubject.length; i++) {
      double rating = 0;
      int count = 0;
      for (var j = 0; j < courseSubject[i].videos.length; j++) {
        for (var k = 0; k < courseSubject[i].videos[j].reviews.length; k++) {
          rating += courseSubject[i].videos[j].reviews[k].rating;
          count++;
        }
      }
      if (count != 0) {
        courseSubject[i].rating = rating / count;
      } else {
        courseSubject[i].rating = 0;
      }
    }
    return courseSubject;
  }

  Future<Course> loadCourseById(int courseId) async {
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
      } else {
        course.rating = 0;
      }
    }

    return course;
  }

  int allVideoPriceInCourse(Course course) {
    num price = 0;
    for (var element in course.videos) {
      price += element.price;
    }
    return price.toInt();
  }

  Future<void> buyAllVideoInCourse(Course course) async {
    try {
      int amount = allVideoPriceInCourse(course);
      final paymentIntent =
          await PaymentApi.createPaymentIntent((amount * 100).toString());
      await PaymentApi.makePayment(paymentIntent['client_secret']);
      await PaymentApi.showPayment(paymentIntent['client_secret']);
      Get.snackbar('สำเร็จ', 'ชำระเงินสำเร็จ',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: primaryColor,
          colorText: whiteColor);
    } on Exception catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> buyVideo(Video video) async {
    try {
      final paymentIntent =
          await PaymentApi.createPaymentIntent((video.price * 100).toString());
      await PaymentApi.makePayment(paymentIntent['client_secret']);
      await PaymentApi.showPayment(paymentIntent['client_secret']);
      Get.snackbar('สำเร็จ', 'ชำระเงินสำเร็จ',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: primaryColor,
          colorText: whiteColor);
    } on Exception catch (e) {
      debugPrint(e.toString());
    }
  }
}
