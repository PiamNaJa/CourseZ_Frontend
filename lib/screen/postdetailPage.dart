import 'package:coursez/controllers/auth_controller.dart';
import 'package:coursez/controllers/post_controller.dart';
import 'package:coursez/model/comment.dart';
import 'package:coursez/model/post.dart';
import 'package:coursez/repository/post_repository.dart';
import 'package:coursez/utils/color.dart';
import 'package:coursez/view_model/post_view_model.dart';
import 'package:coursez/widgets/bottomSheet/postBottomSheet.dart';
import 'package:coursez/widgets/text/body12px.dart';
import 'package:coursez/widgets/text/expandableText.dart';
import 'package:coursez/widgets/text/heading2_20px.dart';
import 'package:coursez/widgets/text/title14px.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PostdetailPage extends StatefulWidget {
  const PostdetailPage({super.key});

  @override
  State<PostdetailPage> createState() => _PostdetailPageState();
}

class _PostdetailPageState extends State<PostdetailPage> {
  AuthController authController = Get.find<AuthController>();
  PostViewModel postViewModel = PostViewModel();
  PostController postController = Get.find<PostController>();
  TextEditingController textController = TextEditingController();
  final String postid = Get.parameters['post_id']!;
  String username = Get.parameters['username']!;
  String userid = Get.parameters['user_id']!;
  String autoFocus = Get.parameters['flag']!;
  String userPicture = Get.parameters['user_picture']!;
  String postDate = Get.parameters['post_date']!;
  double screenWidth = Get.width;
  String myComment = '';
  final formkey = GlobalKey<FormState>();

  late Future<Post> data;

  @override
  void initState() {
    postController.fetchPost(postid);
    super.initState();
  }

  Future<void> onComment() async {
    if (authController.isLogin) {
      await postViewModel.addComment(postid, myComment);
      setState(() {
        myComment = '';
        textController.clear();
      });
    } else {
      Get.snackbar('กรุณาเข้าสู่ระบบ',
          'เพื่อใช้งานความสามารถในการแสดงความคิดเห็นได้เต็มที่');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        elevation: 0.0,
        titleSpacing: 0.0,
        title: Row(
          children: [
            ClipOval(
              child: Image.network(
                userPicture,
                width: 40,
                height: 40,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: screenWidth * 0.02),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Heading20px(text: username),
                Body12px(
                  text: postViewModel.formatPostDate(int.parse(postDate)),
                  color: greyColor,
                ),
              ],
            ),
          ],
        ),
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
                  onPressed: () async {
                    Post postData = await data;
                    showModalBottomSheet(
                        context: Get.context!,
                        builder: (context) {
                          return BottomSheetForPost(item: postData);
                        });
                  },
                )
              : Container(),
        ],
      ),
      body: SingleChildScrollView(
          child: StreamBuilder(
        stream: postController.postStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return postDetail(snapshot.data!);
          }
          return const CircularProgressIndicator();
        },
      )),
    );
  }

  Widget postDetail(Post item) {
    final screenHeight = Get.height;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
          child: Form(
            key: formkey,
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
                    controller: textController,
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
                    style: const TextStyle(
                        fontFamily: 'Athiti', fontSize: 14, color: blackColor),
                    onChanged: (value) {
                      setState(() {
                        myComment = value;
                      });
                    },
                  ),
                ),
                (myComment.isNotEmpty)
                    ? IconButton(
                        icon:
                            const Icon(Icons.send_rounded, color: primaryColor),
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          onComment().then((value) {
                            setState(() {});
                          });
                        },
                      )
                    : Container(),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          separatorBuilder: (context, index) {
            return const SizedBox(height: 10);
          },
          itemCount: item.comments.length,
          itemBuilder: (context, index) {
            return comment(item.comments[index]);
          },
        ),
      ]),
    );
  }

  Widget comment(Comment item) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipOval(
            child: Image.network(
              item.user!.picture,
              width: 40,
              height: 40,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: blackColor.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: EdgeInsets.symmetric(
                    horizontal: (screenWidth - 80) * 0.05,
                    vertical: (screenWidth - 80) * 0.02),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Title14px(text: item.user!.nickName),
                    SizedBox(
                        width: (screenWidth - 80) * 0.9,
                        child: ExpandText(
                            text: item.description,
                            style: const TextStyle(
                              fontFamily: 'Athiti',
                              fontSize: 14,
                            ),
                            maxLines: 3)),
                  ],
                ),
              ),
              const SizedBox(height: 5),
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: (screenWidth - 80) * 0.05),
                child: Body12px(
                  text: postViewModel.formatPostDate(item.createdAt),
                  color: greyColor,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
