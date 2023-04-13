
class Choice {
  final int choiceId;
  final int exerciseId;
  final String title;
  final bool correct;

  Choice({
    required this.choiceId,
    required this.exerciseId,
    required this.title,
    required this.correct,
  });

  factory Choice.fromJson(Map<String, dynamic> json) {
    return Choice(
      choiceId: json['choice_id'],
      exerciseId: json['exercise_id'],
      title: json['title'],
      correct: json['correct'],
    );
  }
}
