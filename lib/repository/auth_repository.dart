import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class AuthRepository {
  int statusCode = 0;
  Future loginUser(String email, String password) async {
    try {
      const url = 'http://10.0.2.2:5000/api/user/login';
      Map data = {'email': email, 'password': password};

      var response = await http.post(Uri.parse(url),
          headers: {"Content-Type": "application/json"},
          body: json.encode(data));
      return response;
    } on SocketException {
      throw Exception('No Internet Connection');
    }
  }

  // Future getData(String id) async {
  //   try {
  //     String url = 'http://10.0.2.2:5000/api/user/$id';

  //     var response = await http
  //         .get(Uri.parse(url), headers: {"Content-Type": "application/json"});

  //     if (response.statusCode == 200) {
  //       statusCode = response.statusCode;
  //       var data = json.decode(utf8.decode(response.bodyBytes));
  //       return data;
  //     }
  //   } on SocketException {
  //     throw Exception('No Internet Connection');
  //   }
  // }
}
