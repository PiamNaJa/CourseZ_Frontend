import 'dart:convert';
import 'dart:io';

import 'package:coursez/utils/network.dart';
import 'package:http/http.dart' as http;

class HistoryRepository {
  Future<http.Response> addVideoHistory(String videoId, int duration, String token) async {
    try {
      const url = '${Network.baseUrl}/api/history/';
      Map data = {'duration': duration, 'video_id': int.parse(videoId)};
      var response = await http.post(Uri.parse(url),
          headers: {"Content-Type": "application/json", "Authorization": token},
          body: json.encode(data));
      return response;
    } on SocketException {
      throw Exception('No Internet Connection');
    }
  }
}
