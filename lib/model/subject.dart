class Subject{
  final int subjectId;
  final String subjectTitle;
  final int classLevel;
  final String subjectPicture;

  Subject({
    required this.subjectId,
    required this.subjectTitle,
    required this.classLevel,
    required this.subjectPicture,
  });

  factory Subject.fromJson(Map<String, dynamic> json) {
    return Subject(
      subjectId: json['subject_id'],
      subjectTitle: json['subject_title'],
      classLevel: json['class_level'],
      subjectPicture: json['subject_picture'],
    );
  }
}