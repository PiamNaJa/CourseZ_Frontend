import 'dart:ffi';
import 'user.dart';

class Comment {
  final Int32 commentId;
  final Int32 postId;
  final Int32 userId;
  final User? user;
  final String description;

  Comment({
    required this.commentId,
    required this.postId,
    required this.userId,
    this.user,
    required this.description,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      commentId: json['comment_id'],
      postId: json['post_id'],
      userId: json['user_id'],
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      description: json['description'],
    );
  }
}
