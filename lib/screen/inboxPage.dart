import 'package:coursez/controllers/auth_controller.dart';
import 'package:coursez/controllers/inboxcontroller.dart';
import 'package:coursez/model/chat.dart';
import 'package:coursez/utils/color.dart';
import 'package:coursez/widgets/button/button.dart';
import 'package:coursez/widgets/text/heading1_30px.dart';
import 'package:coursez/widgets/text/heading2_20px.dart';
import 'package:coursez/widgets/text/title16px.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InboxPage extends StatelessWidget {
  InboxPage({super.key});
  final authController = Get.find<AuthController>();
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (authController.isLogin) {
        final inbox = Get.find<InboxController>();
        inbox.fetchInbox();
        if (inbox.inbox.isNotEmpty) {
          return ListView.builder(
              itemCount: inbox.inbox.length,
              itemBuilder: (context, index) {
                return inboxList(inbox.inbox[index]);
              });
        } else {
          return const Center(child: Heading20px(text: "คุณยังไม่มีการสนทนา"));
        }
      }
      return notLoginUI();
    });
  }

  Widget inboxList(Inbox data) {
    return InkWell(
      onTap: () {
        Get.toNamed('/chat/${data.inboxId}');
      },
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(data.user1.picture),
        ),
        title: Title16px(text: data.user1.nickName),
        subtitle: Text(data.lastMessageUserId == authController.userid
            ? "คุณ : ${data.lastMessage}"
            : data.lastMessage),
      ),
    );
  }

  Widget notLoginUI() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text("กรุณาเข้าสู่ระบบเพื่อดูรายละเอียดหน้าแชท"),
        const SizedBox(
          height: 15,
        ),
        Bt(
          onPressed: () {
            Get.toNamed('/login');
          },
          text: "ลงทะเบียน / เข้าสู่ระบบ",
          color: primaryColor,
        )
      ],
    );
  }
}
