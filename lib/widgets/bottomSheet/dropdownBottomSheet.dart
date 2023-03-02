import 'package:coursez/controllers/post_controller.dart';
import 'package:coursez/model/subject.dart';
import 'package:coursez/utils/color.dart';
import 'package:coursez/view_model/level_view_model.dart';
import 'package:coursez/widgets/text/body14px.dart';
import 'package:coursez/widgets/text/title14px.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomSheetForDropdown extends StatelessWidget {
  const BottomSheetForDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    LevelViewModel levelViewModel = LevelViewModel();
    PostController postController = Get.find<PostController>();

    double screenWidth = Get.width;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            const Align(
                alignment: Alignment.centerLeft,
                child: Title14px(text: 'ระดับชั้น')),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: InkWell(
                    onTap: () {
                      Get.back();
                      postController.subjectid = 0;
                      postController.classLevel = 0;
                      postController.classLevelName = 'เลือกระดับชั้น';
                      postController.subjectTitle = '';
                    },
                    child: Container(
                        width: screenWidth / 4,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          border: Border.all(color: primaryColor),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                        ),
                        child: const Center(child: Body14px(text: 'ทั้งหมด'))),
                  )),
            ),
            const SizedBox(
              height: 10,
            ),
            FutureBuilder(
              future: levelViewModel.loadLevel(0),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: snapshot.data!.map((e) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Title14px(text: e['levelName']),
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
                                        postController.classLevelName =
                                            'มหาวิทยาลัย';
                                      } else {
                                        postController.classLevelName =
                                            'ม.${subject.classLevel}';
                                      }
                                      postController.subjectTitle =
                                          subject.subjectTitle;
                                      postController.classLevel =
                                          subject.classLevel;
                                    },
                                    child: Container(
                                      width: screenWidth / 4,
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: primaryColor),
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
          ],
        ),
      ),
    );
  }
}
