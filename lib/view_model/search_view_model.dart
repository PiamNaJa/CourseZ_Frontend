import 'dart:convert';
import '../model/course.dart';
import '../model/search.dart';
import '../model/tutor.dart';
import 'package:http/http.dart' as http;

class SearchViewModel {
  Future<Search> searchAll(String searchText) async {
    Uri uri = Uri.http('10.0.2.2:5000', '/api/search', {'name': searchText});
    http.Response response = await http.get(uri);
    final searchAll = jsonDecode(utf8.decode(response.bodyBytes));
    final result = Search.fromJson(searchAll);
    return result;
  }

  Future<List<Course>> searchCourse(String searchText) async {
    Uri uri =
        Uri.http('10.0.2.2:5000', '/api/search/course', {'name': searchText});
    http.Response response = await http.get(uri);
    final searchCourse = jsonDecode(utf8.decode(response.bodyBytes));
    final List<Course> courses =
        List.from(searchCourse.map((e) => Course.fromJson(e)));
    return courses;
  }

  Future<List<Tutor>> searchTutor(String searchText) async {
    Uri uri =
        Uri.http('10.0.2.2:5000', '/api/search/tutor', {'name': searchText});
    http.Response response = await http.get(uri);
    final searchTutor = jsonDecode(utf8.decode(response.bodyBytes));
    final List<Tutor> tutor =
        List.from(searchTutor.map((e) => Tutor.fromJson(e)));
    return tutor;
  }

  Future<List<Course>> searchVideo(String searchText) async {
    Uri uri =
        Uri.http('10.0.2.2:5000', '/api/search/video', {'name': searchText});
    http.Response response = await http.get(uri);
    final searchVideo = jsonDecode(utf8.decode(response.bodyBytes));
    final List<Course> video =
        List.from(searchVideo.map((e) => Course.fromJson(e)));
    return video;
  }
}
