import 'package:coursez/components/courseList.dart';
import 'package:coursez/model/course.dart';
import 'package:coursez/utils/color.dart';
import 'package:coursez/widgets/appbar/app_bar.dart';
import 'package:coursez/widgets/rating/rating.dart';
import 'package:coursez/widgets/text/title14px.dart';
import 'package:coursez/widgets/text/title16px.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';

class CourseSubject extends StatelessWidget {
  CourseSubject({super.key});
  final Future<List<Course>> data = Get.arguments;
  final String title = Get.parameters['subjectTitle']!;
  final String subjectId = Get.parameters['subjectId']!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: whiteColor.withOpacity(0.95),
        appBar: CustomAppBar(
          title: (subjectId == '7')
              ? '$title มหาวิทยาลัย'
              : '$title ม. $subjectId',
        ),
        body: FutureBuilder(
            future: data,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return (snapshot.data.length == 0)
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Title16px(
                                text:
                                    'ขออภัยครับ/ ค่ะ ไม่มีคอร์สเรียนในวิชานี้',
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
                        itemBuilder: (context, index) => CourseList(
                              item: snapshot.data[index],
                            ));
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }));
  }
}
