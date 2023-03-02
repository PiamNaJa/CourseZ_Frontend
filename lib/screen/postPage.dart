import 'dart:io';
import 'package:coursez/controllers/post_controller.dart';
import 'package:coursez/model/post.dart';
import 'package:coursez/utils/color.dart';
import 'package:coursez/utils/pickImage.dart';
import 'package:coursez/view_model/post_view_model.dart';
import 'package:coursez/widgets/alert/alert.dart';
import 'package:coursez/widgets/bottomSheet/dropdownBottomSheet.dart';
import 'package:coursez/widgets/listView/listViewPost.dart';
import 'package:coursez/widgets/text/body16.dart';
import 'package:coursez/widgets/text/title14px.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../controllers/auth_controller.dart';
import '../widgets/text/body14px.dart';
import '../widgets/text/heading1_24px.dart';

class PostPage extends StatefulWidget {
  const PostPage({super.key});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  final PostViewModel postViewModel = PostViewModel();
  final AuthController authController = Get.find();
  File? image;
  final TextEditingController textcontroller = TextEditingController();

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);

      if (image == null) return;

      final imageTemp = File(image.path);
      setState(() => this.image = imageTemp);
    } on PlatformException catch (e) {
      debugPrint("Fail to pick image : $e");
    }
  }

  onSubmit() {
    postViewModel.createPost(textcontroller.text.trim(), image);
    setState(() {
      image = null;
      textcontroller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    PostController postController = Get.find<PostController>();
    double screenWidth = Get.width;
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
                Center(
                  child: postSubjectDropdown(screenWidth / 1.7),
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
                newPost(context),
                const SizedBox(height: 12),
                Obx(() => PostList(subjectId: postController.subjectid))
              ],
            ),
          ),
        ));
  }

  Widget postSubjectDropdown(double width) {
    PostController postController = Get.find<PostController>();
    return InkWell(
      onTap: () {
        showModalBottomSheet(
            context: Get.context!,
            builder: (context) {
              return const BottomSheetForDropdown();
            });
      },
      child: Container(
        width: width,
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
                      '${postController.classLevelName} ${postController.subjectTitle}')),
              const Icon(Icons.arrow_drop_down_rounded)
            ],
          ),
        ),
      ),
    );
  }

  Widget newPost(BuildContext context) {
    AuthController authController = Get.find<AuthController>();
    PostController postController = Get.find<PostController>();
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
          Center(
            child: image != null
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: InkWell(
                      child: Image.file(
                        image!,
                        width: double.infinity,
                        height: 120,
                        fit: BoxFit.cover,
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
                                    child: Image.file(
                                      image!,
                                      fit: BoxFit.cover,
                                    ),
                                  ));
                            });
                      },
                    ),
                  )
                : Container(),
          ),
          Form(
            key: formKey,
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    if (authController.isLogin) {
                      PickImage.pickImage().then((imageTemp) {
                        setState(() => image = imageTemp);
                      });
                    } else {
                      showDialog(
                          context: context,
                          builder: (_) {
                            return const AlertLogin(
                              body: 'กรุณาเข้าสู่ระบบเพื่อเขียนโพสต์',
                              action: 'เข้าสู่ระบบ',
                            );
                          });
                    }
                  },
                  icon: const Icon(Icons.image),
                  color: primaryColor,
                ),
                Flexible(
                  child: TextFormField(
                    controller: textcontroller,
                    enabled: authController.isLogin,
                    decoration: InputDecoration(
                      hintText: authController.isLogin
                          ? 'เขียนโพสต์'
                          : 'กรุณาเข้าสู่ระบบเพื่อเขียนโพสต์',
                      border: InputBorder.none,
                    ),
                    onTap: () {
                      if (!authController.isLogin) {
                        showDialog(
                            context: context,
                            builder: (_) {
                              return const AlertLogin(
                                body: 'กรุณาเข้าสู่ระบบเพื่อเขียนโพสต์',
                                action: 'เข้าสู่ระบบ',
                              );
                            });
                      }
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'โปรดกรอกข้อความ';
                      }
                      return null;
                    },
                  ),
                ),
                IconButton(
                    onPressed: () {
                      if (postController.classLevel != 0) {
                        if (formKey.currentState!.validate()) {
                          onSubmit();
                        }
                      } else {
                        Get.snackbar(
                            'กรุณาเลือกวิชา', 'กรุณาเลือกวิชาที่ต้องการโพสต์',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.red,
                            colorText: whiteColor);
                      }
                    },
                    icon: const Icon(Icons.send),
                    color: primaryColor),
              ],
            ),
          )
        ],
      ),
    );
  }
}
