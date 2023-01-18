import 'package:coursez/model/user.dart';
import 'package:coursez/utils/fetchData.dart';
import 'package:coursez/widgets/text/body10px.dart';
import 'package:coursez/widgets/text/title12px.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:coursez/widgets/rating/rating.dart';
import 'package:flutter/material.dart';

import '../../utils/color.dart';

class listViewForTutor extends StatefulWidget {
  final double rating;
  final int level;
  const listViewForTutor(
      {super.key, required this.rating, required this.level});

  @override
  State<listViewForTutor> createState() => _listViewForTutorState();
}

class _listViewForTutorState extends State<listViewForTutor> {
  final List<User> _tutor = [];
  // List<User> _tutorLevel = [];
  bool _isError = false;
  @override
  void initState() {
    super.initState();
    fecthData('user/teacher').then((value) {
      debugPrint(value.toString());
      setState(() {
        debugPrint(value['err']);
        if (value['err'] == null) {
          value['data'].map((e) => _tutor.add(User.fromJson(e))).toList();
          debugPrint(_tutor.toString());
        } else {
          debugPrint(value['err'].toString());
          _isError = true;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return _tutor.isEmpty
        ? const CircularProgressIndicator(
            color: primaryColor,
          )
        : SingleChildScrollView(
            child: SizedBox(
              height: 170,
              child: ListView.separated(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: 5,
                  separatorBuilder: (context, _) => const SizedBox(
                        width: 15,
                      ),
                  itemBuilder: (context, index) =>
                      buildCard(_tutor[index], widget.rating)),
            ),
          );
  }
}

Widget buildCard(User item, double rating) {
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
                  item.picture,
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
                    text: '${item.nickName} (${item.fullName})',
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
