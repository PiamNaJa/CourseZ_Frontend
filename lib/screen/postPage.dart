import 'package:coursez/model/post.dart';
import 'package:coursez/utils/color.dart';
import 'package:coursez/view_model/post_view_model.dart';
import 'package:coursez/widgets/text/title14px.dart';
import 'package:coursez/widgets/text/title16px.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import '../widgets/text/body14px.dart';
import '../widgets/text/heading1_24px.dart';

class PostPage extends StatelessWidget {
  const PostPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(AuthController());
    PostViewModel postViewModel = PostViewModel();
    final List<String> classLevel = [
      'ระดับชั้นทั้งหมด',
      'ม.1',
      'ม.2',
      'ม.3',
      'ม.4',
      'ม.5',
      'ม.6',
      'มหาวิทยาลัย'
    ];

    final List<String> subjectLevel = [
      'วิชาทั้งหมด',
      'คณิตศาสตร์',
      'ภาษาไทย',
      'ภาษาอังกฤษ',
      'วิทยาศาสตร์',
    ];
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        height: 35,
                        decoration: BoxDecoration(
                          border: Border.all(color: greyColor),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: ButtonTheme(
                          alignedDropdown: true,
                          child: DropdownButton(
                            alignment: Alignment.center,
                            borderRadius: BorderRadius.circular(25),
                            underline: Container(),
                            value: classLevel[0],
                            onChanged: (value) {},
                            items: classLevel
                                .map<DropdownMenuItem<String>>((item) {
                              return DropdownMenuItem<String>(
                                value: item,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 5),
                                  child: Body14px(text: item),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 30),
                    Expanded(
                      flex: 1,
                      child: Container(
                        height: 35,
                        decoration: BoxDecoration(
                            border: Border.all(color: greyColor),
                            borderRadius: BorderRadius.circular(25)),
                        child: ButtonTheme(
                          alignedDropdown: true,
                          child: DropdownButton(
                            borderRadius: BorderRadius.circular(25),
                            underline: Container(),
                            alignment: Alignment.center,
                            value: subjectLevel[0],
                            onChanged: (value) {},
                            items: subjectLevel
                                .map<DropdownMenuItem<String>>((item) {
                              return DropdownMenuItem<String>(
                                value: item,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 5),
                                  child: Body14px(text: item),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                  ],
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
                FutureBuilder(
                  future: postViewModel.loadPost(0, 0),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return postList(snapshot.data![index]);
                        },
                      );
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                )
              ],
            ),
          ),
        ));
  }

  Widget postList(Post item) {
    final authController = Get.find<AuthController>();
    final screenHeight = Get.height;
    return InkWell(
      onTap: () {
        Get.toNamed('/post/${item.postId.toString()}', parameters: {
          "username": item.user!.nickName,
          "user_id": item.user!.userId.toString(),
          "flag": "0"
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 17),
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(
              color: greyColor,
              width: 1,
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              contentPadding: const EdgeInsets.all(0),
              leading: ClipOval(
                child: Image.network(
                  item.user!.picture,
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                ),
              ),
              title: Title16px(text: item.user!.fullName),
              trailing: authController.userid == item.user!.userId
                  ? const Icon(Icons.more_horiz_outlined)
                  : const SizedBox(),
            ),
            ExpandableText(
              expandText: 'ดูเพิ่มเติม',
              collapseText: 'ดูน้อยลง',
              item.caption,
              maxLines: 3,
              linkColor: primaryColor,
              style: const TextStyle(fontFamily: 'Athiti', fontSize: 14),
            ),
            const SizedBox(
              height: 12,
            ),
            item.postPicture.isNotEmpty
                ? InkWell(
                    child: ClipRect(
                      child: Image.network(
                        item.postPicture,
                        width: double.infinity,
                        height: screenHeight * 0.4,
                        fit: BoxFit.cover,
                      ),
                    ),
                    onTap: () {
                      showDialog(
                          context: Get.context!,
                          builder: (_) {
                            return Dialog(
                                insetPadding: const EdgeInsets.all(30),
                                backgroundColor: Colors.transparent,
                                child: InteractiveViewer(
                                  minScale: 0.8,
                                  maxScale: 2,
                                  child: Image.network(
                                    item.postPicture,
                                    fit: BoxFit.cover,
                                  ),
                                ));
                          });
                    },
                  )
                : const SizedBox(),
            const SizedBox(
              height: 12,
            ),
            Row(
              children: [
                ClipOval(
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
                Expanded(
                  child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: InkWell(
                        onTap: () {
                          Get.toNamed('/post/${item.postId.toString()}',
                              parameters: {
                                "username": item.user!.nickName,
                                "user_id": item.user!.userId.toString(),
                                "flag": "1"
                              });
                        },
                        child: Container(
                          alignment: Alignment.centerLeft,
                          height: 45,
                          decoration: BoxDecoration(
                              color: whiteColor,
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(color: greyColor)),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Body14px(
                              text: 'แสดงความคิดเห็น',
                              color: greyColor,
                            ),
                          ),
                        ),
                      )),
                ),
              ],
            ),
          ],
        ),
      ),
    );
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
