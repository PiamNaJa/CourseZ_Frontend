import 'package:flutter/material.dart';

import 'reviewVideo.dart';
import 'exercise.dart';

class Video {
  int videoId;
  int courseId;
  String videoName;
  int price;
  String picture;
  String description;
  String url;
  String sheet;
  int createdAt;
  List<ReviewVideo> reviews;
  List<Exercise> exercises;

  Video(
      {required this.videoId,
      required this.courseId,
      required this.videoName,
      required this.price,
      required this.picture,
      required this.description,
      required this.url,
      required this.sheet,
      required this.createdAt,
      required this.reviews,
      required this.exercises});

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      videoId: json['video_id'],
      courseId: json['course_id'],
      videoName: json['video_name'],
      price: json['price'],
      picture: json['picture'],
      description: json['description'],
      url: json['url'],
      sheet: json['sheet'],
      createdAt: json['created_at'],
      reviews: json['reviews'] != null
          ? List.from(
              json['reviews'].map((c) => ReviewVideo.fromJson(c)).toList())
          : List.empty(),
      exercises: json['exercises'] != null
          ? List.from(
              json['exercises'].map((c) => Exercise.fromJson(c)).toList())
          : List.empty(),
    );
  }
}
