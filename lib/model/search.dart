import 'package:coursez/model/course.dart';
import 'package:coursez/model/tutor.dart';

class Search {
  final List<Course> courses;
  final List<Course> videos;
  final List<Tutor> tutors;

  Search({required this.courses, required this.videos, required this.tutors});

  factory Search.fromJson(Map<String, dynamic> json) {
    return Search(
      courses:
          List.from(json['courses'].map((c) => Course.fromJson(c)).toList()),
      videos: List.from(json['videos'].map((c) => Course.fromJson(c)).toList()),
      tutors: List.from(json['tutors'].map((c) => Tutor.fromJson(c)).toList()),
    );
  }
}
