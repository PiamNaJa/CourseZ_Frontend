import 'package:coursez/widgets/listView/listViewForTutor.dart';
import 'package:coursez/utils/color.dart';
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
  final List<String> items = ['Item1', 'Item2', 'Item3'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 90,
          elevation: 0.0,
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
          //set title center
          centerTitle: true,
          title: const Text(
            'ยินดีต้อนรับสู่ CourseZ',
            style: TextStyle(
                fontFamily: 'Athiti',
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: blackColor),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 170,
                      height: 50,
                      child: TextField(
                        style: const TextStyle(fontFamily: 'Athiti'),
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.zero,
                          prefixIcon: Icon(
                            Icons.search,
                            // color: greyColor,
                          ),
                          hintText: 'search',
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(25.0)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: primaryColor),
                            borderRadius: BorderRadius.all(
                              Radius.circular(25.0),
                            ),
                          ),
                        ),
                        onSubmitted: (value) {},
                        // onChanged: (value) {
                        //   setState(() {
                        //     _prefixIconColor = primaryColor;
                        //   });
                        // },
                        // onEditingComplete: (() {
                        //   setState(() {
                        //     _prefixIconColor = greyColor;
                        //   });
                        // }),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        child: dropdown(
                          items: const [
                            'ระดับชั้นทั้งหมด',
                            'ม.1',
                            'ม.2',
                            'ม.3',
                            'ม.4',
                            'ม.5',
                            'ม.6',
                            'มหาวิทยาลัย',
                          ],
                          selectedItem: 'ระดับชั้นทั้งหมด',
                        ),
                      ),
                    ),
                    // const listView()
                  ],
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        child: const Heading20px(text: 'คอร์สยอดนิยม'),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      const listViewForCourse(
                        rating: 4.5,
                      ),
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
                Container(
                    // padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                      color: whiteColor,
                      // border: Border.all(color: greyColor),
                      // borderRadius: BorderRadius.circular(10),
                      // boxShadow: const [
                      //   BoxShadow(color: blackColor, blurRadius: 1)
                      // ]
                    ),
                    child: const carouselLevel()),
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
                const listViewForTutor(rating: 4)
              ],
            ),
          ),
        ));
  }
}
