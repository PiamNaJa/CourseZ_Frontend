import 'package:coursez/utils/color.dart';
import 'package:coursez/view_model/course_view_model.dart';
import 'package:coursez/widgets/text/body10px.dart';
import 'package:coursez/widgets/text/title12px.dart';
import 'package:flutter/rendering.dart';
import 'package:coursez/widgets/rating/rating.dart';
import 'package:flutter/material.dart';
import 'package:coursez/model/course.dart';

class ListViewCourse extends StatelessWidget {
  const ListViewCourse({super.key, required this.rating, required this.level});
  final double rating;
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
              height: 160,
              child: ListView.separated(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: 5,
                  separatorBuilder: (context, _) => const SizedBox(
                        width: 20,
                      ),
                  itemBuilder: (context, index) =>
                      buildCard(snapshot.data[index], rating)),
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
