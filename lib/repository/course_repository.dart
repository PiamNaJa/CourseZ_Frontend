import 'dart:convert';

import 'package:coursez/controllers/auth_controller.dart';
import 'package:coursez/model/course.dart';
import 'package:coursez/utils/network.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class CourseRepository {
  Future<bool> likeOrUnlikeCourse(String courseId, String token) async {
    final url = '${Network.baseUrl}/api/course/$courseId/like';
    final res = await http.patch(Uri.parse(url), headers: {
      "Authorization": token,
    });
    if (res.statusCode == 200) {
      return true;
    }
    return false;
  }

  Future<bool> deleteCourse(int courseid, String token) async {
    final url = '${Network.baseUrl}/api/course/$courseid';
    final res = await http.delete(Uri.parse(url), headers: {
      "Authorization": token,
    });
    if (res.statusCode == 204) {
      return true;
    }
    debugPrint(res.body);
    return false;
  }

  Future<int> createCourse(
      Course course, String courseImage, String token) async {
        final AuthController authController = Get.find<AuthController>();
    const url = '${Network.baseUrl}/api/course';
    final Map<String, dynamic> data = {
      "course_name": course.coursename,
      "picture": courseImage,
      "description": course.description,
      "subject_title": course.subject!.subjectTitle,
      "class_level": course.subject!.classLevel,
      "teacher_id": authController.teacherId
    };
    final res = await http.post(Uri.parse(url),
        headers: {"Authorization": token, "Content-Type": "application/json"},
        body: json.encode(data));
    if (res.statusCode == 201) {
      return json.decode(res.body)["course_id"];
    }
    debugPrint(res.body);
    return -1;
  }
}
