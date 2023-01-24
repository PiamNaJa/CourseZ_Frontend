import 'package:coursez/controllers/level_controller.dart';
import 'package:coursez/utils/color.dart';
import 'package:coursez/widgets/text/body14px.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Dropdown extends StatefulWidget {
  const Dropdown({super.key});

  @override
  State<Dropdown> createState() => _DropdownState();
}

class _DropdownState extends State<Dropdown> {
  @override
  Widget build(BuildContext context) {
    final List<String> classLevel = [
      'ระดับชั้นทั้งหมด',
      'ม.1',
      'ม.2',
      'ม.3',
      'ม.4',
      'ม.5',
      'ม.6',
      'มหาวิทยาลัย'
    ];
    LevelController levelController = Get.find();
    return Container(
      height: 50,
      decoration: BoxDecoration(
          border: Border.all(color: greyColor),
          borderRadius: BorderRadius.circular(25)),
      child: Padding(
        padding: MediaQuery.of(context).size.width > 600
            ? const EdgeInsets.symmetric(horizontal: 20, vertical: 8)
            : const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: DropdownButton(
          underline: const SizedBox(),
          alignment: AlignmentDirectional.center,
          style: const TextStyle(color: Colors.black),
          icon: const Icon(Icons.arrow_drop_down_rounded),
          iconSize: 36,
          elevation: 16,
          borderRadius: BorderRadius.circular(25),
          value: classLevel[levelController.level],
          onChanged: (item) {
            setState(() {
              levelController.level = classLevel.indexOf(item!);
            });
          },
          items: classLevel.map<DropdownMenuItem<String>>((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Body14px(text: item),
            );
          }).toList(),
        ),
      ),
    );
  }
}
