import 'package:coursez/utils/color.dart';
import 'package:coursez/widgets/text/body10px.dart';
import 'package:coursez/widgets/text/title12px.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:coursez/widgets/rating/rating.dart';
import 'package:flutter/material.dart';

class cardItem {
  final String urlImage;
  final String teacher;
  final String subject;
  final double rating;

  cardItem(
      {required this.urlImage,
      required this.teacher,
      required this.rating,
      required this.subject});
}

class listViewForTutor extends StatefulWidget {
  final double rating;

  const listViewForTutor({super.key, required this.rating});

  @override
  State<listViewForTutor> createState() => _listViewForTutorState();
}

class _listViewForTutorState extends State<listViewForTutor> {
  List<cardItem> items = [
    cardItem(
        urlImage:
            'https://uploads-ssl.webflow.com/5f7449cd4e922c61c95ec19e/60b0a23480010d96fd37c974_SeaTalk_IMG_Teacher_01-3.jpg',
        teacher: 'ครูไอซ์ (ปรีชา เพทายวิราพันธ์)',
        subject: 'วิทยาศาสตร์',
        rating: 4.8),
    cardItem(
        urlImage:
            'https://uploads-ssl.webflow.com/5f7449cd4e922c61c95ec19e/60b0a23480010d96fd37c974_SeaTalk_IMG_Teacher_01-3.jpg',
        teacher: 'ครูไอซ์ (ปรีชา เพทายวิราพันธ์)',
        subject: 'วิทยาศาสตร์',
        rating: 4.8),
    cardItem(
        urlImage:
            'https://uploads-ssl.webflow.com/5f7449cd4e922c61c95ec19e/60b0a23480010d96fd37c974_SeaTalk_IMG_Teacher_01-3.jpg',
        teacher: 'ครูไอซ์ (ปรีชา เพทายวิราพันธ์)',
        subject: 'วิทยาศาสตร์',
        rating: 4.8),
    cardItem(
        urlImage:
            'https://uploads-ssl.webflow.com/5f7449cd4e922c61c95ec19e/60b0a23480010d96fd37c974_SeaTalk_IMG_Teacher_01-3.jpg',
        teacher: 'ครูไอซ์ (ปรีชา เพทายวิราพันธ์)',
        subject: 'วิทยาศาสตร์',
        rating: 4.8),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        height: 170,
        child: ListView.separated(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            separatorBuilder: (context, _) => const SizedBox(
                  width: 15,
                ),
            itemBuilder: (context, index) =>
                buildCard(items[index], widget.rating)),
      ),
    );
  }
}

Widget buildCard(cardItem item, double rating) {
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
                  item.urlImage,
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
                    text: item.teacher,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Body10px(
                    text: item.subject,
                    overflow: TextOverflow.ellipsis,
                  ),
                  ratingStar(rating: rating)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  });
}
