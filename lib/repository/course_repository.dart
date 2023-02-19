import 'package:http/http.dart' as http;

class CourseRepository {
  Future<bool> likeOrUnlikeCourse(String courseId, String token) async {
    final url = 'http://10.0.2.2:5000/api/course/$courseId/like';
    final res = await http.patch(Uri.parse(url), headers: {
      "Authorization": token,
    });
    if (res.statusCode == 200) {
      return true;
    }
    return false;
  }
}
