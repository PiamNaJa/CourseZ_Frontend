import 'dart:ffi';
import 'user.dart';

class Comment {
  final int commentId;
  final int postId;
  final int userId;
  final User? user;
  final String description;
  final int createdAt;

  Comment({
    required this.commentId,
    required this.postId,
    required this.userId,
    this.user,
    required this.description,
    required this.createdAt,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      commentId: json['comment_id'],
      postId: json['post_id'],
      userId: json['user_id'],
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      description: json['description'],
      createdAt: json['created_at'],
    );
  }
}
