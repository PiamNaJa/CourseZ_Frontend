import 'package:coursez/controllers/auth_controller.dart';
import 'package:coursez/model/course.dart';
import 'package:coursez/utils/color.dart';
import 'package:coursez/widgets/Icon/border_icon.dart';
import 'package:coursez/widgets/alert/alert.dart';
import 'package:coursez/widgets/button/button.dart';
import 'package:coursez/widgets/text/heading1_24px.dart';
import 'package:coursez/widgets/text/heading2_20px.dart';
import 'package:coursez/widgets/text/title14px.dart';
import 'package:coursez/widgets/videoCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

class CoursePage extends StatefulWidget {
  const CoursePage({super.key});

  @override
  State<CoursePage> createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage> {
  final Icon fav = const Icon(Icons.favorite_border);
  final data = Get.arguments;
  AuthController authController = Get.find();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    late bool isLogin = false;
    return Scaffold(
        body: SafeArea(
            child: SizedBox(
                width: size.width,
                height: size.height,
                child: FutureBuilder(
                  future: data,
                  builder: ((context, snapshot) {
                    return (snapshot.hasData)
                        ? SizedBox(
                            child: detail(snapshot.data),
                          )
                        : const Center(child: CircularProgressIndicator());
                  }),
                ))));
  }

  Widget detail(dynamic _courseData) {
    final Size size = MediaQuery.of(Get.context!).size;
    late double padding = 15;
    final sidePadding = EdgeInsets.symmetric(horizontal: padding);

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
                    _courseData.picture,
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
                          InkWell(
                            onTap: () {
                              if (authController.isLogin) {
                                setState(() {});
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
                              }
                            },
                            child: const BorderIcon(
                                width: 50,
                                height: 50,
                                child: Icon(
                                  Icons.favorite_border,
                                )),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: padding,
              ),
              Padding(
                padding: sidePadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Heading24px(text: _courseData.coursename),
                    const Title14px(
                      text: 'ชื่อครู',
                      color: greyColor,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: padding,
              ),
              Padding(
                padding: sidePadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Title14px(
                      text: 'รายละเอียด',
                    ),
                    Text(
                      _courseData.description,
                      style: const TextStyle(
                        fontFamily: 'Athiti',
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
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
                        Row(
                          children: [
                            Row(
                                children: List.generate(
                                    _courseData.videos.length, (index) {
                              num amount = 0;
                              amount += _courseData.videos[index].price;
                              if (_courseData.videos[index] ==
                                  _courseData.videos.last) {
                                return Title14px(
                                    text:
                                        '${amount.toString()}.-/ ${_courseData.videos.length} วีดิโอ');
                              } else {
                                return const SizedBox();
                              }
                            })),
                            const SizedBox(
                              width: 5,
                            ),
                            Bt(
                              text: "ซื้อทั้งหมด",
                              color: primaryColor,
                              onPressed: () {
                                if (!authController.isLogin) {
                                  showDialog(
                                      context: Get.context!,
                                      builder: (BuildContext context) {
                                        return const AlertLogin(
                                          body:
                                              'กรุณาเข้าสู่ระบบเพื่อซื้อวีดิโอ',
                                          action: 'เข้าสู่ระบบ',
                                        );
                                      });
                                }
                              },
                            ),
                          ],
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
                              _courseData.videos.length,
                              ((index) {
                                return VideoCard(
                                  image: _courseData.videos[index].picture,
                                  name: _courseData.videos[index].videoName,
                                  width: constraints.maxWidth * 0.3,
                                  height: constraints.maxWidth * 0.3 + 1,
                                  price: _courseData.videos[index].price,
                                  onTap: () {
                                    debugPrint(_courseData.videos[index].videoId
                                        .toString());
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



// SafeArea(
//       child: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//               color: primaryLighterColor,
//               child: Padding(
//                 padding: const EdgeInsets.all(15.0),
//                 child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       LayoutBuilder(builder: (context, constraints) {
//                         return Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Image.network(
//                               _courseData['picture'] as String,
//                               width: constraints.maxWidth * 0.5,
//                               fit: BoxFit.fill,
//                             ),
//                             IconButton(
//                               onPressed: () {
//                                 setState(() {
//                                   if (fav ==
//                                       const Icon(Icons.favorite_border)) {
//                                     fav == const Icon(Icons.favorite_sharp);
//                                     debugPrint('fav');
//                                   } else {
//                                     fav == const Icon(Icons.favorite_border);
//                                     debugPrint('not fav');
//                                   }
//                                 });
//                               },
//                               icon: fav,
//                               iconSize: 35,
//                             )
//                           ],
//                         );
//                       }),
//                       Heading30px(text: _courseData['course_name']!),
//                       Row(
//                         children: [
//                           Body16px(text: 'โดย ${_courseData["course_name"]}'),
//                           const ratingStar(rating: 5),
//                         ],
//                       ),
//                       Body16px(text: _courseData["description"]!),
//                     ]),
//               ),
//             ),
//             //Line
//             const SizedBox(
//               height: 15,
//             ),
//             Padding(
//               padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
//               child: Column(
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       const Heading30px(text: "บทเรียน"),
//                       Bt(
//                         text: "ซื้อทั้งหมด",
//                         color: primaryColor,
//                         onPressed: () {},
//                       )
//                     ],
//                   ),
//                   const SizedBox(
//                     height: 15,
//                   ),
//                   Center(
//                     child: LayoutBuilder(builder: (context, constraints) {
//                       return Wrap(
//                           spacing: constraints.maxWidth * 0.06,
//                           runSpacing: 12,
//                           children: List.generate(
//                             _courseData['videos'].length,
//                             ((index) {
//                               return VideoCard(
//                                 image: _courseData['videos'][index]['picture'],
//                                 name: _courseData['videos'][index]
//                                     ['video_name'],
//                                 width: 100,
//                                 height: 100,
//                                 price: _courseData['videos'][index]['price'],
//                                 onPressed: () {},
//                               );
//                             }),
//                           ));
//                     }),
//                   )
//                 ],
//               ),
//             )
//           ],
//         ),
//       ),
//     )