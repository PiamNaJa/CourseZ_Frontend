import 'package:coursez/controllers/auth_controller.dart';
import 'package:coursez/model/video.dart';
import 'package:coursez/view_model/video_view_model.dart';
import 'package:coursez/widgets/text/body14px.dart';
import 'package:coursez/widgets/text/expandableText.dart';
import 'package:coursez/widgets/text/title16px.dart';
import 'package:flutter/material.dart';
import 'package:coursez/utils/color.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import '../widgets/button/button.dart';
import '../widgets/text/heading2_20px.dart';
import '../widgets/text/title14px.dart';

class ReviewVideoPage extends StatefulWidget {
  const ReviewVideoPage({super.key});

  @override
  State<ReviewVideoPage> createState() => _ReviewVideoPageState();
}

class _ReviewVideoPageState extends State<ReviewVideoPage> {
  VideoViewModel videoViewModel = VideoViewModel();
  AuthController authController = Get.find<AuthController>();
  final String videoId = Get.parameters['video_id']!;
  String courseId = Get.parameters["course_id"]!;
  late Future<Video> data;
  TextEditingController textController = TextEditingController();
  String comment = '';
  double rating = 0.0;

  final formkey = GlobalKey<FormState>();

  onSubmit() {
    if (rating == 0.0 || comment.trim().isEmpty) {
      Get.snackbar('ผิดพลาด', 'กรุณาใส่คะแนนและความคิดเห็น',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: whiteColor);
      return;
    }
    videoViewModel.createReviewVideo(videoId, rating, comment);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          titleSpacing: 0,
          title: const Heading20px(text: "รีวิววิดิโอ"),
          backgroundColor: whiteColor,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: primaryColor),
            onPressed: () {
              Get.back();
            },
          ),
        ),
        body: FutureBuilder(
          future: videoViewModel.loadVideoById(courseId, videoId),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return SingleChildScrollView(
                  child: reviewVideoDetail(snapshot.data!));
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ));
  }

  Widget reviewVideoDetail(Video videoData) {
    return Container(
      padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15, top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            videoData.videoName,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: Image.network(
              videoData.picture,
              fit: BoxFit.cover,
              height: 200,
            ),
          ),
          const SizedBox(height: 10),
          const Title16px(text: 'รายละเอียด'),
          ExpandText(
            text: videoData.description,
            style: const TextStyle(
              fontFamily: 'Athiti',
              fontSize: 14,
            ),
            maxLines: 2,
          ),
          const Divider(
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
                      itemPadding: const EdgeInsets.symmetric(horizontal: 8),
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
    );
  }
}
