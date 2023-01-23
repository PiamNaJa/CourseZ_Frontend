class Experience {
  int? experienceId;
  int? teacherId;
  String title;
  String evidence;

  Experience(
      {this.experienceId,
      this.teacherId,
      required this.title,
      required this.evidence});

  factory Experience.fromJson(Map<String, dynamic> json) {
    return Experience(
      experienceId: json['experience_id'],
      teacherId: json['teacher_id'],
      title: json['title'],
      evidence: json['evidence'],
    );
  }
}
