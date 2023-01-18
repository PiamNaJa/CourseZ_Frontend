import 'package:coursez/widgets/button/textButton.dart';
import 'package:coursez/widgets/listView/listViewForTutor.dart';
import 'package:coursez/utils/color.dart';
import 'package:coursez/widgets/text/heading1_24px.dart';
import 'package:coursez/widgets/text/heading2_20px.dart';
import 'package:flutter/material.dart';
import 'package:coursez/widgets/listView/listViewForCourse.dart';
import 'package:coursez/widgets/carousel/carouselLevel.dart';
import '../widgets/dropdown/dropdown.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Color _prefixIconColor = greyColor;

  @override
  Widget build(BuildContext context) {
    final SelectLevel = dropdown();
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
                      width: MediaQuery.of(context).size.width > 400
                          ? MediaQuery.of(context).size.width * 0.7
                          : MediaQuery.of(context).size.width * 0.4,
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
                        onSubmitted: (value) {},
                        onTap: () {
                          setState(() {
                            _prefixIconColor = primaryColor;
                          });
                        },
                        onChanged: (value) {
                          setState(() {
                            _prefixIconColor = primaryColor;
                          });
                        },
                        onEditingComplete: (() {
                          setState(() {
                            _prefixIconColor = greyColor;
                          });
                        }),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: SizedBox(
                        child: SelectLevel,
                      ),
                    ),
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
                      listViewForCourse(rating: 4.5, level: SelectLevel.level),
                    ],
                  ),
                ),
                Column(children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    child: const Heading20px(text: 'วิชา'),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Container(
                      width: double.infinity,
                      height: 291,
                      decoration: const BoxDecoration(
                        color: whiteColor,
                      ),
                      child: const carouselLevel()),
                  const SizedBox(
                    height: 20,
                  ),
                ]),
                Container(
                  alignment: Alignment.centerLeft,
                  child: const Heading20px(text: 'ติวเตอร์ยอดนิยม'),
                ),
                const SizedBox(
                  height: 12,
                ),
                listViewForTutor(rating: 4, level: SelectLevel.level),
                const SizedBox(
                  height: 200,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
