import 'package:coursez/utils/color.dart';
import 'package:coursez/utils/constant.dart';
import 'package:coursez/widgets/text/body14px.dart';
import 'package:flutter/material.dart';

class dropdown extends StatefulWidget {
  late String? selectedValue;
  late int level;
  dropdown({super.key, this.selectedValue, this.level = 0});

  @override
  State<dropdown> createState() => _dropdownState();
}

class _dropdownState extends State<dropdown> {
  final List<String> _classLevel = [
    'ระดับชั้นทั้งหมด',
    'ม.1',
    'ม.2',
    'ม.3',
    'ม.4',
    'ม.5',
    'ม.6',
    'มหาวิทยาลัย'
  ];

  bool _isError = false;

  @override
  void initState() {
    super.initState();
    widget.selectedValue = _classLevel[0];
  }

  @override
  Widget build(BuildContext context) {
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
          dropdownColor: primaryLighterColor,
          style: const TextStyle(color: Colors.black),
          icon: const Icon(Icons.arrow_drop_down),
          iconSize: 36,
          elevation: 16,
          borderRadius: BorderRadius.circular(25),
          value: widget.selectedValue,
          onChanged: (item) {
            setState(() {
              widget.selectedValue = item!;
              widget.level = _classLevel.indexOf(item);
              debugPrint('--------------------');
              debugPrint(widget.level.toString());
            });
          },
          items: _classLevel.map<DropdownMenuItem<String>>((item) {
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
