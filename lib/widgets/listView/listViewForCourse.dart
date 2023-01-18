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
  final int level;
  const listViewForCourse(
      {super.key, required this.rating, required this.level});

  @override
  State<listViewForCourse> createState() => _listViewForCourseState();
}

class _listViewForCourseState extends State<listViewForCourse> {
  final List<Course> _course = [];
  List<Course> _courseLevel = [];
  bool _isError = false;
  @override
  void initState() {
    super.initState();
    fecthData('course/Teacher').then((value) {
      setState(() {
        if (value['err'] == null) {
          value['data'].map((e) => _course.add(Course.fromJson(e))).toList();
          debugPrint(widget.level.toString());
        } else {
          _isError = true;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      if (widget.level != 0) {
        _courseLevel = _course
            .where((element) => element.subject?.classLevel == widget.level)
            .toList();
      } else {
        _courseLevel = _course;
      }
    });

    return _courseLevel.isEmpty
        ? const CircularProgressIndicator(
            color: primaryColor,
          )
        : SingleChildScrollView(
            child: SizedBox(
              height: 160,
              child: ListView.separated(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: 5,
                  separatorBuilder: (context, _) => const SizedBox(
                        width: 20,
                      ),
                  itemBuilder: (context, index) =>
                      buildCard(_courseLevel[index], widget.rating)),
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
