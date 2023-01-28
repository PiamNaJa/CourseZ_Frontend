import 'package:coursez/view_model/tutor_view_model.dart';
import 'package:coursez/widgets/text/title12px.dart';
import 'package:coursez/widgets/text/title16px.dart';
import 'package:flutter/rendering.dart';
import 'package:coursez/widgets/rating/rating.dart';
import 'package:flutter/material.dart';

import '../../utils/color.dart';

class ListViewTutor extends StatelessWidget {
  const ListViewTutor({super.key, required this.rating, required this.level});
  final double rating;
  final int level;

  @override
  Widget build(BuildContext context) {
    TutorViewModel tutorViewModel = TutorViewModel();
    return FutureBuilder(
        future: tutorViewModel.loadTutor(level),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return SingleChildScrollView(
              child: SizedBox(
                height: 170,
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
                        itemCount: (snapshot.data.length > 5)
                            ? 5
                            : snapshot.data.length,
                        separatorBuilder: (context, _) => const SizedBox(
                              width: 15,
                            ),
                        itemBuilder: (context, index) =>
                            buildCard(snapshot.data[index])),
              ),
            );
          } else {
            return const CircularProgressIndicator(
              color: primaryColor,
            );
          }
        });
  }
}

Widget buildCard(dynamic item) {
  return LayoutBuilder(
      builder: (BuildContext context, Constraints constraints) {
    return GestureDetector(
      onTap: () {},
      child: SizedBox(
        width: 140,
        height: 180,
        child: Column(
          children: [
            Expanded(
              child: ClipOval(
                child: Image.network(
                  item['picture'],
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(5, 3, 5, 3),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Title12px(
                    text: '${item['nickname']} (${item['fullname']})',
                    overflow: TextOverflow.ellipsis,
                  ),
                  ratingStar(rating: item['rating'].toDouble()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  });
}
