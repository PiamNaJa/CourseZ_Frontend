import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class ChatRepository {
  Future<http.Response> sendMessage(
      String message, String chatId, String token) async {
    try {
      final url = 'http://10.0.2.2:5000/api/inbox/$chatId';
      Map data = {'message': message};
      var response = await http.post(Uri.parse(url),
          headers: {"Content-Type": "application/json", "Authorization": token},
          body: json.encode(data));
      return response;
    } on SocketException {
      throw Exception('No Internet Connection');
    }
  }

  newInbox(int reciverId, String token) async {
    try {
      const url = 'http://10.0.2.2:5000/api/inbox/';
      Map data = {'user2_id': reciverId};
      var response = await http.post(Uri.parse(url),
          headers: {"Content-Type": "application/json", "Authorization": token},
          body: json.encode(data));
      return response;
    } on SocketException {
      throw Exception('No Internet Connection');
    }
  }
}
