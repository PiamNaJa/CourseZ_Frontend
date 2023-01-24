import 'package:flutter/material.dart';
import 'history.dart';
import 'userTeacher.dart';

class User {
  final int userId;
  final String email;
  final String fullName;
  final String nickName;
  final String birthDay;
  final String role;
  final String picture;
  final int point;
  final List<History>? history;
  final UserTeacher? userTeacher;

  User({
    required this.userId,
    required this.email,
    required this.fullName,
    required this.nickName,
    required this.birthDay,
    required this.role,
    required this.picture,
    required this.point,
    this.history,
    this.userTeacher,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['user_id'],
      email: json['email'],
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
