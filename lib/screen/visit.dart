import 'package:coursez/widgets/alert/alert.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'dart:io';
import 'package:coursez/controllers/auth_controller.dart';
import 'package:coursez/controllers/refresh_controller.dart';
import 'package:coursez/model/video.dart';
import 'package:coursez/utils/color.dart';
import 'package:coursez/view_model/auth_view_model.dart';
import 'package:coursez/view_model/course_view_model.dart';
import 'package:coursez/view_model/post_view_model.dart';
import 'package:coursez/view_model/profile_view_model.dart';
import 'package:coursez/widgets/button/button.dart';
import 'package:coursez/widgets/text/body12px.dart';
import 'package:coursez/widgets/text/body14px.dart';
import 'package:coursez/widgets/text/heading2_20px.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_launcher_icons/xml_templates.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:coursez/utils/inputDecoration.dart';
import 'package:intl/intl.dart';
import '../model/course.dart';
import '../model/user.dart';
import '../view_model/chat_view_model.dart';
import '../view_model/tutor_view_model.dart';
import '../widgets/rating/rating.dart';
import '../widgets/text/title14px.dart';
import '../widgets/text/title16px.dart';

class VisitPage extends StatefulWidget {
  const VisitPage({super.key});

  @override
  State<VisitPage> createState() => _VisitPageState();
}

class _VisitPageState extends State<VisitPage> {
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  final AuthViewModel authViewModel = AuthViewModel();
  final CourseViewModel courseViewModel = CourseViewModel();
  final TutorViewModel tutorViewModel = TutorViewModel();
  final AuthController authController = Get.find<AuthController>();
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  final RefreshController refreshController = Get.find<RefreshController>();

  Widget notLoginUI() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("กรุณาเข้าสู่ระบบเพื่อดูรายละเอียดโปรไฟล์"),
          const SizedBox(
            height: 15,
          ),
          Bt(
            onPressed: () {
              Get.toNamed('/login');
            },
            text: "ลงทะเบียน / เข้าสู่ระบบ",
            color: primaryColor,
          )
        ],
      ),
    );
  }

  User users = User(
      email: '',
      password: '',
      fullName: '',
      nickName: '',
      role: '',
      picture: '',
      point: 0,
      likeCourses: [],
      likeVideos: [],
      paidVideos: [],
      videoHistory: [],
      courseHistory: []);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        titleSpacing: 0,
        title: const Heading20px(text: "โปรไฟล์"),
        backgroundColor: whiteColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: primaryColor),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      key: _globalKey,
      body: FutureBuilder(
        future: tutorViewModel.loadTutorById(Get.parameters["teacher_id"]!),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return showprofile(snapshot.data);
          } else {
            return const Center(
                child: CircularProgressIndicator(
              color: primaryColor,
            ));
          }
        },
      ),
    );
  }

  Widget showprofile(User user) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [],
        ),
        Container(
          decoration: const BoxDecoration(
            color: Colors.transparent,
          ),
          child: Center(
              child: user.picture.isNotEmpty
                  ? Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: Container(
                              decoration: const BoxDecoration(boxShadow: [
                                BoxShadow(
                                    color: greyColor,
                                    blurRadius: 10, // shadow radius
                                    offset: Offset(4, 1), // shadow offset
                                    spreadRadius:
                                        0.1, // The amount the box should be inflated prior to applying the blur
                                    blurStyle: BlurStyle.normal)
                              ]),
                              child: ClipRRect(
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(10.0)),
                                child: Image.network(
                                  user.picture,
                                  height: 100,
                                  width: 100,
                                  fit: BoxFit.cover,
                                ),
                              )),
                        ),
                      ],
                    )
                  : InkWell(
                      onTap: () {
                        // pickImage();
                      },
                      child: Container(
                        height: 100,
                        decoration: const BoxDecoration(
                            color: greyColor, shape: BoxShape.circle),
                        child: const Center(
                          child: Icon(
                            Icons.person,
                            size: 50,
                          ),
                        ),
                      ),
                    )),
        ),
        Title16px(text: user.nickName),
        Title14px(
          text: 'ชื่อ: ${user.fullName}',
          color: greyColor,
        ),
        Title14px(
          text: 'อีเมล: ${user.email}',
          color: greyColor,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 10,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Column(
                  children: [
                    Title16px(
                        text: user.userTeacher!.courses!.length.toString()),
                    const Title14px(
                      text: 'คอร์ส',
                      color: greyColor,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    FutureBuilder(
                        future: PostViewModel().loadPostByUserId(user.userId!),
                        builder: (context, AsyncSnapshot snapshot) {
                          if (snapshot.hasData) {
                            return Title16px(
                                text: snapshot.data.length.toString());
                          } else {
                            return const Center(
                                child: CircularProgressIndicator(
                              color: primaryColor,
                            ));
                          }
                        }),
                    const Title14px(
                      text: 'โพสต์',
                      color: greyColor,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Title16px(
                        text: user.userTeacher!.reviews!.length.toString()),
                    const Title14px(
                      text: 'รีวิว',
                      color: greyColor,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Bt(
                  text: "รีวิว",
                  color: tertiaryColor,
                  onPressed: (() {
                    if (authController.isLogin) {
                      Get.toNamed('');
                    } else {
                      showDialog(
                          context: context,
                          builder: ((context) {
                            return const AlertLogin(
                              body: "กรุณาเข้าสู้ระบบก่อนรีวิว",
                              action: "เช้าสู้ระบบ",
                            );
                          }));
                    }
                  })),
              Bt(
                  text: "แชท",
                  color: primaryColor,
                  onPressed: (() {
                    if (authController.isLogin) {
                      final ChatViewModel chatViewModel = ChatViewModel();
                      chatViewModel.newInbox(user.userId!);
                    } else {
                      showDialog(
                          context: context,
                          builder: ((context) {
                            return const AlertLogin(
                              body: "กรุณาเข้าสู้ระบบก่อนรีวิว",
                              action: "เช้าสู้ระบบ",
                            );
                          }));
                    }
                  }))
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [Title16px(text: "คอร์สของ ${user.nickName}")],
          ),
        ),
        courseprofile(user.userTeacher!.courses!)
      ],
    );
  }

  Widget courseprofile(List<Course> data) {
    if (data.isEmpty) {
      return Center(
          child: Title16px(
        text: 'ติวเตอร์ขี้เกียจสอนเลยไม่มีคอร์ส',
        color: greyColor,
      ));
    }
    return Expanded(
      child: GridView(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 16 / 14.5,
        ),
        children: data
            .map((e) => InkWell(
                  onTap: () {
                    Get.toNamed(
                      '/course/${e.courseId}',
                    );
                  },
                  child: Container(
                    width: 160,
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: whiteColor,
                        border: Border.all(color: greyColor, width: 0.6),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(
                            color: greyColor,
                            blurRadius: 5,
                            offset: Offset(0, 1),
                          )
                        ]),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: Image.network(
                            e.picture,
                            width: double.infinity,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 8.0,
                            top: 8.0,
                            right: 8.0,
                          ),
                          child: Title14px(text: e.coursename),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 8.0, bottom: 8.0),
                          child: (e.rating != 0)
                              ? RatingStar(
                                  rating: e.rating,
                                  size: 20,
                                )
                              : const Body14px(
                                  text: 'ยังไม่มีคะแนน',
                                  color: greyColor,
                                ),
                        )
                      ],
                    ),
                  ),
                ))
            .toList(),
      ),
    );
  }
}
