import 'dart:io';

import 'package:coursez/controllers/post_controller.dart';
import 'package:coursez/model/post.dart';
import 'package:coursez/utils/color.dart';
import 'package:coursez/utils/pickImage.dart';
import 'package:coursez/view_model/post_view_model.dart';
import 'package:coursez/widgets/text/body14px.dart';
import 'package:coursez/widgets/text/title12px.dart';
import 'package:coursez/widgets/text/title14px.dart';
import 'package:coursez/widgets/text/title16px.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomSheetForPost extends StatelessWidget {
  final Post item;
  const BottomSheetForPost({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    double screenWidth = Get.width;
    double screenHeight = Get.height;
    final PostController postController = Get.find<PostController>();
    final PostViewModel postViewModel = PostViewModel();
    File? image;
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final TextEditingController textController = TextEditingController();
    textController.text = item.caption;

    onSubmit() {
      if (formKey.currentState!.validate()) {
        formKey.currentState!.save();
        postViewModel.updatePost( textController.text.trim(), image, item.postPicture,item.postId.toString()
           );
        Get.back();
      }
    }

    return SizedBox(
      height: screenHeight / 8,
      child: Column(
        children: [
          InkWell(
            onTap: () {
              // Get.back();
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return StatefulBuilder(builder: (context, setState) {
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
                                child: Form(
                                  key: formKey,
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
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          IconButton(
                                            constraints: const BoxConstraints(),
                                            padding:
                                                const EdgeInsets.only(right: 5),
                                            onPressed: () {
                                              PickImage.pickImage()
                                                  .then((value) => setState(() {
                                                        image = value;
                                                      }));
                                            },
                                            icon: const Icon(Icons.image),
                                            color: primaryColor,
                                          ),
                                          Expanded(
                                            child: TextFormField(
                                              controller: textController,
                                              decoration: const InputDecoration(
                                                border: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: greyColor,
                                                  ),
                                                ),
                                              ),
                                              maxLines: 1,
                                              style: const TextStyle(
                                                fontFamily: 'Athiti',
                                                fontSize: 12,
                                                color: blackColor,
                                              ),
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return 'กรุณากรอกข้อมูล';
                                                }
                                                return null;
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      item.postPicture.isNotEmpty
                                          ? InkWell(
                                              child: ClipRect(
                                                child: image == null
                                                    ? Image.network(
                                                        item.postPicture,
                                                        width: double.infinity,
                                                        height:
                                                            screenHeight * 0.2,
                                                        fit: BoxFit.cover,
                                                      )
                                                    : Image.file(
                                                        image!,
                                                        width: double.infinity,
                                                        height:
                                                            screenHeight * 0.2,
                                                        fit: BoxFit.cover,
                                                      ),
                                              ),
                                              onTap: () {
                                                showDialog(
                                                    context: context,
                                                    builder: (context) {
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
                                                            child: image == null
                                                                ? Image.network(
                                                                    item.postPicture,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  )
                                                                : Image.file(
                                                                    image!,
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
                                            onPressed: () {
                                              onSubmit();
                                            },
                                            child: const Title14px(
                                              text: 'บันทึก',
                                              color: whiteColor,
                                            )),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  });
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
                  builder: (context) {
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
  }
}
