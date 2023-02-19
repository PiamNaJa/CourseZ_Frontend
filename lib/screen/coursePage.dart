import 'package:coursez/controllers/auth_controller.dart';
import 'package:coursez/utils/color.dart';
import 'package:coursez/view_model/course_view_model.dart';
import 'package:coursez/widgets/Icon/border_icon.dart';
import 'package:coursez/widgets/alert/alert.dart';
import 'package:coursez/widgets/button/button.dart';
import 'package:coursez/widgets/rating/rating.dart';
import 'package:coursez/widgets/text/heading1_24px.dart';
import 'package:coursez/widgets/text/heading2_20px.dart';
import 'package:coursez/widgets/text/title14px.dart';
import 'package:coursez/widgets/videoCard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CoursePage extends StatefulWidget {
  const CoursePage({super.key});

  @override
  State<CoursePage> createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage> {
  final Icon fav = const Icon(Icons.favorite_border);
  final data = Get.arguments;
  final AuthController authController = Get.find();
  final CourseViewModel courseViewModel = CourseViewModel();

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: SafeArea(
            child: SizedBox(
                width: size.width,
                height: size.height,
                child: FutureBuilder(
                  future: data,
                  builder: ((context, snapshot) {
                    return (snapshot.hasData)
                        ? SizedBox(
                            child: detail(snapshot.data),
                          )
                        : const Center(child: CircularProgressIndicator());
                  }),
                ))));
  }

  Widget detail(dynamic courseData) {
    final Size size = MediaQuery.of(Get.context!).size;
    const double padding = 15;
    const sidePadding = EdgeInsets.symmetric(horizontal: padding);
    final sumVideoPrice = courseViewModel.allVideoPriceInCourse(courseData);
    return Stack(
      children: [
        SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Image.network(
                    courseData.picture,
                    height: size.height * 0.4,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    top: padding,
                    width: size.width,
                    child: Padding(
                      padding: sidePadding,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              Get.back();
                            },
                            child: const BorderIcon(
                                width: 50,
                                height: 50,
                                child: Icon(
                                  Icons.arrow_back_ios_outlined,
                                  color: primaryColor,
                                )),
                          ),
                          InkWell(
                            onTap: () {
                              if (authController.isLogin) {
                                setState(() {});
                              } else {
                                showDialog(
                                    context: Get.context!,
                                    builder: (BuildContext context) {
                                      return const AlertLogin(
                                        body:
                                            'กรุณาเข้าสู่ระบบเพื่อเพิ่มวีดิโอที่ชอบ',
                                        action: 'เข้าสู่ระบบ',
                                      );
                                    });
                              }
                            },
                            child: const BorderIcon(
                                width: 50,
                                height: 50,
                                child: Icon(
                                  Icons.favorite_border,
                                )),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: padding,
              ),
              Padding(
                padding: sidePadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 5),
                          child: Heading24px(text: courseData.coursename),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 5),
                          child:
                              RatingStar(rating: courseData.rating!, size: 20),
                        ),
                        Title14px(text: courseData.rating.toString()),
                      ],
                    ),
                    const Title14px(
                      text: 'ชื่อครู',
                      color: greyColor,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: padding,
              ),
              Padding(
                padding: sidePadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Title14px(
                      text: 'รายละเอียด',
                    ),
                    Text(
                      courseData.description,
                      style: const TextStyle(
                        fontFamily: 'Athiti',
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: padding,
              ),
              Padding(
                padding: sidePadding,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Heading20px(text: "บทเรียน"),
                        Row(
                          children: [
                            Bt(
                              text: "ซื้อทั้งหมด $sumVideoPrice บาท",
                              color: primaryColor,
                              onPressed: () {
                                if (!authController.isLogin) {
                                  showDialog(
                                      context: Get.context!,
                                      builder: (BuildContext context) {
                                        return const AlertLogin(
                                          body:
                                              'กรุณาเข้าสู่ระบบเพื่อซื้อวีดิโอ',
                                          action: 'เข้าสู่ระบบ',
                                        );
                                      });
                                }
                              },
                            ),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Center(
                      child: LayoutBuilder(builder: (context, constraints) {
                        return Wrap(
                            spacing: constraints.maxWidth * 0.02,
                            runSpacing: 12,
                            children: List.generate(
                              courseData.videos.length,
                              ((index) {
                                return VideoCard(
                                  image: courseData.videos[index].picture,
                                  name: courseData.videos[index].videoName,
                                  width: constraints.maxWidth * 0.3,
                                  height: constraints.maxWidth * 0.3 + 1,
                                  price: courseData.videos[index].price,
                                  onTap: () {
                                    Get.toNamed(
                                        '/course/${courseData.courseId}/video/${courseData.videos[index].videoId}',
                                        parameters: {
                                          "video_name": courseData
                                              .videos[index].videoName,
                                          "teacher_id": courseData.teacherId.toString()
                                        });
                                    debugPrint(courseData.videos[index].videoId
                                        .toString());
                                  },
                                );
                              }),
                            ));
                      }),
                    )
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
