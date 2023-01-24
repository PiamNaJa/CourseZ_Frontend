import 'package:coursez/controllers/level_controller.dart';
import 'package:coursez/widgets/button/textButton.dart';
import 'package:coursez/widgets/listView/listViewForCourse.dart';
import 'package:coursez/widgets/listView/listViewForTutor.dart';
import 'package:coursez/utils/color.dart';
import 'package:coursez/widgets/text/heading1_24px.dart';
import 'package:coursez/widgets/text/heading2_20px.dart';
import 'package:flutter/material.dart';
import 'package:coursez/widgets/carousel/carouselLevel.dart';
import 'package:get/get.dart';
import '../widgets/dropdown/dropdown.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Color _prefixIconColor = greyColor;

  @override
  Widget build(BuildContext context) {
    LevelController levelController = Get.put(LevelController());
    return Scaffold(
      body: NestedScrollView(
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
              title: const Heading24px(text: 'ยินดีต้อนรับสู่ CourseZ'),
            ),
          ];
        },
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      height: 50,
                      child: TextField(
                        style: const TextStyle(fontFamily: 'Athiti'),
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
                            borderSide: BorderSide(color: primaryColor),
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
                      width: MediaQuery.of(context).size.width * 0.05,
                    ),
                    const Dropdown() ,
                    // const listView()
                  ],
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Heading20px(text: 'คอร์สยอดนิยม'),
                          ButtonText(
                              text: 'ดูเพิ่มเติม >',
                              color: greyColor,
                              size: 16,
                              position: TextAlign.right,
                              route: ''),
                        ],
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Obx(()=> ListViewCourse(rating: 4.5, level: levelController.level)),
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: const Heading20px(text: 'วิชา'),
                ),
                const SizedBox(
                  height: 12,
                ),
                const CarouselLevel(),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: const Heading20px(text: 'ติวเตอร์ยอดนิยม'),
                ),
                const SizedBox(
                  height: 12,
                ),
                Obx(()=> ListViewTutor(rating: 4, level: levelController.level)) ,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
