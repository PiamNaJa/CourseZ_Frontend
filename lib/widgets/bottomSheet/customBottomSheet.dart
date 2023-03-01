import 'package:coursez/model/post.dart';
import 'package:coursez/model/subject.dart';
import 'package:coursez/utils/color.dart';
import 'package:coursez/view_model/level_view_model.dart';
import 'package:coursez/view_model/post_view_model.dart';
import 'package:coursez/widgets/text/body14px.dart';
import 'package:coursez/widgets/text/title12px.dart';
import 'package:coursez/widgets/text/title14px.dart';
import 'package:coursez/widgets/text/title16px.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/post_controller.dart';

class CustomBottomSheet {
  PostViewModel postViewModel = PostViewModel();
  PostController postController = Get.find<PostController>();
  final screenHeight = Get.height;
  final screenWidth = Get.width;

  Future<dynamic> bottomSheetForPost(Post item) {
    return showModalBottomSheet(
        context: Get.context!,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        ),
        builder: ((context) {
          return SizedBox(
            height: screenHeight / 8,
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    Get.back();
                    showDialog(
                      context: Get.context!,
                      builder: (BuildContext context) {
                        return Dialog(
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Column(
                                children: [
                                  Stack(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: screenHeight / 65),
                                        width: screenWidth,
                                        alignment: Alignment.center,
                                        child: const Title16px(
                                          text: 'แก้ไขโพสต์',
                                        ),
                                      ),
                                      Positioned(
                                        top: 0,
                                        right: 0,
                                        child: IconButton(
                                          padding: EdgeInsets.zero,
                                          onPressed: () {
                                            Get.back();
                                          },
                                          icon: const Icon(
                                            Icons.close,
                                            color: blackColor,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    color: greyColor,
                                    width: screenWidth * 0.8,
                                    height: 1,
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: screenWidth / 25),
                                    child: Column(
                                      children: [
                                        ListTile(
                                          contentPadding: EdgeInsets.zero,
                                          leading: ClipOval(
                                            child: Image.network(
                                              item.user!.picture,
                                              width: 40,
                                              height: 40,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          title: Title12px(
                                              text: item.user!.fullName),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        TextFormField(
                                          initialValue: item.caption,
                                          decoration: const InputDecoration(
                                            border: OutlineInputBorder(),
                                          ),
                                          maxLines: 2,
                                          style: const TextStyle(
                                            fontFamily: 'Athiti',
                                            fontSize: 12,
                                            color: blackColor,
                                          ),
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
                                                    height: screenHeight * 0.2,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                                onTap: () {
                                                  showDialog(
                                                      context: Get.context!,
                                                      builder: (_) {
                                                        return Dialog(
                                                            insetPadding:
                                                                const EdgeInsets
                                                                    .all(30),
                                                            backgroundColor:
                                                                Colors
                                                                    .transparent,
                                                            child:
                                                                InteractiveViewer(
                                                              minScale: 0.8,
                                                              maxScale: 2,
                                                              child:
                                                                  Image.network(
                                                                item.postPicture,
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                            ));
                                                      });
                                                },
                                              )
                                            : const SizedBox(),
                                        const SizedBox(
                                          height: 12,
                                        ),
                                        Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color: primaryColor,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border: Border.all(
                                                color: greyColor, width: 1),
                                          ),
                                          child: TextButton(
                                              onPressed: () {},
                                              child: const Title14px(
                                                text: 'บันทึก',
                                                color: whiteColor,
                                              )),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child: Container(
                    width: screenWidth,
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(vertical: screenHeight / 65),
                    child: const Title16px(
                      text: 'แก้ไขโพสต์',
                    ),
                  ),
                ),
                Container(
                  color: greyColor,
                  width: screenWidth * 0.95,
                  height: 0.5,
                ),
                InkWell(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (_) {
                          return AlertDialog(
                            title: const Title16px(
                              text: 'ลบโพสต์',
                            ),
                            content: const Body14px(
                              text: 'คุณต้องการลบโพสต์นี้ใช่หรือไม่',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Get.back();
                                },
                                child: const Title16px(
                                  text: 'ยกเลิก',
                                  color: greyColor,
                                ),
                              ),
                              TextButton(
                                onPressed: () async {
                                  Get.back();
                                  Get.back();
                                  await postViewModel
                                      .deletePost(item.postId.toString());
                                  await postController
                                      .fecthPostList(postController.subjectid);
                                  
                                },
                                child: const Title16px(
                                  text: 'ตกลง',
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          );
                        });
                  },
                  child: Container(
                    width: screenWidth,
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(vertical: screenHeight / 65),
                    child: const Title16px(
                      text: 'ลบโพสต์',
                    ),
                  ),
                ),
              ],
            ),
          );
        }));
  }

  Future<dynamic> bottomSheetForDropdown() {
    final LevelViewModel levelViewModel = LevelViewModel();
    final PostController postController = Get.find<PostController>();
    return showModalBottomSheet(
        context: Get.context!,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        ),
        builder: (context) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: FutureBuilder(
                future: levelViewModel.loadLevel(0),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      children: snapshot.data!.map((e) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Title14px(text: e['levelName']),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Wrap(
                                spacing: screenWidth / 20,
                                runSpacing: 10,
                                runAlignment: WrapAlignment.spaceBetween,
                                children: [
                                  ...e['subject'].map((Subject subject) {
                                    return InkWell(
                                      onTap: () {
                                        Get.back();
                                        postController.subjectid =
                                            subject.subjectId;
                                        if (subject.classLevel == 7) {
                                          postController.subjectLevel =
                                              'มหาวิทยาลัย';
                                        } else {
                                          postController.subjectLevel =
                                              'ม.${subject.classLevel}';
                                        }
                                        postController.subjectTitle =
                                            subject.subjectTitle;
                                      },
                                      child: Container(
                                        width: screenWidth / 4,
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          border:
                                              Border.all(color: primaryColor),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(10)),
                                        ),
                                        child: Center(
                                            child: Body14px(
                                                text: subject.subjectTitle)),
                                      ),
                                    );
                                  }).toList(),
                                ],
                              ),
                            )
                          ],
                        );
                      }).toList(),
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
          );
        });
  }
}

// class test extends StatelessWidget {
//   const test({super.key});

//   @override
//   Future<dynamic> build(BuildContext context) {
//     return showModalBottomSheet(
//       context: Get.context!,
//       builder: builder
//     );
//   }
// }