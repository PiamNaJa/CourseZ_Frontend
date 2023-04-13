import 'package:coursez/controllers/auth_controller.dart';
import 'package:coursez/controllers/post_controller.dart';
import 'package:coursez/model/post.dart';
import 'package:coursez/utils/color.dart';
import 'package:coursez/view_model/post_view_model.dart';
import 'package:coursez/widgets/bottomSheet/postBottomSheet.dart';
import 'package:coursez/widgets/text/body12px.dart';
import 'package:coursez/widgets/text/body14px.dart';
import 'package:coursez/widgets/text/expandableText.dart';
import 'package:coursez/widgets/text/title14px.dart';
import 'package:coursez/widgets/text/title16px.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PostList extends StatelessWidget {
  final int subjectId;
  PostList({super.key, required this.subjectId});

  PostViewModel postViewModel = PostViewModel();
  AuthController authController = Get.find();
  PostController postController = Get.find<PostController>();

  @override
  Widget build(BuildContext context) {
    postController.fetchPostList(subjectId);
    return StreamBuilder(
        stream: postController.postListStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return (snapshot.data!.isNotEmpty)
                ? ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return buildList(snapshot.data![index]);
                    },
                  )
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Title16px(
                            text: 'ยังไม่มีโพสต์ในหัวข้อนี้', color: greyColor),
                        SizedBox(height: 10),
                        Body14px(
                            text: 'เริ่มโพสต์เพื่อแชร์ความรู้กับคนอื่นได้เลย',
                            color: greyColor),
                      ],
                    ),
                  );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  Widget buildList(Post item) {
    double screenWidth = Get.width;
    double screenHeight = Get.height;
    return InkWell(
      onTap: () {
        Get.toNamed('/post/${item.postId.toString()}', parameters: {
          "username": item.user!.nickName,
          "user_id": item.user!.userId.toString(),
          "user_picture": item.user!.picture,
          "post_date": item.createdAt.toString(),
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
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Obx(
            () => ListTile(
              contentPadding: const EdgeInsets.all(0),
              leading: ClipOval(
                child: Image.network(
                  item.user!.picture,
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                ),
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Title16px(text: item.user!.fullName),
                  Row(
                    children: [
                      Body14px(
                        text:
                            '${postViewModel.formatPostDate(item.createdAt)}, ${item.subject!.subjectTitle}, ${postViewModel.formatLevel(item.subject!.classLevel)}',
                        color: greyColor,
                      ),
                    ],
                  ),
                ],
              ),
              trailing: authController.userid == item.user!.userId
                  ? IconButton(
                      icon: const Icon(
                        Icons.more_horiz_outlined,
                        color: greyColor,
                      ),
                      onPressed: () {
                        showModalBottomSheet(
                            context: Get.context!,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20)),
                            ),
                            builder: (context) {
                              return BottomSheetForPost(item: item);
                            });
                      })
                  : const SizedBox(),
            ),
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
            height: 10,
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
          (item.comments.isNotEmpty)
              ? Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Body12px(
                    text: 'ความคิดเห็น ${item.comments.length} รายการ',
                    color: greyColor,
                  ),
                )
              : const SizedBox(
                  height: 10,
                ),
          Row(
            children: [
              Obx(
                () => ClipOval(
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
                              "user_picture": item.user!.picture,
                              "post_date": item.createdAt.toString(),
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
          const SizedBox(
            height: 10,
          ),
          if (item.comments.isNotEmpty)
            for (var i = 0; i < item.comments.length && i < 2; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipOval(
                      child: Image.network(
                        item.comments[i].user!.picture,
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
                              Title14px(text: item.comments[i].user!.fullName),
                              SizedBox(
                                  width: (screenWidth - 80) * 0.9,
                                  child: ExpandText(
                                      text: item.comments[i].description,
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
                          padding: EdgeInsets.symmetric(
                              horizontal: (screenWidth - 80) * 0.05),
                          child: Body12px(
                            text: postViewModel
                                .formatPostDate(item.comments[i].createdAt),
                            color: greyColor,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              )
          else
            const SizedBox(),
        ]),
      ),
    );
  }
}
