import 'dart:convert';
import 'dart:io';

import 'package:coursez/model/video.dart';
import 'package:coursez/utils/network.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class VideoRepository {
  Future deleteVideo(String courseId, String videoId, String token) async {
    final url = '${Network.baseUrl}/api/course/$courseId/video/$videoId/';
    final response = await http.delete(Uri.parse(url),
        headers: {"Content-Type": "application/json", "Authorization": token});
    if (response.statusCode == 204) {
      return true;
    }
    debugPrint(response.body);
    return false;
  }

  Future createVideo(int courseId, List<Video> videos, String token) async {
    final url = '${Network.baseUrl}/api/course/$courseId/video';
    for (int i = 0; i < videos.length; i++) {
      final Map data = {
        "video_name": videos[i].videoName,
        "description": videos[i].description,
        "picture": videos[i].picture,
        "price": videos[i].price,
        "url": videos[i].url,
        "sheet": videos[i].sheet,
      };
      final response = await http.post(Uri.parse(url),
          headers: {"Content-Type": "application/json", "Authorization": token},
          body: json.encode(data));
      if (response.statusCode != 201) {
        debugPrint(response.body);
        return false;
      }
    }
    return true;
  }

  Future updateVideo(
      Video video,
      String token) async {
    final url = '${Network.baseUrl}/api/course/${video.courseId}/video/${video.videoId}/';
    final Map data = {
      "video_name": video.videoName,
      "description": video.description,
      "picture": video.picture,
      "price": video.price,
      "url": video.url,
      "sheet": video.sheet,
    };
    final response = await http.put(Uri.parse(url),
        headers: {"Content-Type": "application/json", "Authorization": token},
        body: json.encode(data));

    if(response.statusCode == 200){
      return true;
    }
    debugPrint(response.body);
    return false;
  }
}
