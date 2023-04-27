import 'video.dart';
import 'subject.dart';

class Course {
  int courseId;
  int subjectId;
  Subject? subject;
  List<Video> videos;
  int teacherId;
  String coursename;
  String picture;
  String description;
  double rating;
  int createdAt;

  Course(
      {required this.courseId,
      required this.subjectId,
      required this.subject,
      required this.videos,
      required this.teacherId,
      required this.coursename,
      required this.picture,
      required this.description,
      required this.createdAt,
      this.rating = 0});

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
        courseId: json['course_id'],
        subjectId: json['subject_id'],
        subject:
            json['subject'] != null ? Subject.fromJson(json['subject']) : null,
        videos: json['videos'] != null
            ? List.from(json['videos'].map((c) => Video.fromJson(c)).toList())
            : List.empty(),
        teacherId: json['teacher_id'],
        coursename: json['course_name'],
        picture: json['picture'],
        description: json['description'],
        createdAt: json['created_at'],
        rating: json['rating'].toDouble() ?? 0.0);
  }
}
