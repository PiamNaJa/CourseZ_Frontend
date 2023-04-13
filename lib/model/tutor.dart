class Tutor {
  int? classLevel;
  String fullname;
  String nickname;
  String picture;
  double rating;
  int teacherId;
  int userId;

  Tutor(
      {required this.classLevel,
      required this.fullname,
      required this.nickname,
      required this.picture,
      required this.rating,
      required this.teacherId,
      required this.userId});
  factory Tutor.fromJson(Map<String, dynamic> json) {
    return Tutor(
        classLevel: json['class_level'],
        fullname: json['fullname'],
        nickname: json['nickname'],
        picture: json['picture'],
        rating: json['rating'].toDouble(),
        teacherId: json['teacher_id'],
        userId: json['user_id']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['class_level'] = classLevel;
    data['fullname'] = fullname;
    data['nickname'] = nickname;
    data['picture'] = picture;
    data['rating'] = rating;
    data['teacher_id'] = teacherId;
    data['user_id'] = userId;
    return data;
  }
}
