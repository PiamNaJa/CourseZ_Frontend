import 'dart:convert';

import 'package:coursez/utils/network.dart';
import 'package:http/http.dart' as http;

class PostRepository {
  Future<bool> addComment(String postId, String comment, String token) async {
    final url = '${Network.baseUrl}/api/post/$postId/comment';
    final Map<String, String> data = {
      "description": comment,
    };
    final res = await http.post(Uri.parse(url),
        headers: {"Authorization": token, "Content-Type": "application/json"},
        body: json.encode(data));
    if (res.statusCode == 201) {
      return true;
    }
    return false;
  }

  Future<bool> deletePost(String postId, String token) async {
    final url = '${Network.baseUrl}/api/post/$postId';
    final res = await http.delete(Uri.parse(url),
        headers: {"Authorization": token, "Content-Type": "application/json"});
    if (res.statusCode == 204) {
      return true;
    }
    return false;
  }

  Future<bool> createPost(String caption, String imageurl, String subjectTitle,
      int classLevel, String token) async {
    const url = '${Network.baseUrl}/api/post/';
    final Map<String, dynamic> data = {
      "caption": caption,
      "subject_title": subjectTitle,
      "class_level": classLevel,
    };
    if (url.isNotEmpty) {
      data["post_picture"] = imageurl;
    }
    final res = await http.post(Uri.parse(url),
        headers: {"Authorization": token, "Content-Type": "application/json"},
        body: json.encode(data));
    if (res.statusCode == 201) {
      return true;
    }
    return false;
  }

  Future<bool> updatePost(String caption, String imageurl, String postId, String token)async{
    final  url = '${Network.baseUrl}/api/post/$postId';
    final Map<String, dynamic> data = {
      "caption": caption,
      'post_picture' : imageurl
    };
    final res = await http.put(Uri.parse(url),
        headers: {"Authorization": token, "Content-Type": "application/json"},
        body: json.encode(data));
    if (res.statusCode == 200) {
      return true;
    }
    return false;
  }
}
