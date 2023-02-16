import 'dart:convert';

import 'package:coursez/controllers/auth_controller.dart';
import 'package:coursez/controllers/inboxcontroller.dart';
import 'package:coursez/model/chat.dart';
import 'package:coursez/utils/color.dart';
import 'package:coursez/view_model/chat_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:chat_bubbles/chat_bubbles.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final chatRoomId = Get.parameters['chatroom_id']!;
  late WebSocketChannel socket;
  List<Conversations> data = List.empty(growable: true);
  final TextEditingController controller = TextEditingController();
  final AuthController authController = Get.find<AuthController>();
  final ScrollController scrollController = ScrollController();
  final FocusNode _focus = FocusNode();
  final ChatViewModel _chatViewModel = ChatViewModel();
  final InboxController inbox = Get.find<InboxController>();

  @override
  void initState() {
    _chatViewModel.getChat(chatRoomId).then((value) => setState(() {
          data = value.conversations;
        }));
    socket = WebSocketChannel.connect(
        Uri.parse('ws://10.0.2.2:5000/ws/$chatRoomId'));
    socket.stream.listen((event) {
      final newdata = Conversations.fromJson(json.decode(event));
      setState(() {
        data.add(newdata);
      });
      scrollToend();
      inbox.fetchInbox();
    });
    _focus.addListener(() {
      if (_focus.hasFocus) {
        scrollToend();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    socket.sink.close();
    controller.dispose();
    scrollController.dispose();
    super.dispose();
  }

  void scrollToend() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void sendMessage(int chatroomid, int senderid, String message) {
    _chatViewModel.sendMessage(message, int.parse(chatRoomId));
    socket.sink.add(json.encode({
      "chatroom_id": chatroomid,
      "sender_id": senderid,
      "message": message.trim(),
    }));
    controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
      ),
      body: Column(
        children: [
          chatListView(data),
          Form(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      focusNode: _focus,
                      controller: controller,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter a message',
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (controller.text.isNotEmpty) {
                        sendMessage(1, authController.userid, controller.text);
                      }
                    },
                    child: const Text('Send'),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget chatListView(List<Conversations> data) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: ListView.builder(
          controller: scrollController,
          itemCount: data.length,
          itemBuilder: (context, index) {
            return Obx(() => BubbleSpecialThree(
                  color: data[index].senderId == authController.userid
                      ? primaryColor
                      : greyColor,
                  tail: false,
                  isSender: data[index].senderId == authController.userid,
                  text: data[index].message.trim(),
                  textStyle: const TextStyle(color: whiteColor, fontSize: 16),
                ));
          },
        ),
      ),
    );
  }
}
