class ReviewTutor {
  final int reviewTutorId;
  final int teacherId;
  final int rating;
  final String comment;

  ReviewTutor(
      {required this.reviewTutorId,
      required this.teacherId,
      required this.rating,
      required this.comment});

  factory ReviewTutor.fromJson(Map<String, dynamic> json) {
    return ReviewTutor(
      reviewTutorId: json['review_tutor_id'],
      teacherId: json['teacher_id'],
      rating: json['rating'],
      comment: json['comment'],
    );
  }
}
