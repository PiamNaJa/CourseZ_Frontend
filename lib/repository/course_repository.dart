import 'package:coursez/utils/network.dart';
import 'package:http/http.dart' as http;

class CourseRepository {
  Future<bool> likeOrUnlikeCourse(String courseId, String token) async {
    final url = '${Network.baseUrl}/api/course/$courseId/like';
    final res = await http.patch(Uri.parse(url), headers: {
      "Authorization": token,
    });
    if (res.statusCode == 200) {
      return true;
    }
    return false;
  }
}
