import 'package:coursez/model/tutor.dart';
import 'package:coursez/view_model/tutor_view_model.dart';
import 'package:coursez/widgets/text/body10px.dart';
import 'package:coursez/widgets/text/body12px.dart';
import 'package:coursez/widgets/text/title12px.dart';
import 'package:coursez/widgets/text/title16px.dart';
import 'package:flutter/rendering.dart';
import 'package:coursez/widgets/rating/rating.dart';
import 'package:flutter/material.dart';

import '../../utils/color.dart';

class ListViewTutor extends StatelessWidget {
  const ListViewTutor({super.key, required this.level});
  final int level;

  @override
  Widget build(BuildContext context) {
    TutorViewModel tutorViewModel = TutorViewModel();
    return FutureBuilder(
        future: tutorViewModel.loadTutor(level),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return SizedBox(
              height: 200,
              child: (snapshot.data.length == 0)
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Title16px(
                            text: 'ขออภัยครับ/ ค่ะ ไม่มีติวเตอร์ในระดับนี้',
                            color: greyColor),
                        Icon(
                          Icons.sentiment_dissatisfied_outlined,
                          color: greyColor,
                          size: 50,
                        )
                      ],
                    )
                  : ListView.separated(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount:
                          (snapshot.data.length > 5) ? 5 : snapshot.data.length,
                      separatorBuilder: (context, _) => const SizedBox(
                            width: 20,
                          ),
                      itemBuilder: (context, index) =>
                          buildCard(snapshot.data[index])),
            );
          } else {
            return const CircularProgressIndicator(
              color: primaryColor,
            );
          }
        });
  }
}

Widget buildCard(Tutor item) {
  return LayoutBuilder(
      builder: (BuildContext context, Constraints constraints) {
    return GestureDetector(
        onTap: () {},
        child: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: [
            Container(
              alignment: Alignment.bottomCenter,
              width: 140,
              height: 150,
              decoration: BoxDecoration(
                  color: whiteColor,
                  borderRadius: BorderRadius.circular(15),
                  border:
                      Border.all(color: greyColor.withOpacity(0.5), width: 0.6),
                  boxShadow: const [
                    BoxShadow(
                      color: greyColor,
                      blurRadius: 5,
                      offset: Offset(0, 1),
                    )
                  ]),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Title12px(text: item.nickname),
                    Body10px(text: item.fullname),
                    (item.rating != 0)
                        ? RatingStar(
                            rating: item.rating.toDouble(),
                            size: 20,
                          )
                        : const Body12px(
                            text: 'ยังไม่มีคะแนน', color: greyColor)
                  ],
                ),
              ),
            ),
            Container(
              alignment: Alignment.topCenter,
              child: ClipOval(
                child: Image.network(
                  item.picture,
                  height: 110,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ));
  });
}
