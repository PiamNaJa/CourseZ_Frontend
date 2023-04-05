import 'dart:convert';
import 'dart:io';

import 'package:coursez/controllers/auth_controller.dart';
import 'package:coursez/controllers/inboxcontroller.dart';
import 'package:coursez/model/chat.dart';
import 'package:coursez/model/user.dart';
import 'package:coursez/utils/color.dart';
import 'package:coursez/utils/network.dart';
import 'package:coursez/view_model/chat_view_model.dart';
import 'package:coursez/widgets/text/heading1_24px.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:chat_bubbles/chat_bubbles.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final User user = Get.arguments;
  final chatRoomId = Get.parameters['chatroom_id']!;
  late WebSocketChannel socket;
  List<Conversations> data = List.empty(growable: true);
  final TextEditingController controller = TextEditingController();
  final AuthController authController = Get.find<AuthController>();
  final ScrollController scrollController = ScrollController();
  final FocusNode _focus = FocusNode();
  final ChatViewModel _chatViewModel = ChatViewModel();
  final InboxController inbox = Get.find<InboxController>();
  String text = '';
  List<File> images = [];
  ImagePicker picker = ImagePicker();
  bool isLoading = false;
  @override
  void initState() {
    _chatViewModel.getChat(chatRoomId).then((value) => setState(() {
          data = value.conversations;
        }));
    socket = WebSocketChannel.connect(
        Uri.parse('ws://${Network.url}/ws/$chatRoomId'));
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
      controller.addListener(() {
        setState(() {
          text = controller.text;
        });
      });
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

  void getImages(bool isPickCamera) async {
    Permission permission;
    if (isPickCamera) {
      permission = Permission.camera;
    } else {
      permission = Permission.storage;
    }
    if (await permission.isDenied) {
      await permission.request();
    }
    if (isPickCamera) {
      final im =
          await picker.pickImage(source: ImageSource.camera, imageQuality: 90);
      if (im != null) {
        images.add(File(im.path));
      }
    } else {
      final im = await picker.pickMultiImage(imageQuality: 90);
      for (var i in im) {
        images.add(File(i.path));
      }
    }
    setState(() {});
  }

  void sendMessage(String message) {
    _chatViewModel.sendMessage(message, chatRoomId);
    socket.sink.add(json.encode({
      "chatroom_id": int.parse(chatRoomId),
      "sender_id": authController.userid,
      "message": message.trim(),
    }));
    controller.clear();
  }

  void sendImage() async {
    setState(() {
      isLoading = true;
    });
    final res = FirebaseStorage.instance
        .ref()
        .child('chat_images/$chatRoomId/${DateTime.now()}');
    for (var i in images) {
      await res.putFile(i);
      final url = await res.getDownloadURL();
      _chatViewModel.sendMessage(url, chatRoomId);
      socket.sink.add(json.encode({
        "chatroom_id": int.parse(chatRoomId),
        "sender_id": authController.userid,
        "message": url.trim(),
      }));
    }
    setState(() {
      isLoading = false;
      images.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        titleSpacing: 0,
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(user.picture),
            ),
            const SizedBox(width: 10),
            Heading24px(text: user.nickName),
          ],
        ),
        backgroundColor: whiteColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: primaryColor),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: Column(
        children: [
          chatListView(data),
          if (images.isNotEmpty) imagesListView(),
          chatInput()
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
            final String message = data[index].message.trim();
            final bool isSender = data[index].senderId == authController.userid;
            if (GetUtils.isURL(message)) {
              return BubbleNormalImage(
                id: index.toString(),
                image: Image.network(data[index].message),
                isSender: isSender,
              );
            }
            return BubbleSpecialThree(
              color: data[index].senderId == authController.userid
                  ? primaryColor
                  : const Color.fromARGB(255, 140, 140, 141),
              tail: false,
              isSender: isSender,
              text: message,
              textStyle: const TextStyle(color: whiteColor, fontSize: 16),
            );
          },
        ),
      ),
    );
  }

  Widget imagesListView() {
    return Container(
      height: 120,
      padding: const EdgeInsets.only(top: 5),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(width: 1, color: primaryDarkColor),
        ),
      ),
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: images.length,
          itemBuilder: (context, index) {
            return Stack(
              alignment: AlignmentDirectional.topEnd,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 10, right: 0),
                  child: Image.file(
                    images[index],
                    width: 100,
                    height: 100,
                  ),
                ),
                Positioned(
                    child: SizedBox(
                  width: 32,
                  height: 32,
                  child: CircleAvatar(
                    backgroundColor: greyColor,
                    child: IconButton(
                        color: whiteColor,
                        onPressed: (() {
                          setState(() {
                            images.removeAt(index);
                          });
                        }),
                        icon: const Icon(Icons.close, size: 16)),
                  ),
                ))
              ],
            );
          }),
    );
  }

  Widget chatInput() {
    return Form(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: greyColor),
                    borderRadius: BorderRadius.circular(30)),
                child: Row(
                  children: [
                    IconButton(
                        color: primaryDarkColor,
                        onPressed: () => getImages(true),
                        icon: const Icon(Icons.camera_alt_rounded)),
                    IconButton(
                        constraints: const BoxConstraints(),
                        padding: EdgeInsets.zero,
                        color: primaryDarkColor,
                        onPressed: () => getImages(false),
                        icon: const Icon(
                          Icons.image_rounded,
                        )),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: TextField(
                        focusNode: _focus,
                        controller: controller,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Enter a message',
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                  ],
                ),
              ),
            ),
            if (!isLoading)
              IconButton(
                  color: primaryDarkColor,
                  onPressed: text.isNotEmpty || images.isNotEmpty
                      ? () {
                          if (text.isNotEmpty) {
                            sendMessage(controller.text);
                          }
                          if (images.isNotEmpty) {
                            sendImage();
                          }
                        }
                      : null,
                  icon: const Icon(Icons.send))
            else
              const SizedBox(
                height: 30,
                width: 30,
                child: CircularProgressIndicator(
                  color: primaryColor,
                ),
              )
          ],
        ),
      ),
    );
  }
}
