import 'user.dart';
import 'subject.dart';
import 'comment.dart';

class Post {
  final int postId;
  final int subjectId;
  final Subject? subject;
  final int userid;
  final User? user;
  final String caption;
  late final String postPicture;
  final List<Comment> comments;
  final int createdAt;

  Post(
      {required this.postId,
      required this.subjectId,
      this.subject,
      required this.userid,
      this.user,
      required this.caption,
      required this.postPicture,
      required this.comments,
      required this.createdAt});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      postId: json['post_id'],
      subjectId: json['subject_id'],
      subject:
          json['subject'] != null ? Subject.fromJson(json['subject']) : null,
      userid: json['user_id'],
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      caption: json['caption'],
      postPicture: json['post_picture'],
      comments: json['comments'] != null
          ? List.from(json['comments'].map((c) => Comment.fromJson(c)).toList())
          : List.empty(),
      createdAt: json['created_at'],
    );
  }
}
