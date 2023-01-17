import 'package:carousel_slider/carousel_slider.dart';
import 'package:coursez/model/subject.dart';
import 'package:coursez/utils/color.dart';
import 'package:coursez/widgets/text/body14px.dart';
import 'package:coursez/widgets/text/title16px.dart';
import 'package:flutter/material.dart';
import 'package:dots_indicator/dots_indicator.dart';

import '../../utils/fetchData.dart';

class carouselLevel extends StatefulWidget {
  const carouselLevel({super.key});

  @override
  State<carouselLevel> createState() => _carouselLevelState();
}

class _carouselLevelState extends State<carouselLevel> {
  final List<Subject> _subject = [];
  List<Map<String, dynamic>> level = [];
  int _currentLevel = 0;
  bool _isError = false;

  @override
  void initState() {
    super.initState();
    fecthData('subject').then((value) {
      setState(() {
        if (value['err'] == null) {
          value['data'].map((e) => _subject.add(Subject.fromJson(e))).toList();
          for (int i in [1, 2, 3, 4, 5, 6]) {
            level.add({
              'levelName': 'มัธยมศึกษาปีที่ $i',
              'subject':
                  _subject.where((element) => element.classLevel == i).toList()
            });
          }
          level.add({
            'levelName': 'มหาวิทยาลัย',
            'subject':
                _subject.where((subject) => subject.classLevel == 7).toList()
          });
          debugPrint(level[0]['subject'][0].toString());
        } else {
          _isError = true;
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return level.isEmpty
        ? const CircularProgressIndicator()
        : Wrap(
            alignment: WrapAlignment.center,
            children: [
              Column(
                children: [
                  CarouselSlider(
                    items: level.map((item) {
                      return Container(
                        padding: MediaQuery.of(context).size.width > 600
                            ? const EdgeInsets.symmetric(horizontal: 10)
                            : const EdgeInsets.symmetric(horizontal: 5),
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: greyColor),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: const [
                                BoxShadow(color: blackColor, blurRadius: 1)
                              ]),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5),
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
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 20, horizontal: 5),
                                  child: InkWell(
                                    child: Column(
                                      children: [
                                        Wrap(
                                          crossAxisAlignment:
                                              WrapCrossAlignment.end,
                                          direction: Axis.horizontal,
                                          spacing: 15,
                                          runSpacing: 20,
                                          children: [
                                            for (int i = 0;
                                                i < item['subject'].length;
                                                i++)
                                              Column(
                                                children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                Image.network(
                                                        item['subject'][i]
                                                            .subjectPicture,
                                                        width: 70,
                                                        height: 50,
                                                      ),
                                                      Body14px(
                                                          text: item['subject']
                                                                  [i]
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
                      height: 260,
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
                ],
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
//FittedBox(
              //   fit: BoxFit.fitHeight,
              //   child: DotsIndicator(
              //       dotsCount: level.length,
              //       position: _currentLevel.toDouble(),
              //       decorator: DotsDecorator(
              //         color: greyColor,
              //         activeColor: primaryColor,
              //         size: const Size.square(5),
              //         activeSize: const Size(18.0, 9.0),
              //         activeShape: RoundedRectangleBorder(
              //             borderRadius: BorderRadius.circular(5.0)),
              //       )),
              // ),