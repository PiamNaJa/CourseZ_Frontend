import 'package:coursez/utils/color.dart';
import 'package:coursez/widgets/text/body10px.dart';
import 'package:coursez/widgets/text/title12px.dart';
import 'package:flutter/rendering.dart';
import 'package:coursez/widgets/rating/rating.dart';
import 'package:flutter/material.dart';
import 'package:coursez/model/course.dart';

import '../../utils/fetchData.dart';

class listViewForCourse extends StatefulWidget {
  final double rating;

  const listViewForCourse({super.key, required this.rating});

  @override
  State<listViewForCourse> createState() => _listViewForCourseState();
}

class _listViewForCourseState extends State<listViewForCourse> {
  final List<Course> _course = [];
  bool _isError = false;
  @override
  void initState() {
    super.initState();
    fecthData('course').then((value) {
      setState(() {
        if (value['err'] == null) {
          value['data'].map((e) => _course.add(Course.fromJson(e))).toList();
        } else {
          _isError = true;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return _course.isEmpty
        ? const CircularProgressIndicator(
            color: primaryColor,
          )
        : SingleChildScrollView(
            child: SizedBox(
              height: 160,
              child: ListView.separated(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: _course.length,
                  separatorBuilder: (context, _) => const SizedBox(
                        width: 20,
                      ),
                  itemBuilder: (context, index) =>
                      buildCard(_course[index], widget.rating)),
            ),
          );
  }
}

Widget buildCard(Course item, double rating) {
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
                  color: greyColor,
                  blurRadius: 2,
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
                    fit: BoxFit.fitWidth,
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
