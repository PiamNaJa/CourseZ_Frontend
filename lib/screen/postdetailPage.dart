import 'package:coursez/controllers/auth_controller.dart';
import 'package:coursez/model/post.dart';
import 'package:coursez/utils/color.dart';
import 'package:coursez/view_model/post_view_model.dart';
import 'package:coursez/widgets/appbar/app_bar.dart';
import 'package:coursez/widgets/text/heading2_20px.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';

class PostdetailPage extends StatefulWidget {
  const PostdetailPage({super.key});

  @override
  State<PostdetailPage> createState() => _PostdetailPageState();
}

class _PostdetailPageState extends State<PostdetailPage> {
  AuthController authController = Get.find<AuthController>();
  final String postid = Get.parameters['post_id']!;
  String username = Get.parameters['username']!;
  String userid = Get.parameters['user_id']!;
  String autoFocus = Get.parameters['flag']!;
  PostViewModel postViewModel = PostViewModel();
  late Future<Post> data;

  @override
  void initState() {
    data = postViewModel.loadPostById(int.parse(postid));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Heading20px(text: username),
        backgroundColor: whiteColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: primaryColor),
          onPressed: () {
            Get.back();
          },
        ),
        actions: [
          (authController.userid == int.parse(userid))
              ? IconButton(
                  icon: const Icon(Icons.more_horiz_rounded, color: greyColor),
                  onPressed: () {},
                )
              : Container(),
        ],
      ),
      body: SingleChildScrollView(
        child: FutureBuilder<Post>(
            future: data,
            builder: ((context, snapshot) {
              if (snapshot.hasData) {
                return SizedBox(
                  child: postDetail(snapshot.data!),
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            })),
      ),
    );
  }

  Widget postDetail(Post item) {
    final screenHeight = Get.height;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              item.caption,
              style: const TextStyle(
                fontFamily: 'Athiti',
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(height: 10),
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
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
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
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    autofocus: (autoFocus == '1') ? true : false,
                    decoration: const InputDecoration(
                      focusColor: primaryColor,
                      contentPadding: EdgeInsets.only(left: 10, right: 10),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: greyColor),
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      hintText: 'แสดงความคิดเห็น',
                      hintStyle: TextStyle(
                          fontFamily: 'Athiti', fontSize: 14, color: greyColor),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
