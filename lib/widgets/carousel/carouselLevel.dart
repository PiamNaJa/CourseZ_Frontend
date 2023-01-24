import 'package:carousel_slider/carousel_slider.dart';
import 'package:coursez/utils/color.dart';
import 'package:coursez/view_model/level_view_model.dart';
import 'package:coursez/widgets/text/body14px.dart';
import 'package:coursez/widgets/text/title16px.dart';
import 'package:flutter/material.dart';
import 'package:dots_indicator/dots_indicator.dart';

class CarouselLevel extends StatefulWidget {
  const CarouselLevel({super.key});

  @override
  State<CarouselLevel> createState() => _CarouselLevelState();
}

class _CarouselLevelState extends State<CarouselLevel> {
  int _currentLevel = 0;
  LevelViewModel levelViewModel = LevelViewModel();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: levelViewModel.loadLevel(_currentLevel),
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
        });
  }

  Widget buildLevel(List<Map<String, dynamic>> level) {
    return Wrap(
      alignment: WrapAlignment.center,
      children: [
        LayoutBuilder(
          builder: (context, constraints) => CarouselSlider(
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
                              vertical:
                                  MediaQuery.of(context).size.height * 0.04,
                              horizontal:
                                  MediaQuery.of(context).size.width * 0.01),
                          child: InkWell(
                            child: Column(
                              children: [
                                Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.end,
                                  direction: Axis.horizontal,
                                  spacing:
                                      MediaQuery.of(context).size.width * 0.02,
                                  runSpacing: 20,
                                  children: [
                                    for (int i = 0;
                                        i < item['subject'].length;
                                        i++)
                                      Column(
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Image.network(
                                                item['subject'][i]
                                                    .subjectPicture,
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
                                        ],
                                      ),
                                  ],
                                ),
                              ],
                            ),
                            onTap: () {
                              Navigator.of(context).pushNamed('/login');
                            },
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
                  _currentLevel = index;
                });
              },
              enableInfiniteScroll: true,
              aspectRatio: 0.5,
              viewportFraction: 1,
            ),
          ),
        ),
        DotsIndicator(
            dotsCount: level.length,
            position: _currentLevel.toDouble(),
            decorator: DotsDecorator(
              color: greyColor,
              activeColor: primaryColor,
              size: const Size.square(5),
              activeSize: const Size(18.0, 9.0),
              activeShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0)),
            )),
      ],
    );
  }
}
