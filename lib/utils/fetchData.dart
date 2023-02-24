import 'package:http/http.dart' as http;
import 'dart:convert';

Future<dynamic> fecthData(String route, {String authorization = ''}) async {
  http.Response response = await http.get(
      Uri.parse('https://coursez-backend.onrender.com/api/$route/'),
      headers: {'Authorization': authorization});
  if (response.statusCode == 200) {
    return jsonDecode(utf8.decode(response.bodyBytes));
  } else {
    throw Exception('Failed to load data');
  }
}
