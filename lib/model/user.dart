import 'package:coursez/model/video.dart';
import 'package:flutter/material.dart';
import 'history.dart';
import 'userTeacher.dart';

class User {
  int? userId;
  String email;
  String? password;
  String fullName;
  String nickName;
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
      password: json['password'],
      fullName: json['fullname'],
      nickName: json['nickname'],
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
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Email'] = email;
    data['Password'] = password;
    data['Fullname'] = fullName;
    data['Nickname'] = nickName;
    data['Picture'] = picture;
    data['Role'] = role;
    return data;
  }
}
