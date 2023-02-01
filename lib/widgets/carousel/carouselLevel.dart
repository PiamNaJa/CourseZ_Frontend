import 'package:carousel_slider/carousel_slider.dart';
import 'package:coursez/controllers/level_controller.dart';
import 'package:coursez/utils/color.dart';
import 'package:coursez/view_model/course_view_model.dart';
import 'package:coursez/view_model/level_view_model.dart';
import 'package:coursez/widgets/text/body14px.dart';
import 'package:coursez/widgets/text/title16px.dart';
import 'package:flutter/material.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:get/get.dart';

class CarouselLevel extends StatefulWidget {
  const CarouselLevel({super.key});

  @override
  State<CarouselLevel> createState() => _CarouselLevelState();
}

class _CarouselLevelState extends State<CarouselLevel> {
  LevelController levelController = Get.find<LevelController>();
  LevelViewModel levelViewModel = LevelViewModel();
  CourseViewModel courseViewModel = CourseViewModel();
  late CarouselController buttonCarouselController;
  int currentLevel = 0;
  @override
  void initState() {
    buttonCarouselController = CarouselController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => FutureBuilder(
        future: levelViewModel.loadLevel(levelController.level),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return buildLevel(snapshot.data);
          } else if (snapshot.hasError) {
            return const Center(
                child: CircularProgressIndicator(
              color: Colors.red,
            ));
          } else {
            return const Center(
                child: CircularProgressIndicator(
              color: primaryColor,
            ));
          }
        }));
  }

  Widget buildLevel(List<Map<String, dynamic>> level) {
    if (levelController.level != 0) {
      currentLevel = 0;
    }
    return Wrap(
      alignment: WrapAlignment.center,
      children: [
        CarouselSlider(
          carouselController: buttonCarouselController,
          items: level.map((item) {
            return Container(
              padding: MediaQuery.of(context).size.width > 600
                  ? const EdgeInsets.symmetric(horizontal: 10)
                  : const EdgeInsets.symmetric(horizontal: 5),
              child: Container(
                decoration: BoxDecoration(
                    color: whiteColor,
                    border: Border.all(color: greyColor),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(color: greyColor, blurRadius: 1)
                    ]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Title16px(text: item['levelName'])),
                    Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: greyColor,
                            width: 1,
                          ),
                        ),
                      ),
                    ),
                    Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                            vertical: MediaQuery.of(context).size.height * 0.04,
                            horizontal:
                                MediaQuery.of(context).size.width * 0.01),
                        child: Column(
                          children: [
                            Wrap(
                              crossAxisAlignment: WrapCrossAlignment.end,
                              direction: Axis.horizontal,
                              spacing: MediaQuery.of(context).size.width * 0.02,
                              runSpacing: 20,
                              children: [
                                for (int i = 0; i < item['subject'].length; i++)
                                  Column(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          Get.toNamed('/coursesubject',
                                              arguments: courseViewModel
                                                  .loadCourseBySubject(
                                                      item['subject'][i]
                                                          .subjectId),
                                              parameters: {
                                                'subjectTitle': item['subject']
                                                        [i]
                                                    .subjectTitle,
                                                'subjectId': item['subject'][i]
                                                    .classLevel
                                                    .toString(),
                                              });
                                        },
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Image.network(
                                              item['subject'][i].subjectPicture,
                                              width: 70,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.05,
                                            ),
                                            Body14px(
                                                text: item['subject'][i]
                                                    .subjectTitle),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ],
                        )),

                    // display a list of subject items
                  ],
                ),
              ),
            );
          }).toList(),
          options: CarouselOptions(
            height: 263,
            onPageChanged: (index, reason) {
              setState(() {
                currentLevel = index;
                debugPrint('level: $currentLevel');
              });
            },
            enableInfiniteScroll: false,
            aspectRatio: 0.5,
            viewportFraction: 1,
          ),
        ),
        if (level.length > 1)
          DotsIndicator(
              dotsCount: 7,
              position: currentLevel.toDouble(),
              decorator: DotsDecorator(
                color: greyColor,
                activeColor: primaryColor,
                size: const Size.square(5),
                activeSize: const Size(18.0, 9.0),
                activeShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0)),
              ))
        else
          Container()
      ],
    );
  }
}
