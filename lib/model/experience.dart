class Experience {
  final int experienceId;
  final int teacherId;
  final String title;
  final String evidence;

  Experience(
      {required this.experienceId,
      required this.teacherId,
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
