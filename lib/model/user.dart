import 'package:flutter/material.dart';
import 'history.dart';
import 'userTeacher.dart';

class User {
  int? userId;
  String email;
  String? password;
  String fullName;
  String nickName;
  String birthDay;
  String role;
  String picture;
  int point;
  List<History>? history;
  UserTeacher? userTeacher;

  User({
    this.userId,
    required this.email,
    required this.fullName,
    required this.nickName,
    required this.birthDay,
    required this.role,
    required this.picture,
    required this.point,
    this.password,
    this.history,
    this.userTeacher,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['user_id'],
      email: json['email'],
      password: json['password'] ?? null,
      fullName: json['fullname'],
      nickName: json['nickname'],
      birthDay: json['birthday'],
      role: json['role'],
      picture: json['picture'],
      point: json['point'],
      history: json['history'] != null
          ? json['history'].map((c) => History.fromJson(c)).toList()
          : List.empty(),
      userTeacher: json['teacher'] != null
          ? UserTeacher.fromJson(json['teacher'])
          : null,
    );
  }
}
