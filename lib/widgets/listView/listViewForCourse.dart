import 'dart:ui';
import 'package:coursez/utils/color.dart';
import 'package:coursez/view_model/course_view_model.dart';
import 'package:coursez/widgets/text/body10px.dart';
import 'package:coursez/widgets/text/title12px.dart';
import 'package:coursez/widgets/text/title16px.dart';
import 'package:flutter/rendering.dart';
import 'package:coursez/widgets/rating/rating.dart';
import 'package:flutter/material.dart';
import 'package:coursez/model/course.dart';
import 'package:get/get.dart';

class ListViewCourse extends StatelessWidget {
  const ListViewCourse({super.key, required this.level});

  final int level;
  @override
  Widget build(BuildContext context) {
    CourseViewModel courseViewModel = CourseViewModel();
    return FutureBuilder(
      future: courseViewModel.loadCourse(level),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return SingleChildScrollView(
            child: SizedBox(
              height: 170,
              child: (snapshot.data.length == 0)
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Title16px(
                            text: 'ขออภัยครับ/ ค่ะ ไม่มีคอร์สเรียนในระดับนี้',
                            color: greyColor),
                        Icon(
                          Icons.sentiment_dissatisfied_outlined,
                          color: greyColor,
                          size: 50,
                        ),
                      ],
                    )
                  : ListView.separated(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount:
                          (snapshot.data.length > 5) ? 5 : snapshot.data.length,
                      separatorBuilder: (context, _) => const SizedBox(
                            width: 20,
                          ),
                      itemBuilder: (context, index) =>
                          buildCard(snapshot.data[index])),
            ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

Widget buildCard(Course item) {
  return LayoutBuilder(
      builder: (BuildContext context, Constraints constraints) {
    return GestureDetector(
      onTap: () {
        Get.toNamed('/course/${item.courseId.toString()}');
      },
      child: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
              color: whiteColor,
              border: Border.all(color: greyColor, width: 0.6),
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                  color: greyColor,
                  blurRadius: 5,
                  offset: Offset(0, 1),
                )
              ]),
          width: 140,
          height: 160,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                  child: Image.network(
                    item.picture,
                    width: 140,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Title12px(
                      text: item.coursename,
                    ),
                    Body10px(
                      text: item.description,
                    ),
                    ratingStar(rating: item.rating!),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  });
}
