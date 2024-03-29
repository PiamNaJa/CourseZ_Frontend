import 'dart:convert';
import 'dart:io';
import 'package:coursez/controllers/auth_controller.dart';
import 'package:coursez/model/experience.dart';
import 'package:coursez/model/user.dart';
import 'package:coursez/model/userTeacher.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../repository/auth_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class AuthViewModel {
  final AuthRepository _authRepository = AuthRepository();
  final _authController = Get.find<AuthController>();
  void login(String email, String password, BuildContext context) {
    _authRepository.loginUser(email, password).then((response) async {
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('token', data['token']);
        prefs.setString('refreshToken', data['refreshToken']);
        final jwtToken = JwtDecoder.decode(data['token']);
        await _authController.fetchUser(jwtToken['user_id']);
        Get.back();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('รหัสผ่านไม่ถูกต้อง กรุณาลองใหม่อีกครั้ง'),
              backgroundColor: Colors.red,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10)),
        );
      }
    });
  }

  Future<void> logout() async {
    _authController.logout();
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    prefs.remove('refreshToken');
  }

  Future<void> checkToken(String token) async {
    final jwtToken = JwtDecoder.decode(token);
    await _authController.fetchUser(jwtToken['user_id']);
    final exp = jwtToken['exp'];
    if (exp < DateTime.now().toUtc().millisecondsSinceEpoch) {
      final String refreshToken = await getRefreshToken();
      AuthRepository().getNewToken(refreshToken).then((response) async {
        if (response.statusCode != 200) {
          await logout();
          return;
        }
        final data = json.decode(response.body);
        final jwtToken = JwtDecoder.decode(data['token']);
        await _authController.fetchUser(jwtToken['user_id']);
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('token', data['token']);
        prefs.setString('refreshToken', data['refreshToken']);
      });
    }
  }

  Future<String> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('refreshToken')!;
  }

  Future<bool> checkAuth() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token != null) {
      await checkToken(token);
      return true;
    } else {
      return false;
    }
  }

  Future<void> registerStudent(User user, File? image) async {
    const uuid = Uuid();
    Reference ref =
        FirebaseStorage.instance.ref().child("/Images/${uuid.v4()}");
    if (image != null) {
      await ref.putFile(File(image.path));
      user.picture = await ref.getDownloadURL();
    }
    final res = await _authRepository.registerStudent(user);
    if (res.statusCode == 201) {
      final data = json.decode(res.body);
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('token', data['token']);
      prefs.setString('refreshToken', data['refreshToken']);
      final jwtToken = JwtDecoder.decode(data['token']);
      await _authController.fetchUser(jwtToken['user_id']);
      Get.offAllNamed('/first');
    } else {
      debugPrint(res.body);
      Get.snackbar('Error', 'Something went wrong',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
  }

  Future<void> registerTeacher(
      User user,
      File? teacherLicense,
      File? transcript,
      File? idCard,
      String userPicture,
      List<File?> experienceImages,
      List<Experience> experiences) async {
    const uuid = Uuid();
    Reference ref =
        FirebaseStorage.instance.ref().child("/Images/${uuid.v4()}");
    if (userPicture != '') {
      await ref.putFile(File(userPicture));
      user.picture = await ref.getDownloadURL();
    }
    await ref.putFile(File(teacherLicense!.path));
    final teacherLicenseURL = await ref.getDownloadURL();
    await ref.putFile(File(transcript!.path));
    final transcriptURL = await ref.getDownloadURL();
    await ref.putFile(File(idCard!.path));
    final idCardURL = await ref.getDownloadURL();
    final teacher = UserTeacher(
        teacherLicense: teacherLicenseURL,
        transcipt: transcriptURL,
        idCard: idCardURL,
        psychologicalTest: '',
        money: 0);
    List<Experience> newExperiences = [];
    for (var i = 0; i < experienceImages.length; i++) {
      if (experienceImages[i] != null) {
        await ref.putFile(File(experienceImages[i]!.path));
        final experienceURL = await ref.getDownloadURL();
        experiences[i].evidence = experienceURL;
        newExperiences.add(experiences[i]);
      }
    }
    teacher.experiences = newExperiences;
    user.userTeacher = teacher;
    user.role = 'Teacher';
    final res = await _authRepository.registerTeacher(user);
    if (res.statusCode == 201) {
      final data = json.decode(res.body);
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('token', data['token']);
      prefs.setString('refreshToken', data['refreshToken']);
      final jwtToken = JwtDecoder.decode(data['token']);
      await _authController.fetchUser(jwtToken['user_id']);
      Get.offAllNamed('/first');
    } else {
      debugPrint(res.body);
      Get.snackbar('Error', 'Something went wrong',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
  }

  Future<void> registerTutor(
      User user,
      File? psychologicalTest,
      File? idCard,
      String userPicture,
      List<File?> experienceImages,
      List<Experience> experiences) async {
    const uuid = Uuid();
    Reference ref =
        FirebaseStorage.instance.ref().child("/Images/${uuid.v4()}");
    if (userPicture != '') {
      await ref.putFile(File(userPicture));
      user.picture = await ref.getDownloadURL();
    }
    await ref.putFile(File(psychologicalTest!.path));
    final psychologicalURL = await ref.getDownloadURL();
    await ref.putFile(File(idCard!.path));
    final idCardURL = await ref.getDownloadURL();
    final teacher = UserTeacher(
        teacherLicense: '',
        transcipt: '',
        idCard: idCardURL,
        psychologicalTest: psychologicalURL,
        money: 0);
    List<Experience> newExperiences = [];
    for (var i = 0; i < experienceImages.length; i++) {
      if (experienceImages[i] != null) {
        await ref.putFile(File(experienceImages[i]!.path));
        final experienceURL = await ref.getDownloadURL();
        experiences[i].evidence = experienceURL;
        newExperiences.add(experiences[i]);
      }
    }
    teacher.experiences = newExperiences;
    user.userTeacher = teacher;
    user.role = 'Tutor';
    final res = await _authRepository.registerTeacher(user);
    if (res.statusCode == 201) {
      final data = json.decode(res.body);
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('token', data['token']);
      prefs.setString('refreshToken', data['refreshToken']);
      final jwtToken = JwtDecoder.decode(data['token']);
      await _authController.fetchUser(jwtToken['user_id']);
      Get.offAllNamed('/first');
    } else {
      debugPrint(res.body);
      Get.snackbar('Error', 'Something went wrong',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
  }
}
