import 'package:coursez/controllers/auth_controller.dart';
import 'package:coursez/model/course.dart';
import 'package:coursez/model/tutor.dart';
import 'package:coursez/model/user.dart';
import 'package:coursez/utils/color.dart';
import 'package:coursez/view_model/course_view_model.dart';
import 'package:coursez/view_model/tutor_view_model.dart';
import 'package:coursez/widgets/Icon/border_icon.dart';
import 'package:coursez/widgets/alert/alert.dart';
import 'package:coursez/widgets/button/button.dart';
import 'package:coursez/widgets/rating/rating.dart';
import 'package:coursez/widgets/text/heading1_24px.dart';
import 'package:coursez/widgets/text/heading2_20px.dart';
import 'package:coursez/widgets/text/title14px.dart';
import 'package:coursez/widgets/videoCard.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:like_button/like_button.dart';

class CoursePage extends StatefulWidget {
  const CoursePage({super.key});

  @override
  State<CoursePage> createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage> {
  final Icon fav = const Icon(Icons.favorite_border);
  final String courseId = Get.parameters['course_id']!;
  late Future<Course> data;
  final AuthController authController = Get.find();
  final CourseViewModel courseViewModel = CourseViewModel();
  final TutorViewModel tutorViewModel = TutorViewModel();
  List paidVideo = [];
  int sumVideoPrice = 0;
  bool isCalPrice = false, isLike = false;
  User teacher = User(
      picture: 'https://www.pngitem.com/pimgs/m/146-1468479_my-profile-icon-blank-profile-picture-circle-hd.png',
      userId: 0,
      email: '',
      fullName: '',
      nickName: '',
      history: [],
      likeCourses: [],
      likeVideos: [],
      paidVideos: [],
      point: 0,
      role: '',
      transactions: []);

  @override
  void initState() {
    data = courseViewModel.loadCourseById(int.parse(courseId));

    if (authController.isLogin) {
      courseViewModel.getPaidVideo().then((value) => setState(
            () => paidVideo.addAll(value),
          ));
    }
    if (authController.isLogin) {
      courseViewModel
          .checkIsLikeCourse(courseId)
          .then((value) => setState(() => isLike = value));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: SafeArea(
            child: SizedBox(
                width: size.width,
                height: size.height,
                child: FutureBuilder(
                  future: data,
                  builder: ((context, snapshot) {
                    if (snapshot.hasData) {
                      tutorViewModel
                          .loadTutorById(snapshot.data!.teacherId.toString())
                          .then((value) => setState(() {
                                teacher = value;
                              }));
                      return SizedBox(
                        child: detail(snapshot.data!),
                      );
                    }
                    return const Center(child: CircularProgressIndicator());
                  }),
                ))));
  }

  Widget detail(Course courseData) {
    final Size size = MediaQuery.of(Get.context!).size;
    const double padding = 15;
    const sidePadding = EdgeInsets.symmetric(horizontal: padding);
    if (!isCalPrice) {
      courseViewModel
          .allVideoPriceInCourse(courseData)
          .then((value) => setState(
                () => sumVideoPrice = value.first,
              ));
      isCalPrice = true;
    }

    return Stack(
      children: [
        SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Image.network(
                    courseData.picture,
                    height: size.height * 0.4,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    top: padding,
                    width: size.width,
                    child: Padding(
                      padding: sidePadding,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              Get.back();
                            },
                            child: const BorderIcon(
                                width: 50,
                                height: 50,
                                child: Icon(
                                  Icons.arrow_back_ios_outlined,
                                  color: primaryColor,
                                )),
                          ),
                          BorderIcon(
                              width: 50,
                              height: 50,
                              child: LikeButton(
                                isLiked: isLike,
                                onTap: (isLiked) async {
                                  isLike = !isLiked;
                                  if (authController.isLogin) {
                                    await courseViewModel
                                        .likeOrUnlikeCourse(courseId);
                                    return !isLiked;
                                  } else {
                                    showDialog(
                                        context: Get.context!,
                                        builder: (BuildContext context) {
                                          return const AlertLogin(
                                            body:
                                                'กรุณาเข้าสู่ระบบเพื่อเพิ่มวีดิโอที่ชอบ',
                                            action: 'เข้าสู่ระบบ',
                                          );
                                        });
                                    return false;
                                  }
                                },
                              ))
                        ],
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: padding,
              ),
              Padding(
                  padding: sidePadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Heading24px(
                        text: courseData.coursename,
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 5),
                            child: RatingStar(
                              rating: courseData.rating,
                              size: 20,
                            ),
                          ),
                          Title14px(
                              text: courseData.rating.toStringAsPrecision(2)),
                        ],
                      ),
                      Row(
                        children: [
                          ClipOval(
                            child: Image.network(
                              teacher.picture,
                              width: 30,
                              height: 30,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          TextButton(
                              onPressed: () {
                                Get.toNamed(
                                    '/tutor/${teacher.userTeacher!.teacherId}');
                              },
                              style: ButtonStyle(
                                padding: MaterialStateProperty.all<EdgeInsets>(
                                    const EdgeInsets.all(0)),
                              ),
                              child: Text(
                                '${teacher.fullName} (${teacher.nickName})',
                                style: const TextStyle(
                                    fontFamily: 'Athiti',
                                    fontSize: 14,
                                    color: greyColor,
                                    decoration: TextDecoration.underline),
                              )),
                        ],
                      ),
                    ],
                  )),
              ExpandablePanel(
                theme: const ExpandableThemeData(
                  iconColor: primaryColor,
                  useInkWell: true,
                  tapBodyToExpand: false,
                  tapBodyToCollapse: true,
                  hasIcon: true,
                  iconSize: 20,
                  headerAlignment: ExpandablePanelHeaderAlignment.center,
                ),
                header: const Padding(
                  padding: sidePadding,
                  child: Title14px(
                    text: 'รายละเอียด',
                  ),
                ),
                collapsed: Padding(
                  padding: sidePadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        courseData.description,
                        style: const TextStyle(
                          fontFamily: 'Athiti',
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                expanded: Padding(
                  padding: sidePadding,
                  child: Text(
                    courseData.description,
                    style: const TextStyle(
                      fontFamily: 'Athiti',
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: padding,
              ),
              Padding(
                padding: sidePadding,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Heading20px(text: "บทเรียน"),
                        if (sumVideoPrice != 0)
                          Bt(
                            text: "ซื้อทั้งหมด $sumVideoPrice บาท",
                            color: primaryColor,
                            onPressed: () {
                              if (!authController.isLogin) {
                                showDialog(
                                    context: Get.context!,
                                    builder: (BuildContext context) {
                                      return const AlertLogin(
                                        body: 'กรุณาเข้าสู่ระบบเพื่อซื้อวีดิโอ',
                                        action: 'เข้าสู่ระบบ',
                                      );
                                    });
                              } else {
                                courseViewModel
                                    .buyAllVideoInCourse(courseData)
                                    .then((value) {
                                  setState(() {
                                    courseViewModel
                                        .allVideoPriceInCourse(courseData)
                                        .then((value) =>
                                            sumVideoPrice = value.first);
                                  });
                                  courseViewModel
                                      .getPaidVideo()
                                      .then((value) => setState(
                                            () => paidVideo = value,
                                          ));
                                });
                              }
                            },
                          )
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Center(
                      child: LayoutBuilder(builder: (context, constraints) {
                        return Wrap(
                            spacing: constraints.maxWidth * 0.02,
                            runSpacing: 12,
                            children: List.generate(
                              courseData.videos.length,
                              ((index) {
                                final bool isPaid = paidVideo
                                    .contains(courseData.videos[index].videoId);
                                return VideoCard(
                                  videoId: courseData.videos[index].videoId,
                                  image: courseData.videos[index].picture,
                                  name: courseData.videos[index].videoName,
                                  width: constraints.maxWidth * 0.3,
                                  height: constraints.maxWidth * 0.3 + 1,
                                  price: courseData.videos[index].price,
                                  isPaid: isPaid,
                                  onTap: () async {
                                    if (!authController.isLogin &&
                                        courseData.videos[index].price > 0) {
                                      debugPrint('please login');
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return const AlertLogin(
                                              body:
                                                  'กรุณาเข้าสู่ระบบเพื่อซื้อวีดิโอ',
                                              action: 'เข้าสู่ระบบ',
                                            );
                                          });
                                    } else {
                                      if (courseData.videos[index].price > 0 &&
                                          !isPaid) {
                                        await courseViewModel.buyVideo(
                                            courseData.videos[index].price,
                                            courseData.videos[index].videoId);
                                        final price = await courseViewModel
                                            .allVideoPriceInCourse(courseData);
                                        final video = await courseViewModel
                                            .getPaidVideo();

                                        setState(() {
                                          sumVideoPrice = price.first;
                                          paidVideo = video;
                                        });
                                      } else {
                                        Get.toNamed(
                                            "/course/$courseId/video/${courseData.videos[index].videoId}",
                                            parameters: {
                                              'video_name': courseData
                                                  .videos[index].videoName,
                                              'teacher_id': courseData.teacherId
                                                  .toString(),
                                            });
                                      }
                                    }
                                  },
                                );
                              }),
                            ));
                      }),
                    )
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
