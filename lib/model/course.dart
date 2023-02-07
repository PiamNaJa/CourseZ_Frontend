import 'video.dart';
import 'subject.dart';

class Course {
  late int courseId;
  late int subjectId;
  late Subject? subject;
  late List<dynamic> videos;
  late int teacherId;
  late String coursename;
  late String picture;
  late String description;
  late double? rating;

  Course(
      {required this.courseId,
      required this.subjectId,
      required this.subject,
      required this.videos,
      required this.teacherId,
      required this.coursename,
      required this.picture,
      required this.description,
      this.rating});

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      courseId: json['course_id'] ,
      subjectId: json['subject_id'],
      subject: json['subject'] != null ? Subject.fromJson(json['subject']): null,
      videos: json['videos'] != null
          ? json['videos'].map((c) => Video.fromJson(c)).toList()
          : List.empty(),
      teacherId: json['teacher_id'],
      coursename: json['course_name'],
      picture: json['picture'],
      description: json['description'],
    );
  }
}
