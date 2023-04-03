import 'package:coursez/controllers/auth_controller.dart';
import 'package:coursez/controllers/level_controller.dart';
import 'package:coursez/model/course.dart';
import 'package:coursez/view_model/course_view_model.dart';
import 'package:coursez/view_model/tutor_view_model.dart';
import 'package:coursez/widgets/button/textbutton.dart';
import 'package:coursez/widgets/listView/listTileTutor.dart';
import 'package:coursez/widgets/listView/listViewForCourse.dart';
import 'package:coursez/widgets/listView/listViewForTutor.dart';
import 'package:coursez/utils/color.dart';
import 'package:coursez/widgets/rating/rating.dart';
import 'package:coursez/widgets/text/body10px.dart';
import 'package:coursez/widgets/text/heading1_24px.dart';
import 'package:coursez/widgets/text/heading2_20px.dart';
import 'package:coursez/widgets/text/title12px.dart';
import 'package:flutter/material.dart';
import 'package:coursez/widgets/carousel/carouselLevel.dart';
import 'package:get/get.dart';
import '../widgets/button/button.dart';
import '../widgets/dropdown/dropdown.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Color _prefixIconColor = greyColor;
  final CourseViewModel courseViewModel = CourseViewModel();
  final TutorViewModel tutorViewModel = TutorViewModel();
  final LevelController levelController = Get.find<LevelController>();
  final AuthController _authController = Get.find<AuthController>();
  late final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _scrollController.addListener(() {});
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scollToTop() {
    _scrollController.animateTo(0,
        duration: const Duration(milliseconds: 500), curve: Curves.linear);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: NestedScrollView(
          controller: _scrollController,
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                flexibleSpace: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: <Color>[
                        primaryDarkColor,
                        secondaryColor,
                      ],
                    ),
                  ),
                ),
                collapsedHeight: 60,
                expandedHeight: 60,
                floating: false,
                centerTitle: true,
                title: Obx(() => Heading24px(
                    text: _authController.isLogin
                        ? 'สวัสดีคุณ ${_authController.username}'
                        : 'ยินดีต้อนรับสู่ CourseZ')),
              ),
            ];
          },
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.5,
                        height: 50,
                        child: TextField(
                          style: const TextStyle(fontFamily: 'Athiti'),
                          readOnly: true,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.zero,
                            prefixIcon: Icon(
                              Icons.search,
                              color: _prefixIconColor,
                            ),
                            hintText: 'ค้นหา',
                            border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25.0)),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: greyColor),
                              borderRadius: BorderRadius.all(
                                Radius.circular(25.0),
                              ),
                            ),
                          ),
                          onTap: () {
                            Navigator.pushNamed(context, '/search');
                          },
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.03,
                      ),
                      const Dropdown(),
                      // const listView()
                    ],
                  ),
                  Container(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child: Obx(
                        () => Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Heading20px(text: 'คอร์สเรียนยอดนิยม'),
                                ButtonText(
                                  text: 'ดูเพิ่มเติม >',
                                  color: greyColor,
                                  size: 16,
                                  position: TextAlign.right,
                                  data: courseViewModel
                                      .loadCourse(levelController.level),
                                  route: '/expand',
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            const ListViewCourse(recommend: false),
                            const SizedBox(
                              height: 12,
                            ),
                            if (_authController.isLogin) ...[
                              Row(
                                children: const [
                                  Heading20px(text: 'คอร์สเรียนแนะนำสำหรับคุณ'),
                                ],
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              const ListViewCourse(recommend: true),
                            ]
                          ],
                        ),
                      )),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: const Heading20px(text: 'วิชา'),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  const CarouselLevel(),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(bottom: 15),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Heading20px(text: 'ติวเตอร์ยอดนิยม'),
                            Obx(
                              () => ButtonText(
                                text: 'ดูเพิ่มเติม >',
                                color: greyColor,
                                size: 16,
                                position: TextAlign.right,
                                data: tutorViewModel
                                    .loadTutor(levelController.level),
                                route: '/expand',
                              ),
                            )
                          ],
                        ),
                        Obx(() => ListViewTutor(level: levelController.level)),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 1,
                    width: double.infinity,
                    color: greyColor,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Heading20px(text: 'ติวเตอร์ของเรา'),
                      const SizedBox(
                        height: 12,
                      ),
                      ListTileTutor()
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Bt(
                            text: "Myreward",
                            color: secondaryColor,
                            onPressed: () {
                              Get.toNamed("/reward");
                            },
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _scollToTop,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(16.0),
            ),
          ),
          backgroundColor: primaryColor,
          mini: true,
          tooltip: 'Back to top',
          child: const Icon(
            Icons.keyboard_arrow_up,
            size: 20,
          ),
        ));
  }
}
