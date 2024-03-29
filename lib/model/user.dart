import 'package:coursez/model/address.dart';
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
  List<VideoHistory> videoHistory;
  List<CourseHistory> courseHistory;
  UserTeacher? userTeacher;
  List<Video> paidVideos;
  List<Video> likeVideos;
  List<Course> likeCourses;

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
    this.password,
    required this.videoHistory,
    this.userTeacher,
    required this.courseHistory,
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
      videoHistory: json['video_history'] != null
          ? List.from(json['video_history']
              .map((c) => VideoHistory.fromJson(c))
              .toList())
          : List.empty(),
      courseHistory: json['course_history'] != null
          ? List.from(json['course_history']
              .map((c) => CourseHistory.fromJson(c))
              .toList())
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
    );
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['password'] = password;
    data['fullname'] = fullName;
    data['nickname'] = nickName;
    data['picture'] = picture;
    data['role'] = role;
    return data;
  }
}
