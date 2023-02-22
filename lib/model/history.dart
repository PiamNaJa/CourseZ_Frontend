import 'video.dart';

class History {
  final int historyId;
  final int userId;
  final int videoId;
  final List<Video> videos;
  final int duration;

  History(
      {required this.historyId,
      required this.userId,
      required this.videoId,
      required this.videos,
      required this.duration});

  factory History.fromJson(Map<String, dynamic> json) {
    return History(
      historyId: json['history_id'],
      userId: json['user_id'],
      videoId: json['video_id'],
      videos: json['videos'] != null
          ? List.from(json['videos'].map((c) => Video.fromJson(c)).toList())
          : List.empty(),
      duration: json['duration'],
    );
  }
}
