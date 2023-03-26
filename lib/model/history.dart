import 'package:coursez/model/course.dart';

import 'video.dart';

class VideoHistory {
  final int historyId;
  final int userId;
  final int videoId;
  final Video videos;
  final int duration;

  VideoHistory(
      {required this.historyId,
      required this.userId,
      required this.videoId,
      required this.videos,
      required this.duration});

  factory VideoHistory.fromJson(Map<String, dynamic> json) {
    return VideoHistory(
      historyId: json['history_id'],
      userId: json['user_id'],
      videoId: json['video_id'],
      videos: Video.fromJson(json['video']),
      duration: json['duration'],
    );
  }
}

class CourseHistory {
  final int historyId;
  final int userId;
  final Course courses;

  CourseHistory(
      {required this.historyId,
      required this.userId,
      required this.courses,});

  factory CourseHistory.fromJson(Map<String, dynamic> json) {
    return CourseHistory(
      historyId: json['history_id'],
      userId: json['user_id'],
      courses: Course.fromJson(json['course']),
    );
  }
}