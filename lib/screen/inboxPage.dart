import 'package:coursez/controllers/auth_controller.dart';
import 'package:coursez/controllers/inboxcontroller.dart';
import 'package:coursez/model/chat.dart';
import 'package:coursez/utils/color.dart';
import 'package:coursez/widgets/button/button.dart';
import 'package:coursez/widgets/text/heading1_24px.dart';
import 'package:coursez/widgets/text/heading2_20px.dart';
import 'package:coursez/widgets/text/title16px.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InboxPage extends StatelessWidget {
  InboxPage({super.key});
  final authController = Get.find<AuthController>();
  @override
  Widget build(BuildContext context) {
    // final ChatViewModel chatViewModel = ChatViewModel();
    // return Bt(text: "New Inbox", color: primaryColor, onPressed: () {
    //   chatViewModel.newInbox(9);
    // });
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        title: const Heading24px(text: "กล่องข้อความ"),
        backgroundColor: whiteColor,
      ),
      body: Obx(
        () {
          if (authController.isLogin) {
            final inbox = Get.find<InboxController>();
            inbox.fetchInbox();
            return StreamBuilder(
                stream: inbox.inboxStream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final List<Inbox> data = snapshot.data!;
                    if (data.isEmpty) {
                      return const Center(
                          child: Heading24px(text: "คุณยังไม่มีการสนทนา"));
                    }
                    return ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        return inboxList(data[index]);
                      },
                    );
                  } else if (snapshot.hasError) {
                    return const Center(
                        child: Heading20px(
                      text: "เกิดข้อผิดพลาด",
                      color: Colors.red,
                    ));
                  } else {
                    return const Center(
                        child: CircularProgressIndicator(
                      color: primaryColor,
                    ));
                  }
                });
          }
          return notLoginUI();
        },
      ),
    );
  }

  Widget inboxList(Inbox data) {
    final bool isUrl = GetUtils.isURL(data.lastMessage);
    final bool isMeUser1 = authController.userid == data.user1.userId;
    return InkWell(
      onTap: () {
        Get.toNamed('/chat/${data.inboxId}',
            arguments: isMeUser1 ? data.user2 : data.user1);
      },
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage:
              NetworkImage(isMeUser1 ? data.user2.picture : data.user1.picture),
        ),
        title: Title16px(
            text: isMeUser1 ? data.user2.nickName : data.user1.nickName),
        subtitle: Text(data.lastMessageUserId == authController.userid
            ? isUrl
                ? "คุณ : ได้ส่งรูปภาพ"
                : "คุณ : ${data.lastMessage}"
            : isUrl
                ? "ได้ส่งรูปภาพ"
                : data.lastMessage),
      ),
    );
  }

  Widget notLoginUI() {
    return Center(
      child: Column(
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
      ),
    );
  }
}
