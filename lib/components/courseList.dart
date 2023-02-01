import 'package:coursez/model/course.dart';
import 'package:coursez/utils/color.dart';
import 'package:coursez/widgets/rating/rating.dart';
import 'package:coursez/widgets/text/title16px.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';

class CourseList extends StatelessWidget {
  final Course item;
  const CourseList({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
    onTap: () {},
    child: Container(
      color: Colors.transparent, //ไม่ใส่แล้วกดช่องว่างไม่ได้
      margin: EdgeInsets.only(
          top: 10,
          left: MediaQuery.of(Get.context!).size.width * 0.03,
          right: MediaQuery.of(Get.context!).size.width * 0.03,
          bottom: 10),
      child: Column(
        children: [
          Row(children: [
            Container(
              padding: EdgeInsets.only(
                left: MediaQuery.of(Get.context!).size.width * 0.02,
              ),
              // color: Colors.red,
              width: MediaQuery.of(Get.context!).size.width * 0.93,
              child: LayoutBuilder(builder: (context, constraints) {
                return Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.network(
                        item.picture,
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                      width: constraints.maxWidth * 0.65,
                      decoration: const BoxDecoration(
                        color: whiteColor,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(15),
                          bottomRight: Radius.circular(15),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 20),
                        child: SizedBox(
                            width: constraints.maxWidth * 0.62 - 10,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Title16px(text: item.coursename),
                                Text(
                                  item.description,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      color: blackColor,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w400),
                                ),
                                const ratingStar(rating: 4)
                              ],
                            )),
                      ),
                    ),
                  ],
                );
              }),
            )
          ]),
        ],
      ),
    ),
  );
  }
}
