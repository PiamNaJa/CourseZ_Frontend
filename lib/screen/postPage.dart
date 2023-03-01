import 'package:coursez/controllers/level_controller.dart';
import 'package:coursez/controllers/level_controller.dart';
import 'package:coursez/controllers/post_controller.dart';
import 'package:coursez/model/post.dart';
import 'package:coursez/utils/color.dart';
import 'package:coursez/view_model/post_view_model.dart';
import 'package:coursez/widgets/bottomSheet/customBottomSheet.dart';
import 'package:coursez/widgets/button/textbutton.dart';
import 'package:coursez/widgets/listView/listViewPost.dart';
import 'package:coursez/widgets/text/body12px.dart';
import 'package:coursez/widgets/text/body16.dart';
import 'package:coursez/widgets/text/expandableText.dart';
import 'package:coursez/widgets/text/title14px.dart';
import 'package:coursez/widgets/text/title16px.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import '../widgets/text/body14px.dart';
import '../widgets/text/heading1_24px.dart';

class PostPage extends StatelessWidget {
  final PostViewModel postViewModel = PostViewModel();
  final CustomBottomSheet customBottomSheet = CustomBottomSheet();
  final AuthController authController = Get.find();
  PostPage({super.key});

  // onComment() {
  //   if (authController.isLogin) {
  //     postViewModel.addComment(postid, myComment);
  //   } else {
  //     Get.snackbar('กรุณาเข้าสู่ระบบ',
  //         'เพื่อใช้งานความสามารถในการแสดงความคิดเห็นได้เต็มที่');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    PostController postController = Get.find<PostController>();
    double screenWidth = Get.width;
    double screenHeight = Get.height;

    return Scaffold(
        backgroundColor: whiteColor.withOpacity(0.95),
        appBar: AppBar(
          elevation: 0,
          toolbarHeight: 90,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(10),
            child: Container(
              height: 1.2,
              color: greyColor,
            ),
          ),
          flexibleSpace: SafeArea(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Heading24px(text: 'Community ถาม - ตอบ'),
                const SizedBox(height: 10),
                InkWell(
                  onTap: () {
                    customBottomSheet.bottomSheetForDropdown();
                  },
                  child: Center(
                    child: Container(
                      width: screenWidth / 1.7,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border.all(color: greyColor),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Obx(() => Body16px(
                                text:
                                    '${postController.subjectLevel} ${postController.subjectTitle}')),
                            const Icon(Icons.arrow_drop_down_rounded)
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          )),
          backgroundColor: whiteColor,
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Column(
              children: [
                newPost(),
                const SizedBox(height: 12),
                Obx(() => PostList(subjectId: postController.subjectid))
              ],
            ),
          ),
        ));
  }

  Widget newPost() {
    AuthController authController = Get.find<AuthController>();
    final formKey = GlobalKey<FormState>();
    return Container(
      decoration: BoxDecoration(
        color: whiteColor,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 0,
            blurRadius: 5,
            offset: const Offset(0, 5), // changes position of shadow
          ),
        ],
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          ListTile(
            leading: ClipOval(
              child: authController.isLogin
                  ? Image.network(
                      authController.picture,
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      width: 40,
                      height: 40,
                      color: greyColor,
                    ),
            ),
            title: authController.isLogin
                ? Title14px(text: authController.username)
                : const Title14px(text: 'ผู้เข้าชม'),
            subtitle: authController.isLogin
                ? authController.role == 'Teacher' ||
                        authController.role == 'Tutor'
                    ? const Body14px(text: 'คุณครู')
                    : const Body14px(text: 'นักเรียน')
                : const Body14px(text: 'ผู้เข้าชม'),
          ),
          Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.image),
                color: primaryColor,
              ),
              Form(
                  key: formKey,
                  child: Flexible(
                    child: TextFormField(
                      enabled: authController.isLogin,
                      decoration: InputDecoration(
                        hintText: authController.isLogin
                            ? 'เขียนโพสต์'
                            : 'กรุณาเข้าสู่ระบบเพื่อเขียนโพสต์',
                        border: InputBorder.none,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                  )),
              IconButton(
                  onPressed: () {
                    // if (_formKey.currentState!.validate()) {
                    //   ScaffoldMessenger.of(context)
                    //       .showSnackBar(const SnackBar(content: Text('Pass')));
                    // }
                  },
                  icon: const Icon(Icons.send),
                  color: primaryColor),
            ],
          )
        ],
      ),
    );
  }
}
