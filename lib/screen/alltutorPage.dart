import 'package:coursez/controllers/level_controller.dart';
import 'package:coursez/model/tutor.dart';
import 'package:coursez/utils/color.dart';
import 'package:coursez/view_model/tutor_view_model.dart';
import 'package:coursez/widgets/rating/rating.dart';
import 'package:coursez/widgets/text/body12px.dart';
import 'package:coursez/widgets/text/body14px.dart';
import 'package:coursez/widgets/text/heading2_20px.dart';
import 'package:coursez/widgets/text/title14px.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AllTutorPage extends StatelessWidget {
  const AllTutorPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TutorViewModel tutorViewModel = TutorViewModel();
    final LevelController levelController = Get.find<LevelController>();
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: const Heading20px(text: "ติวเตอร์ของเราทั้งหมด"),
        backgroundColor: whiteColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: primaryColor),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: FutureBuilder(
            future: tutorViewModel.loadTutor(levelController.level),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return ListView.separated(
                  separatorBuilder: (context, index) => const SizedBox(
                    height: 20,
                  ),
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    final tutorlist = snapshot.data!;
                    tutorlist.shuffle();
                    return listTile(tutorlist[index]);
                  },
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(
                    color: primaryColor,
                  ),
                );
              }
            }),
      ),
    );
  }

  Widget listTile(Tutor item) {
    return InkWell(
      // onTap: () {
      //   Get.toNamed('')
      // },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 7,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: ListTile(
          leading: ClipOval(
            child: Image.network(item.picture),
          ),
          title: Title14px(
            text: '${item.nickname} (${item.fullname})',
          ),
          subtitle: (item.rating != 0)
              ? Row(
                  children: [
                    RatingStar(rating: item.rating, size: 15),
                    const SizedBox(
                      width: 5,
                    ),
                    Body14px(text: item.rating.toStringAsPrecision(2)),
                  ],
                )
              : const Body12px(
                  text: 'ยังไม่มีคะแนน',
                  color: greyColor,
                ),
          trailing: const Icon(Icons.keyboard_arrow_right),
        ),
      ),
    );
  }
}
