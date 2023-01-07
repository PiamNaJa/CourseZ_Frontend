import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class carouselLevel extends StatefulWidget {
  const carouselLevel({super.key});

  @override
  State<carouselLevel> createState() => _carouselLevelState();
}

class classLevel {
  final int level;
  final String levelName;
  // final List<List<dynamic>> subject;

  classLevel({
    required this.level,
    required this.levelName,
    // required this.subject
  });
}

class subject {
  final String subjectName;
  final String image;

  subject({
    required this.subjectName,
    required this.image,
  });
}

class _carouselLevelState extends State<carouselLevel> {
  List<dynamic> level = [
    classLevel(
      level: 1,
      levelName: 'มัธยมศึกษาปีที่ 1',
    ),
    classLevel(
      level: 2,
      levelName: 'มัธยมศึกษาปีที่ 2',
    ),
    classLevel(
      level: 3,
      levelName: 'มัธยมศึกษาปีที่ 3',
    ),
    classLevel(
      level: 4,
      levelName: 'มัธยมศึกษาปีที่ 4',
    ),
    classLevel(
      level: 5,
      levelName: 'มัธยมศึกษาปีที่ 5',
    ),
    classLevel(
      level: 6,
      levelName: 'มัธยมศึกษาปีที่ 6',
    ),
    classLevel(level: 7, levelName: 'มหาวิทยาลัย'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CarouselSlider(
        items: level.map((item) {
          return Container(
            width: 400,
            padding: EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Column(
              //create row for each item
              children: <Widget>[],
            ),
          );
        }).toList(),
        options: CarouselOptions(
          // autoPlay: true,
          // pauseAutoPlayOnTouch: true,
          enableInfiniteScroll: true,
          aspectRatio: 1,
          enlargeCenterPage: true,
          viewportFraction: 1,
        ),
      ),
    );
  }
}
