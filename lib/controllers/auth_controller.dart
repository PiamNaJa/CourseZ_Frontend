import 'dart:convert';

import 'package:http/http.dart' as http;

class AuthController {
  Future loginUser(String email, String password) async {
    const url = 'http://10.0.2.2:5000/api/user/login';
    Map data = {'email': email, 'password': password};

    var response = await http.post(Uri.parse(url), headers: {"Content-Type": "application/json"}, body: json.encode(data));

    if (response.statusCode == 200) {
      var loginArr = json.decode(response.body);
      print(loginArr);
    } else {
      print('Login Error');
      print(response.body);
    }
  }
}
