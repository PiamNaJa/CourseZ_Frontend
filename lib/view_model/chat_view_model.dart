import 'package:coursez/controllers/auth_controller.dart';
import 'package:coursez/controllers/inboxcontroller.dart';
import 'package:coursez/model/chat.dart';
import 'package:coursez/repository/chat_repository.dart';
import 'package:coursez/utils/color.dart';
import 'package:coursez/utils/fetchData.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatViewModel {
  final chatRepo = ChatRepository();
  Future<List<Inbox>> getInbox() async {
    if (Get.find<AuthController>().isLogin) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String token = prefs.getString('token')!;
      final res = await fecthData('inbox', authorization: token);
      final inb = res.map((e) => Inbox.fromJson(e)).toList();
      List<Inbox> inbox = List.from(inb);
      return inbox;
    } else {
      return <Inbox>[];
    }
  }

  Future<ChatRoom> getChat(String chatId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token')!;
    final res = await fecthData('inbox/$chatId', authorization: token);
    return ChatRoom.fromJson(res);
  }

  Future<void> sendMessage(String message, String chatId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token')!;
    final res = await chatRepo.sendMessage(message, chatId, token);
    if (res.statusCode != 201) {
      debugPrint(res.body);
      Get.snackbar("Error", "กรุณาลองใหม่อีกครั้ง",
          colorText: whiteColor,
          backgroundColor: Colors.red,
          snackPosition: SnackPosition.TOP);
    } else {
      Get.find<InboxController>().fetchInbox();
    }
  }

  Future<void> newInbox(int user2ID) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token')!;
    final res = await chatRepo.newInbox(user2ID, token);
    if (res.statusCode != 201) {
      debugPrint(res.body);
      Get.back();
      Get.snackbar("Error", "กรุณาลองใหม่อีกครั้ง",
          colorText: whiteColor,
          backgroundColor: Colors.red,
          snackPosition: SnackPosition.TOP);
    }
  }
}
