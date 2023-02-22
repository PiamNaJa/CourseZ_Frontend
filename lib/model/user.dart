import 'package:coursez/model/course.dart';
import 'package:coursez/model/payment.dart';
import 'package:coursez/model/video.dart';
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
  List<History> history;
  UserTeacher? userTeacher;
  List<Video> paidVideos;
  List<Video> likeVideos;
  List<Course> likeCourses;
  List<Payment> transactions;

  User({
    this.userId,
    required this.email,
    required this.fullName,
    required this.nickName,
    required this.role,
    required this.picture,
    required this.point,
    required this.paidVideos,
    required this.likeVideos,
    required this.likeCourses,
    required this.transactions,
    this.password,
    required this.history,
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
          ? List.from(json['history'].map((c) => History.fromJson(c)).toList())
          : List.empty(),
      userTeacher: json['teacher'] != null
          ? UserTeacher.fromJson(json['teacher'])
          : null,
      paidVideos: json['paid_videos'] != null
          ? List.from(
              json['paid_videos'].map((c) => Video.fromJson(c)).toList())
          : List.empty(),
      likeVideos: json['like_videos'] != null
          ? List.from(
              json['like_videos'].map((c) => Video.fromJson(c)).toList())
          : List.empty(),
      likeCourses: json['like_courses'] != null
          ? List.from(
              json['like_courses'].map((c) => Course.fromJson(c)).toList())
          : List.empty(),
      transactions: json['payment'] != null
          ? List.from(json['payment'].map((c) => Payment.fromJson(c)).toList())
          : List.empty(),
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
