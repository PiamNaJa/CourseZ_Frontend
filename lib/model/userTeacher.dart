import 'experience.dart';
import 'reviewTutor.dart';
import 'course.dart';

class UserTeacher {
  final int? teacherId;
  final int? userId;
  final String? teacherLicense;
  final String? transcipt;
  final String idCard;
  final String? psychologicalTest;
  final int money;
  final List<ReviewTutor>? reviews;
  List<Experience>? experiences;
  final List<Course>? courses;

  UserTeacher(
      {this.teacherId,
      this.userId,
      this.teacherLicense,
      this.transcipt,
      required this.idCard,
      this.psychologicalTest,
      this.money = 0,
      this.reviews,
      this.experiences,
      this.courses,});

  factory UserTeacher.fromJson(Map<String, dynamic> json) {
    return UserTeacher(
      teacherId: json['teacher_id'],
      userId: json['user_id'],
      teacherLicense: json['teacher_license'],
      transcipt: json['transcipt'],
      idCard: json['id_card'],
      psychologicalTest: json['psychologicalTest'],
      money: json['money'],
      reviews: json['reviews'] != null
          ? List.from(
              json['reviews'].map((c) => ReviewTutor.fromJson(c)).toList())
          : List.empty(),
      experiences: json['experiences'] != null
          ? json['experiences'].map((c) => Experience.fromJson(c)).toList()
          : List.empty(),
      courses: json['courses'] != null
          ? List.from(json['courses'].map((c) => Course.fromJson(c)).toList())
          : List.empty(),
    );
  }
}
