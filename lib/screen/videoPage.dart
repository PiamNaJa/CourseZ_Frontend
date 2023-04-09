import 'package:coursez/controllers/auth_controller.dart';
import 'package:coursez/model/reviewVideo.dart';
import 'package:coursez/model/userTeacher.dart';
import 'package:coursez/model/video.dart';
import 'package:coursez/screen/pdfPage.dart';
import 'package:coursez/view_model/exercise_view_model.dart';
import 'package:coursez/view_model/video_view_model.dart';
import 'package:coursez/widgets/rating/rating.dart';
import 'package:coursez/widgets/text/body10px.dart';
import 'package:coursez/widgets/text/body12px.dart';
import 'package:coursez/widgets/text/body14px.dart';
import 'package:coursez/widgets/text/body16.dart';
import 'package:coursez/widgets/text/expandableText.dart';
import 'package:coursez/widgets/text/heading1_24px.dart';
import 'package:coursez/widgets/text/heading2_20px.dart';
import 'package:coursez/widgets/text/title12px.dart';
import 'package:coursez/widgets/text/title16px.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:coursez/utils/color.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:video_player/video_player.dart';
import 'package:coursez/model/user.dart';

class VideoPage extends StatefulWidget {
  const VideoPage({super.key});

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  VideoViewModel videoViewModel = VideoViewModel();
  AuthController authController = Get.find<AuthController>();
  bool isFocus = false;
  double timeToDoQuiz = 0;
  final isExpanded = true;
  bool isInitVideo = false;
  late FlickManager flickManager;
  String videoName = '';
  String teacherId = Get.parameters["teacher_id"] ?? '6';
  String courseId = Get.parameters["course_id"] ?? '9';
  String videoId = Get.parameters["video_id"] ?? '25';
  bool isDoneExercise = false;
  bool loadingTeacher = true;
  User teacher = User(
      email: '',
      fullName: '',
      likeCourses: [],
      likeVideos: [],
      nickName: '',
      picture: '',
      paidVideos: [],
      userTeacher: UserTeacher(
        idCard: '',
      ),
      role: '',
      videoHistory: [],
      point: 0,
      courseHistory: []);

  void _initVideo(String url, String videoName) {
    flickManager = FlickManager(
      videoPlayerController: VideoPlayerController.network(url),
    );
    if (authController.isLogin) {
      final videoController = VideoPlayerController.network(url);

      videoController.initialize().then((value) {
        videoViewModel.getVideoHistoryDuration(videoId).then((value) {
          if (value !=
              flickManager.flickVideoManager!.videoPlayerController!.value
                  .duration.inSeconds) {
            videoController.seekTo(Duration(seconds: value));
            flickManager.handleChangeVideo(videoController);
          }
        });
      });
    }
    flickManager.flickVideoManager!.videoPlayerController!.addListener(() {
      timeToDoQuiz = flickManager.flickVideoManager!.videoPlayerController!
              .value.duration.inSeconds *
          0.9;
    });
    videoName = videoName;
  }

  @override
  void initState() {
    isInitVideo = true;
    videoViewModel.getTeacherName(int.parse(teacherId)).then((value) {
      setState(() {
        teacher = value;
        loadingTeacher = false;
      });
      if (authController.isLogin) {
        ExerciseViewModel().isDoneExercise(courseId, videoId).then((value) {
          setState(() {
            isDoneExercise = value;
          });
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    if (authController.isLogin) {
      videoViewModel
          .addVideoHistory(
              videoId,
              flickManager.flickVideoManager!.videoPlayerController!.value
                  .position.inSeconds)
          .then((value) => flickManager.dispose());
    } else {
      flickManager.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: whiteColor.withOpacity(0.95),
        appBar: AppBar(
          elevation: 0.0,
          titleSpacing: 0,
          title: Heading20px(text: videoName),
          backgroundColor: whiteColor,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: primaryColor),
            onPressed: () {
              Get.back();
            },
          ),
        ),
        body: loadingTeacher || !isInitVideo
            ? const Center(child: CircularProgressIndicator())
            : FutureBuilder(
                future: videoViewModel.loadVideoById(courseId, videoId),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    _initVideo(snapshot.data!.url, snapshot.data!.videoName);
                    return videoDetail(snapshot.data!);
                  }
                  return const Center(child: CircularProgressIndicator());
                }));
  }

  Widget videoDetail(Video video) {
    double tutorRating = videoViewModel.getTutorRating(teacher.userTeacher!);
    double videoRating = videoViewModel.loadVideoRating(video);
    FlickVideoWithControls flickVideoWithControls = FlickVideoWithControls(
      controls: FlickPortraitControls(
        progressBarSettings: FlickProgressBarSettings(
          playedColor: primaryColor,
          bufferedColor: primaryLighterColor.withOpacity(0.8),
          handleColor: primaryColor,
        ),
      ),
      iconThemeData: const IconThemeData(color: primaryColor),
    );
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 200,
            width: double.infinity,
            child: FlickVideoPlayer(
                flickManager: flickManager,
                flickVideoWithControls: flickVideoWithControls,
                flickVideoWithControlsFullscreen: flickVideoWithControls),
          ),
          Container(
            padding:
                const EdgeInsets.only(left: 15, right: 15, bottom: 15, top: 10),
            decoration: const BoxDecoration(
              color: whiteColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Title16px(text: 'รายละเอียด'),
                ExpandText(
                    text: video.description,
                    style: const TextStyle(
                      fontFamily: 'Athiti',
                      fontSize: 14,
                    ),
                    maxLines: 2),
                Body12px(
                  text:
                      'เผยแพร่เมื่อ ${videoViewModel.formatVideoDate(video.createdAt)}',
                  color: greyColor,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 70,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.assignment,
                  color: primaryColor,
                  size: 30,
                ),
                TextButton(
                    onPressed: () {
                      flickManager.flickControlManager!.pause();
                      Get.to(() =>
                          PDFPage(path: video.sheet, name: video.videoName));
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 3),
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Title16px(
                        text: 'เอกสารประกอบการเรียน',
                        color: whiteColor,
                      ),
                    ))
              ],
            ),
          ),
          Container(
              color: whiteColor,
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Title16px(text: 'Smart Focus'),
                      Switch(
                          value: isFocus,
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          activeColor: primaryColor,
                          onChanged: (bool value) {
                            setState(() {
                              isFocus = value;
                            });
                          })
                    ],
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: const Text(
                      'เทคโนโลยีที่จะช่วยคุณให้การเรียนของคุณมีประสิทธิภาพที่ดีขึ้น ด้วยระบบ AI ตรวจจับพฤติกรรมระหว่างเรียน',
                      style: TextStyle(fontFamily: 'Athiti', fontSize: 10),
                    ),
                  )
                ],
              )),
          const SizedBox(
            height: 15,
          ),
          Container(
            padding: const EdgeInsets.all(15),
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Heading20px(text: 'ทำแบบทดสอบหลังเรียนได้นี่'),
                    Heading20px(
                      text: '*',
                      color: tertiaryColor,
                    )
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  height: 40,
                  decoration: BoxDecoration(
                      border: Border.all(color: greyColor),
                      borderRadius: BorderRadius.circular(10)),
                  child: !isDoneExercise
                      ? Obx(() {
                          return authController.isLogin
                              ? Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                        child:
                                            Title12px(text: video.videoName)),
                                    TextButton(
                                        onPressed: () {
                                          if (flickManager
                                                  .flickVideoManager!
                                                  .videoPlayerController!
                                                  .value
                                                  .position
                                                  .inSeconds >=
                                              timeToDoQuiz) {
                                            debugPrint('pass');
                                            flickManager.flickControlManager!
                                                .pause();
                                            Get.toNamed(
                                                '/course/${Get.parameters["course_id"]!}/video/${video.videoId}/exercise');
                                          } else {
                                            showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title: const Heading24px(
                                                        text: 'แจ้งเตือน'),
                                                    content: const Text(
                                                      'คุณยังไม่ได้เรียนคลิปให้จบ กรุณาเรียนคลิปให้จบก่อนทำแบบทดสอบ',
                                                      style: TextStyle(
                                                        fontFamily: 'Athiti',
                                                        fontSize: 16,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child:
                                                              const Title12px(
                                                            text: 'ตกลง',
                                                            color: primaryColor,
                                                          ))
                                                    ],
                                                  );
                                                });
                                          }
                                        },
                                        child: const Text(
                                          'ทำแบบทดสอบ',
                                          style: TextStyle(
                                              fontFamily: 'Athiti',
                                              fontSize: 12,
                                              color: blackColor,
                                              fontWeight: FontWeight.bold,
                                              height: 1.5,
                                              decoration:
                                                  TextDecoration.underline),
                                        ))
                                  ],
                                )
                              : Center(
                                  child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Title12px(
                                        text: "เข้าสู่ระบบเพื่อทำแบบทดสอบ"),
                                    TextButton(
                                        onPressed: () {
                                          flickManager.flickControlManager!
                                              .pause();
                                          Get.toNamed('/login');
                                        },
                                        child: const Text(
                                          'คลิกที่นี่เพื่อเข้าสู่ระบบ',
                                          style: TextStyle(
                                              fontFamily: 'Athiti',
                                              fontSize: 12,
                                              color: blackColor,
                                              fontWeight: FontWeight.bold,
                                              height: 1.5,
                                              decoration:
                                                  TextDecoration.underline),
                                        )),
                                  ],
                                ));
                        })
                      : const Center(
                          child:
                              Title12px(text: "คุณทำแบบทดสอบหลังเรียนนี้แล้ว")),
                ),
                const Padding(
                  padding: EdgeInsets.all(5),
                  child: Body10px(
                    text:
                        '*นักเรียนจะต้องเรียนคลิปให้จบก่อนจึงจะสามารถทำแบบทดสอบได้',
                    color: tertiaryColor,
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                InkWell(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: blackColor.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            teacher.picture,
                            width: 45,
                            height: 45,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.03),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Title16px(text: teacher.fullName),
                            Body12px(text: teacher.nickName),
                          ],
                        ),
                        Expanded(
                            child: (tutorRating != 0)
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      RatingStar(rating: tutorRating, size: 17),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Body14px(
                                          text: tutorRating
                                              .toStringAsPrecision(2)),
                                    ],
                                  )
                                : const Body12px(
                                    text: 'ยังไม่มีคะแนน',
                                    color: tertiaryColor,
                                  )),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(right: 5),
                            child: Heading20px(text: 'รีวิว'),
                          ),
                          Body16px(
                            text: '(${video.reviews.length})',
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.15,
                                  height:
                                      MediaQuery.of(context).size.width * 0.15,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: primaryColor, width: 2),
                                      shape: BoxShape.circle),
                                  child: Center(
                                    child: (videoRating != 0)
                                        ? Heading24px(
                                            text: videoRating
                                                .toStringAsPrecision(2),
                                            color: primaryColor,
                                          )
                                        : const Heading24px(
                                            text: '-',
                                            color: primaryColor,
                                          ),
                                  ),
                                ),
                                (video.reviews.isNotEmpty)
                                    ? Body12px(
                                        text:
                                            '${video.reviews.length.toString()} รีวิว')
                                    : const Body12px(text: 'ยังไม่มีรีวิว'),
                                (videoRating != 0)
                                    ? RatingStar(
                                        rating: videoRating,
                                        size: 15,
                                      )
                                    : const Body12px(
                                        text: 'ยังไม่มีคะแนน',
                                        color: greyColor),
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
                                            MediaQuery.of(context).size.width *
                                                0.4,
                                        lineHeight: 6,
                                        percent: videoViewModel
                                            .loadPercentRating(video, 5 - i),
                                        backgroundColor: greyColor,
                                        progressColor: primaryColor,
                                        barRadius: const Radius.circular(15),
                                      ),
                                      Body12px(
                                          text:
                                              '${videoViewModel.loadVideoRatingByStar(video, 5 - i)}')
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
                      (video.reviews.isEmpty)
                          ? const Center(
                              child: Title16px(
                                text: 'ยังไม่มีรีวิว',
                                color: greyColor,
                              ),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: video.reviews.length,
                              itemBuilder: (context, index) {
                                return reviewCard(video.reviews[index]);
                              },
                            ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget reviewCard(ReviewVideo review) {
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
              RatingStar(rating: review.rating, size: 15),
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
                text: '${videoViewModel.formatReviewDate(review.createdAt)} น.',
                color: greyColor,
              ),
            ],
          ),
        ));
  }
}
