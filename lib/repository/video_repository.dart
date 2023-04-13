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
}
