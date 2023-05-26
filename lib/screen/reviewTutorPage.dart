import 'package:coursez/controllers/auth_controller.dart';
import 'package:coursez/view_model/tutor_view_model.dart';
import 'package:coursez/widgets/rating/rating.dart';
import 'package:coursez/widgets/text/body12px.dart';
import 'package:coursez/widgets/text/body14px.dart';
import 'package:coursez/utils/fetchData.dart';
import 'package:coursez/widgets/text/expandableText.dart';
import 'package:coursez/widgets/text/heading2_20px.dart';
import 'package:coursez/widgets/text/title16px.dart';
import 'package:flutter/material.dart';
import 'package:coursez/utils/color.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:coursez/model/user.dart';
import 'package:coursez/widgets/button/button.dart';
import 'package:coursez/widgets/text/title14px.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../widgets/text/heading1_24px.dart';

class ReviewTutorPage extends StatefulWidget {
  const ReviewTutorPage({super.key});

  @override
  State<ReviewTutorPage> createState() => _ReviewTutorPageState();
}

class _ReviewTutorPageState extends State<ReviewTutorPage> {
  String teacherId = Get.parameters["teacher_id"] ?? '';
  final tutor = Get.arguments;
  String comment = '';
  double rating = 0.0;
  AuthController authController = Get.find<AuthController>();
  TutorViewModel tutorViewModel = TutorViewModel();

  onSubmit() {
    if (rating == 0.0 || comment.trim().isEmpty) {
      Get.snackbar('ผิดพลาด', 'กรุณาใส่คะแนนและความคิดเห็น',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: whiteColor);
      return;
    }
    tutorViewModel.createReviewTutor(teacherId, rating, comment);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: whiteColor.withOpacity(0.95),
        appBar: AppBar(
          elevation: 0.0,
          titleSpacing: 0,
          title: Heading20px(text: "รีวิว" + tutor.nickName),
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
              return SingleChildScrollView(child: tutorDetail(snapshot.data!));
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ));
  }

  Widget tutorDetail(User tutor) {
    double tutorRating = tutorViewModel.getTutorRating(tutor);
    return Container(
        padding:
            const EdgeInsets.only(left: 15, right: 15, bottom: 15, top: 10),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
              height: MediaQuery.of(Get.context!).size.height * 0.15,
              decoration: BoxDecoration(
                  color: whiteColor,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ]),
              margin: EdgeInsets.only(
                  top: 10,
                  left: MediaQuery.of(Get.context!).size.width * 0.01,
                  right: MediaQuery.of(Get.context!).size.width * 0.01),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.network(
                        tutor.picture,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Expanded(
                        child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Heading20px(text: tutor.fullName),
                          Title14px(text: tutor.nickName),
                        ],
                      ),
                    )),
                  ],
                ),
              )),
          Container(
            padding:
                const EdgeInsets.only(left: 5, right: 5, bottom: 10, top: 10),
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
                                border:
                                    Border.all(color: primaryColor, width: 2),
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
                                  width:
                                      MediaQuery.of(context).size.width * 0.4,
                                  lineHeight: 6,
                                  percent: tutorViewModel.loadPercentRating(
                                      tutor, 5 - i),
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
                    : const Divider(
                        height: 20,
                        thickness: 2,
                        color: Color.fromARGB(255, 199, 197, 197),
                      ),
                ListTile(
                  tileColor: blackColor.withOpacity(0.05),
                  leading: ClipOval(
                    child: authController.isLogin
                        ? Image.network(
                            authController.picture,
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            width: 40,
                            height: 40,
                            color: greyColor,
                          ),
                  ),
                  title: authController.isLogin
                      ? Title14px(text: authController.username)
                      : const Title14px(text: 'ผู้เข้าชม'),
                  subtitle: authController.isLogin
                      ? authController.role == 'Teacher' ||
                              authController.role == 'Tutor'
                          ? const Body14px(text: 'คุณครู')
                          : const Body14px(text: 'นักเรียน')
                      : const Body14px(text: 'ผู้เข้าชม'),
                ),
                const SizedBox(height: 10),
                Padding(
                    padding: const EdgeInsets.only(top: 5, bottom: 5),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        const Title14px(text: 'ให้คะเเนนวิดิโอนี้ :'),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: RatingBar.builder(
                            initialRating: rating,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemSize: 30,
                            itemPadding:
                                const EdgeInsets.symmetric(horizontal: 8),
                            itemBuilder: (context, _) => const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (value) {
                              setState(() {
                                rating = value;
                              });
                            },
                          ),
                        )
                      ],
                    )),
                const SizedBox(height: 20),
                TextField(
                  decoration: const InputDecoration(
                    focusColor: primaryColor,
                    contentPadding: EdgeInsets.only(left: 10, right: 10),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: greyColor),
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    hintText: 'เขียนรีวิวของคุณ',
                    hintStyle: TextStyle(
                        fontFamily: 'Athiti', fontSize: 14, color: greyColor),
                  ),
                  style: const TextStyle(
                      fontFamily: 'Athiti', fontSize: 14, color: blackColor),
                  onChanged: (value) {
                    comment = value;
                  },
                ),
                const Divider(
                  color: secondaryColor,
                  thickness: 1.5,
                ),
                Container(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Bt(
                              text: "ยืนยัน",
                              color: primaryColor,
                              onPressed: onSubmit),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          )
        ]));
  }
}
