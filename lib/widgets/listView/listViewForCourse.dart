import 'package:coursez/utils/color.dart';
import 'package:coursez/widgets/text/body10px.dart';
import 'package:coursez/widgets/text/title12px.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:coursez/widgets/rating/rating.dart';
import 'package:flutter/material.dart';

class cardItem {
  final String urlImage;
  final String title;
  final String teacher;
  final double rating;

  cardItem(
      {required this.urlImage,
      required this.title,
      required this.teacher,
      required this.rating});
}

class listViewForCourse extends StatefulWidget {
  final double rating;

  const listViewForCourse({super.key, required this.rating});

  @override
  State<listViewForCourse> createState() => _listViewForCourseState();
}

class _listViewForCourseState extends State<listViewForCourse> {
  List<cardItem> items = [
    cardItem(
        urlImage:
            'https://panyasociety.com/pages/wp-content/uploads/2022/08/thai_alevel_coursecover.jpg',
        title: 'เกร็งข้อสอบ O-NET ภาษาไทย ม.6',
        teacher: 'พี่ชาร์ป A-Level',
        rating: 4.8),
    cardItem(
        urlImage:
            'https://panyasociety.com/pages/wp-content/uploads/2022/08/thai_alevel_coursecover.jpg',
        title: 'เกร็งข้อสอบ O-NET ภาษาไทย ม.6',
        teacher: 'พี่ชาร์ป A-Level',
        rating: 4.8),
    cardItem(
        urlImage:
            'https://panyasociety.com/pages/wp-content/uploads/2022/08/thai_alevel_coursecover.jpg',
        title: 'เกร็งข้อสอบ O-NET ภาษาไทย ม.6',
        teacher: 'พี่ชาร์ป A-Level',
        rating: 4.8),
    cardItem(
        urlImage:
            'https://panyasociety.com/pages/wp-content/uploads/2022/08/thai_alevel_coursecover.jpg',
        title: 'เกร็งข้อสอบ O-NET ภาษาไทย ม.6',
        teacher: 'พี่ชาร์ป A-Level',
        rating: 4.8),
    cardItem(
        urlImage:
            'https://panyasociety.com/pages/wp-content/uploads/2022/08/thai_alevel_coursecover.jpg',
        title: 'เกร็งข้อสอบ O-NET ภาษาไทย ม.6',
        teacher: 'พี่ชาร์ป A-Level',
        rating: 4.8),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        height: 160,
        child: ListView.separated(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            separatorBuilder: (context, _) => const SizedBox(
                  width: 20,
                ),
            itemBuilder: (context, index) =>
                buildCard(items[index], widget.rating)),
      ),
    );
  }
}

Widget buildCard(cardItem item, double rating) {
  return LayoutBuilder(
      builder: (BuildContext context, Constraints constraints) {
    return GestureDetector(
      onTap: () {},
      child: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
              color: whiteColor,
              border: Border.all(color: greyColor, width: 1),
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                  color: blackColor,
                  blurRadius: 1,
                )
              ]),
          width: 140,
          height: 160,
          child: Column(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                  child: Image.network(
                    item.urlImage,
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(5, 3, 5, 3),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Title12px(
                      text: item.title,
                    ),
                    Body10px(
                      text: item.teacher,
                    ),
                    ratingStar(rating: rating)
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
