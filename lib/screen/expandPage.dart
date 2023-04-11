import 'package:coursez/components/courseList.dart';
import 'package:coursez/controllers/level_controller.dart';
import 'package:coursez/controllers/refresh_controller.dart';
import 'package:coursez/model/tutor.dart';
import 'package:coursez/utils/color.dart';
import 'package:coursez/view_model/course_view_model.dart';
import 'package:coursez/view_model/tutor_view_model.dart';
import 'package:coursez/widgets/appbar/app_bar.dart';
import 'package:coursez/widgets/rating/rating.dart';
import 'package:coursez/widgets/text/body14px.dart';
import 'package:coursez/widgets/text/heading2_20px.dart';
import 'package:coursez/widgets/text/title14px.dart';
import 'package:coursez/widgets/text/title16px.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/course.dart';

class ExpandPage extends StatefulWidget {
  const ExpandPage({super.key});

  @override
  State<ExpandPage> createState() => _ExpandPageState();
}

class _ExpandPageState extends State<ExpandPage> {
  final isloadcourse = Get.arguments ?? false;
  final LevelController levelController = Get.find<LevelController>();
  final RefreshController refreshController = Get.find<RefreshController>();
  final TutorViewModel tutorViewModel = TutorViewModel();
  final CourseViewModel courseViewModel = CourseViewModel();
  late String title;
  late dynamic model;
  @override
  void initState() {
    if (isloadcourse) {
      title = 'คอร์สเรียนยอดนิยม';
      model = CourseList;
    } else {
      title = 'ติวเตอร์ยอดนิยม';
      model = _tutor;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: whiteColor.withOpacity(0.95),
        appBar: CustomAppBar(
          title: title,
        ),
        body: Obx(
          () {
            refreshController.trigerRefresh;
            return FutureBuilder(
                future: isloadcourse
                    ? courseViewModel.loadCourse(levelController.level)
                    : tutorViewModel.loadTutor(levelController.level),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return (snapshot.data.length == 0)
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Title16px(
                                    text:
                                        'ขออภัยครับ/ ค่ะ ไม่มีคอร์สเรียนในระดับนี้',
                                    color: greyColor),
                                Icon(
                                  Icons.sentiment_dissatisfied_outlined,
                                  color: greyColor,
                                  size: 50,
                                )
                              ],
                            ),
                          )
                        : ListView.builder(
                            itemCount: (snapshot.data.length > 10)
                                ? 10
                                : snapshot.data.length,
                            itemBuilder: (context, index) =>
                                (model == CourseList)
                                    ? CourseList(item: snapshot.data[index])
                                    : model(snapshot.data[index]),
                          );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                });
          },
        ));
  }
}

Widget _tutor(Tutor item) {
  return GestureDetector(
    onTap: () {},
    child: Container(
        height: MediaQuery.of(Get.context!).size.height * 0.15,
        decoration: BoxDecoration(
            color: whiteColor,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ]),
        margin: EdgeInsets.only(
            top: 10,
            left: MediaQuery.of(Get.context!).size.width * 0.05,
            right: MediaQuery.of(Get.context!).size.width * 0.05),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  item.picture,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
              Expanded(
                  child: Container(
                // width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Heading20px(text: item.fullname),
                    Title14px(text: item.nickname),
                    (item.rating != 0)
                        ? RatingStar(
                            rating: item.rating.toDouble(),
                            size: 20,
                          )
                        : const Body14px(
                            text: 'ยังไม่มีคะแนน',
                            color: greyColor,
                          ),
                  ],
                ),
              )),
              const Icon(
                Icons.navigate_next_rounded,
                color: primaryColor,
              )
            ],
          ),
        )),
  );
}
