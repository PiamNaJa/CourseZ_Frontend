import 'dart:convert';

import 'package:http/http.dart' as http;

class ExerciseRepository {
  Future<bool> addPoints(
      String courseId, String videoId, int point, String token) async {
    final url =
        'http://10.0.2.2:5000/api/course/$courseId/video/$videoId/exercise/done';
    final Map<String, int> data = {
      "point": point,
    };
    final res = await http.patch(Uri.parse(url),
        headers: {"Authorization": token, "Content-Type": "application/json"},
        body: json.encode(data));
    if (res.statusCode == 200) {
      return true;
    }
    return false;
  }
}
