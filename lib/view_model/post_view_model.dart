import 'dart:io';

import 'package:coursez/controllers/post_controller.dart';
import 'package:coursez/model/post.dart';
import 'package:coursez/repository/post_repository.dart';
import 'package:coursez/utils/color.dart';
import 'package:coursez/utils/fetchData.dart';
import 'package:coursez/view_model/date_view_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PostViewModel {
  final PostRepository _postRepository = PostRepository();
  Future<List<Post>> loadPost(int subjectId) async {
    final p = await fecthData('post');
    final List<Post> post = List.from(p.map((e) => Post.fromJson(e)).toList());
    post.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    for (var i = 0; i < post.length; i++) {
      post[i].comments.sort((a, b) => b.commentId.compareTo(a.commentId));
    }
    if (subjectId == 0) {
      return post;
    } else {
      return post.where((element) => element.subjectId == subjectId).toList();
    }
  }

  Future<Post> loadPostById(String postid) async {
    final p = await fecthData('post/$postid');
    final post = Post.fromJson((p));
    post.comments.sort((a, b) => b.commentId.compareTo(a.commentId));
    return post;
  }

  Future<List<Post>> loadPostByUser() async {
    final pref = await SharedPreferences.getInstance();
    final token = pref.getString('token')!;
    final p = await fecthData('post/user', authorization: token);
    final List<Post> posts = List.from(p.map((e) => Post.fromJson(e)).toList());
    return posts;
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
    final PostController postController = Get.find<PostController>();
    final bool isPass =
        await _postRepository.addComment(postId, comment, token);

    if (!isPass) {
      Get.snackbar('ผิดพลาด', 'มีบางอย่างผิดพลาด',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: whiteColor);
    }
    postController.fetchPost(postId);
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

  Future<void> createPost(String caption, File? image) async {
    final PostController postController = Get.find<PostController>();
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token')!;
    String url = '';
    if (image != null) {
      final ref =
          FirebaseStorage.instance.ref().child('post/${DateTime.now()}');
      await ref.putFile(image);
      url = await ref.getDownloadURL();
    }

    final bool isPass = await _postRepository.createPost(caption, url,
        postController.subjectTitle, postController.classLevel, token);
    if (!isPass) {
      Get.snackbar('ผิดพลาด', 'มีบางอย่างผิดพลาด',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: whiteColor);
    } else {
      postController.fetchPostList(postController.subjectid);
    }
  }

  Future<void> updatePost(
      String caption, File? image, String oldImage, String postId) async {
    final PostController postController = Get.find<PostController>();
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token')!;
    String url = oldImage;
    if (image != null) {
      final ref =
          FirebaseStorage.instance.ref().child('post/${DateTime.now()}');
      await ref.putFile(image);
      url = await ref.getDownloadURL();
    }

    final bool isPass =
        await _postRepository.updatePost(caption, url, postId, token);
    if (!isPass) {
      Get.snackbar('ผิดพลาด', 'มีบางอย่างผิดพลาด',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: whiteColor);
    } else {
      postController.fetchPostList(postController.subjectid);
      postController.fetchPost(postId);
    }
  }
}
