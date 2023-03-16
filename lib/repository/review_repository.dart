import 'dart:convert';

import 'package:coursez/utils/network.dart';
import 'package:http/http.dart' as http;

class ReviewRepository {
  Future<bool> createReviewVideo(
      String videoId, double rating, String comment, String token) async {
    final url = '${Network.baseUrl}/api/video/$videoId/review';
    final Map<String, dynamic> data = {
      "rating": rating,
      "comment": comment,
    };
    final res = await http.post(Uri.parse(url),
        headers: {"Authorization": token, "Content-Type": "application/json"},
        body: json.encode(data));
    if (res.statusCode == 201) {
      return true;
    }
    return false;
  }
}
