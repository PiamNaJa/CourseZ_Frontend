class ReviewVideo {
  final int reviewVideoId;
  final int videoId;
  final double rating;
  final String comment;

  ReviewVideo(
      {required this.reviewVideoId,
      required this.videoId,
      required this.rating,
      required this.comment});

  factory ReviewVideo.fromJson(Map<String, dynamic> json) {
    return ReviewVideo(
      reviewVideoId: json['review_video_id'],
      videoId: json['video_id'],
      rating: json['rating'].toDouble(),
      comment: json['comment'],
    );
  }
}
