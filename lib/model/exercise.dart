import 'choice.dart';

class Exercise {
  final int exerciseId;
  final int videoId;
  final String question;
  final String image;
  final List<Choice> choices;

  Exercise({
    required this.exerciseId,
    required this.videoId,
    required this.question,
    required this.image,
    required this.choices,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      exerciseId: json['exercise_id'],
      videoId: json['video_id'],
      question: json['question'],
      image: json['image'],
      choices: json['choices'] != null
          ? List.from(json['choices'].map((c) => Choice.fromJson(c)).toList())
          : List.empty(),
    );
  }
}
