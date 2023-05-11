import 'package:coursez/model/reviewTutor.dart';
import 'package:coursez/view_model/tutor_view_model.dart';
import 'package:coursez/widgets/rating/rating.dart';
import 'package:coursez/widgets/text/body12px.dart';
import 'package:coursez/widgets/text/expandableText.dart';
import 'package:coursez/widgets/text/heading1_24px.dart';
import 'package:coursez/widgets/text/heading2_20px.dart';
import 'package:coursez/widgets/text/title16px.dart';
import 'package:flutter/material.dart';
import 'package:coursez/utils/color.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:coursez/model/user.dart';
import '../widgets/button/button.dart';

class ViewReviewTutorPage extends StatefulWidget {
  const ViewReviewTutorPage({super.key});

  @override
  State<ViewReviewTutorPage> createState() => _ViewReviewTutorPageState();
}

class _ViewReviewTutorPageState extends State<ViewReviewTutorPage> {
  String? teacherId = Get.parameters["teacher_id"];
  final tutor = Get.arguments;
  TutorViewModel tutorViewModel = TutorViewModel();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: whiteColor.withOpacity(0.95),
        appBar: AppBar(
          elevation: 0.0,
          titleSpacing: 0,
          title: Heading20px(text: tutor.nickname),
          backgroundColor: whiteColor,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: primaryColor),
            onPressed: () {
              Get.back();
            },
          ),
        ),
        body: FutureBuilder(
          future: tutorViewModel.loadTutorById(teacherId.toString()),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              return SingleChildScrollView(
                  child: reviewsIndicator(
                      snapshot.data!.userTeacher!.reviews, snapshot.data!));
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ));
  }

  Widget reviewsIndicator(List<ReviewTutor>? reviews, User tutor) {
    double tutorRating = tutorViewModel.getTutorRating(tutor);
    return Container(
      padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15, top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.15,
                      height: MediaQuery.of(context).size.width * 0.15,
                      decoration: BoxDecoration(
                          border: Border.all(color: primaryColor, width: 2),
                          shape: BoxShape.circle),
                      child: Center(
                        child: (tutorRating != 0)
                            ? Heading24px(
                                text: tutorRating.toStringAsPrecision(2),
                                color: primaryColor,
                              )
                            : const Heading24px(
                                text: '-',
                                color: primaryColor,
                              ),
                      ),
                    ),
                    (tutor.userTeacher!.reviews!.isNotEmpty)
                        ? Body12px(
                            text:
                                '${tutor.userTeacher!.reviews!.length.toString()} รีวิว')
                        : const Body12px(text: 'ยังไม่มีรีวิว'),
                    (tutorRating != 0)
                        ? RatingStar(
                            rating: tutorRating,
                            size: 15,
                          )
                        : const Body12px(
                            text: 'ยังไม่มีคะแนน', color: greyColor),
                  ],
                ),
                Column(
                  children: [
                    for (int i = 0; i < 5; i++)
                      Row(
                        children: [
                          RatingStar(
                            rating: 5 - i.toDouble(),
                            size: 15,
                          ),
                          LinearPercentIndicator(
                            width: MediaQuery.of(context).size.width * 0.4,
                            lineHeight: 6,
                            percent:
                                tutorViewModel.loadPercentRating(tutor, 5 - i),
                            backgroundColor: greyColor,
                            progressColor: primaryColor,
                            barRadius: const Radius.circular(15),
                          ),
                          Body12px(
                              text:
                                  '${tutorViewModel.loadTutorRatingByStar(tutor, 5 - i)}')
                        ],
                      )
                  ],
                )
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          (tutor.userTeacher!.reviews!.isEmpty)
              ? const Center(
                  child: Title16px(
                    text: 'ยังไม่มีรีวิว',
                    color: greyColor,
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: tutor.userTeacher!.reviews!.length,
                  itemBuilder: (context, index) {
                    List<ReviewTutor> sortedReviews =
                        tutor.userTeacher!.reviews!;
                    sortedReviews
                        .sort((a, b) => b.createdAt.compareTo(a.createdAt));
                    return reviewCard(sortedReviews[index]);
                  },
                ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Bt(
                    text: "รีวิว${tutor.nickName}",
                    color: secondaryColor,
                    onPressed: () {
                      Get.toNamed(
                        "/teacher/${tutor.userTeacher!.teacherId}/review",
                        arguments: tutor,
                      )?.then((value) {
                        setState(() {});
                      });
                    },
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget reviewCard(ReviewTutor review) {
    return Padding(
        padding: const EdgeInsets.all(5),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: blackColor.withOpacity(0.05),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RatingStar(rating: review.rating.toDouble(), size: 15),
              Padding(
                  padding: const EdgeInsets.only(top: 5, bottom: 5),
                  child: ExpandText(
                      text: review.comment,
                      style: const TextStyle(
                        fontFamily: 'Athiti',
                        fontSize: 14,
                      ),
                      maxLines: 1)),
              Body12px(
                text: '${tutorViewModel.formatReviewDate(review.createdAt)} น.',
                color: greyColor,
              ),
            ],
          ),
        ));
  }
}
