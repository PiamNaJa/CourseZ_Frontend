import 'package:coursez/model/post.dart';
import 'package:coursez/repository/post_repository.dart';
import 'package:coursez/utils/color.dart';
import 'package:coursez/utils/fetchData.dart';
import 'package:coursez/view_model/date_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PostViewModel {
  final PostRepository _postRepository = PostRepository();
  Future<List<Post>> loadPost(int subjectId) async {
    final p = await fecthData('post');
    final List<Post> post = List.from(p.map((e) => Post.fromJson(e)).toList());
    if (subjectId == 0) {
      return post;
    } else {
      return post.where((element) => element.subjectId == subjectId).toList();
    }
  }

  Future<Post> loadPostById(String postid) async {
    final p = await fecthData('post/$postid');
    final post = Post.fromJson((p));
    return post;
  }

  String formatPostDate(int createdAt) {
    DateViewModel dateViewModel = DateViewModel();
    String timeago = dateViewModel.formatDate(createdAt);
    timeago = timeago.replaceAll(' ago', '');

    return timeago;
  }

  String formatLevel(int level) {
    String levelName = '';
    if (level == 1) {
      levelName = 'มัธยมศึกษาปีที่ 1';
    } else if (level == 2) {
      levelName = 'มัธยมศึกษาปีที่ 2';
    } else if (level == 3) {
      levelName = 'มัธยมศึกษาปีที่ 3';
    } else if (level == 4) {
      levelName = 'มัธยมศึกษาปีที่ 4';
    } else if (level == 5) {
      levelName = 'มัธยมศึกษาปีที่ 5';
    } else if (level == 6) {
      levelName = 'มัธยมศึกษาปีที่ 6';
    } else if (level == 7) {
      levelName = 'มหาวิทยาลัย';
    }
    return levelName;
  }

  Future<void> addComment(String postId, String comment) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token')!;
    final bool isPass =
        await _postRepository.addComment(postId, comment, token);

    if (!isPass) {
      Get.snackbar('ผิดพลาด', 'มีบางอย่างผิดพลาด',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: whiteColor);
    }
  }

  Future<void> deletePost(String postId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token')!;
    final bool isPass = await _postRepository.deletePost(postId, token);

    if (!isPass) {
      Get.snackbar('ผิดพลาด', 'มีบางอย่างผิดพลาด',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: whiteColor);
    }
  }
}
