class ReviewTutor {
  final int reviewTutorId;
  final int teacherId;
  final int rating;
  final String comment;
  final int createdAt;

  ReviewTutor(
      {required this.reviewTutorId,
      required this.teacherId,
      required this.rating,
      required this.comment,
      required this.createdAt});

  factory ReviewTutor.fromJson(Map<String, dynamic> json) {
    return ReviewTutor(
      reviewTutorId: json['review_tutor_id'],
      teacherId: json['teacher_id'],
      rating: json['rating'],
      comment: json['comment'],
      createdAt: json['created_at'],
    );
  }
}
