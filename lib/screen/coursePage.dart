import 'package:coursez/utils/color.dart';
import 'package:coursez/widgets/button/button.dart';
import 'package:coursez/widgets/rating/rating.dart';
import 'package:coursez/widgets/text/body16.dart';
import 'package:coursez/widgets/text/heading1_24px.dart';
import 'package:coursez/widgets/text/heading1_30px.dart';
import 'package:coursez/widgets/videoCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class CoursePage extends StatefulWidget {
  const CoursePage({super.key});

  @override
  State<CoursePage> createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage> {
  late Map<String, dynamic> _courseData = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _courseData = {
      "course_name": "eiei",
      "picture": "https://shorturl.asia/vlAMb",
      "description":
          "หลักการพื้นฐานสำคัญและเป็นจุดเริ่มต้นของหลักการอื่นๆในวิชาคณิตศาสตร์ โดยในชั้นม.ต้น เนื้อหาจะครอบคลุมตั้งแต่ “จำนวนเต็ม” คืออะไร มีกี่อย่างและมีอะไรบ้าง รวมไปถึงการเปรียบเทียบ และการบวก ลบ คูณ หารจำนวนเต็ม",
      "videos": [
        {
          "video_name": "จำนวนเต็มเเละการบวกจำนวนเต็ม",
          "price": 0,
          "picture": "https://i.ytimg.com/vi/unXOuA0PkCQ/maxresdefault.jpg",
        },
        {
          "video_name": "จำนวนเต็มเเละการบวกจำนวนเต็ม",
          "price": 0,
          "picture": "https://i.ytimg.com/vi/unXOuA0PkCQ/maxresdefault.jpg",
        },
        {
          "video_name": "จำนวนเต็มเเละการบวกจำนวนเต็ม",
          "price": 50,
          "picture": "https://i.ytimg.com/vi/unXOuA0PkCQ/maxresdefault.jpg",
        },
        {
          "video_name": "จำนวนเต็มเเละการบวกจำนวนเต็ม",
          "price": 15,
          "picture": "https://i.ytimg.com/vi/unXOuA0PkCQ/maxresdefault.jpg",
        },
        {
          "video_name": "จำนวนเต็มเเละการบวกจำนวนเต็ม",
          "price": 20,
          "picture": "https://i.ytimg.com/vi/unXOuA0PkCQ/maxresdefault.jpg",
        },
        {
          "video_name": "จำนวนเต็มเเละการบวกจำนวนเต็ม",
          "price": 15,
          "picture": "https://i.ytimg.com/vi/unXOuA0PkCQ/maxresdefault.jpg",
        },
        {
          "video_name": "จำนวนเต็มเเละการบวกจำนวนเต็ม",
          "price": 15,
          "picture": "https://i.ytimg.com/vi/unXOuA0PkCQ/maxresdefault.jpg",
        },
        {
          "video_name": "จำนวนเต็มเเละการบวกจำนวนเต็ม",
          "price": 15,
          "picture": "https://i.ytimg.com/vi/unXOuA0PkCQ/maxresdefault.jpg",
        },
        {
          "video_name": "จำนวนเต็มเเละการบวกจำนวนเต็ม",
          "price": 15,
          "picture": "https://i.ytimg.com/vi/unXOuA0PkCQ/maxresdefault.jpg",
        },
        {
          "video_name": "จำนวนเต็มเเละการบวกจำนวนเต็ม",
          "price": 15,
          "picture": "https://i.ytimg.com/vi/unXOuA0PkCQ/maxresdefault.jpg",
        },
        {
          "video_name": "จำนวนเต็มเเละการบวกจำนวนเต็ม",
          "price": 15,
          "picture": "https://i.ytimg.com/vi/unXOuA0PkCQ/maxresdefault.jpg",
        },
        {
          "video_name": "จำนวนเต็มเเละการบวกจำนวนเต็ม",
          "price": 15,
          "picture": "https://i.ytimg.com/vi/unXOuA0PkCQ/maxresdefault.jpg",
        },
      ]
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: primaryColor),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Heading24px(text: _courseData['course_name']!),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  color: primaryLighterColor,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          LayoutBuilder(builder: (context, constraints) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.network(
                                  _courseData['picture'] as String,
                                  width: constraints.maxWidth * 0.5,
                                  fit: BoxFit.fill,
                                ),
                                IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.heart_broken),
                                  iconSize: 35,
                                )
                              ],
                            );
                          }),
                          Heading30px(text: _courseData['course_name']!),
                          Row(
                            children: [
                              Body16px(
                                  text: 'โดย ${_courseData["course_name"]}'),
                              const ratingStar(rating: 5),
                            ],
                          ),
                          Body16px(text: _courseData["description"]!),
                        ]),
                  ),
                ),
                //Line
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Heading30px(text: "บทเรียน"),
                    Bt(
                      text: "ซื้อทั้งหมด",
                      color: primaryColor,
                      onPressed: () {},
                    )
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Center(
                  child: LayoutBuilder(builder: (context, constraints) {
                    return Wrap(
                        spacing: constraints.maxWidth * 0.06,
                        runSpacing: 12,
                        children: List.generate(
                          _courseData['videos'].length,
                          ((index) {
                            return VideoCard(
                              image: _courseData['videos'][index]['picture'],
                              name: _courseData['videos'][index]['video_name'],
                              width: 170,
                              height: 120,
                              onPressed: () {},
                            );
                          }),
                        ));
                  }),
                )
              ],
            ),
          ),
        ));
  }
}
