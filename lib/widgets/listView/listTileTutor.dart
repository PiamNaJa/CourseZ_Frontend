import 'package:coursez/model/tutor.dart';
import 'package:coursez/utils/color.dart';
import 'package:coursez/view_model/tutor_view_model.dart';
import 'package:coursez/widgets/rating/rating.dart';
import 'package:coursez/widgets/text/body14px.dart';
import 'package:coursez/widgets/text/title14px.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ListTileTutor extends StatelessWidget {
  ListTileTutor({super.key});
  TutorViewModel tutorViewModel = TutorViewModel();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: tutorViewModel.loadTutor(0),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: snapshot.data!.length,
            separatorBuilder: (context, _) => const SizedBox(
              height: 20,
            ),
            itemBuilder: (context, index) => listTile(snapshot.data![index]),
          );
        } else {
          return const CircularProgressIndicator(
            color: primaryColor,
          );
        }
      },
    );
  }
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
        subtitle: Row(
          children: [
            RatingStar(rating: item.rating, size: 15),
            const SizedBox(
              width: 5,
            ),
            Body14px(text: item.rating.toStringAsPrecision(2)),
          ],
        ),
        trailing: const Icon(Icons.keyboard_arrow_right),
      ),
    ),
  );
}
