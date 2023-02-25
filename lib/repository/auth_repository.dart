import 'dart:convert';
import 'dart:io';
import 'package:coursez/model/user.dart';
import 'package:coursez/utils/network.dart';
import 'package:http/http.dart' as http;

class AuthRepository {
  int statusCode = 0;
  Future loginUser(String email, String password) async {
    try {
      const url = '${Network.baseUrl}/api/user/login';
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
  //     String url = '${Network.baseUrl}/api/user/$id';

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

  Future getNewToken(String token) async {
    try {
      const url = '${Network.baseUrl}/api/user/newtoken';
      Map data = {'token': token};
      var response = await http.post(Uri.parse(url),
          headers: {"Content-Type": "application/json"},
          body: json.encode(data));
      print(response.body);
      return response;
    } on SocketException {
      throw Exception('No Internet Connection');
    }
  }

  Future<http.Response> registerStudent(User user) async {
    try {
      const url = '${Network.baseUrl}/api/user/register/student';
      var response = await http.post(Uri.parse(url),
          headers: {"Content-Type": "application/json"},
          body: json.encode(user.toJson()));
      return response;
    } on SocketException {
      throw Exception('No Internet Connection');
    }
  }

  Future<http.Response> registerTeacher(User user) async {
    try {
      final data = user.toJson();
      if (user.userTeacher!.experiences == null) {
        user.userTeacher!.experiences = [];
      }
      if (user.role == 'teacher' || user.role == 'Teacher') {
        data['teacher_license'] = user.userTeacher!.teacherLicense;
        data['transcript'] = user.userTeacher!.transcipt;
      } else {
        data['psychological_test'] = user.userTeacher!.psychologicalTest;
      }
      data['id_card'] = user.userTeacher!.idCard;
      data['experience'] = [];
      for (var i = 0; i < user.userTeacher!.experiences!.length; i++) {
        data['experience'].add(user.userTeacher!.experiences![i].toJson());
      }
      const url = '${Network.baseUrl}/api/user/register/teacher';
      var response = await http.post(Uri.parse(url),
          headers: {"Content-Type": "application/json"},
          body: json.encode(data));
      return response;
    } on SocketException {
      throw Exception('No Internet Connection');
    }
  }
}
