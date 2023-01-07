import 'package:coursez/utils/color.dart';
import 'package:coursez/widgets/text/body14px.dart';
import 'package:coursez/widgets/text/heading2_20px.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class dropdown extends StatefulWidget {
  List items;
  String selectedItem;

  dropdown({super.key, required this.items, required this.selectedItem});

  @override
  State<dropdown> createState() => _dropdownState();
}

class _dropdownState extends State<dropdown> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: greyColor),
          borderRadius: BorderRadius.circular(25)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: DropdownButton(
          dropdownColor: primaryLighterColor,
          style: const TextStyle(color: Colors.black),
          icon: const Icon(Icons.arrow_drop_down),
          iconSize: 36,
          elevation: 16,
          isExpanded: true,
          borderRadius: BorderRadius.circular(25),
          value: widget.selectedItem,
          onChanged: (item) {
            setState(() {
              widget.selectedItem = item!;
            });
          },
          items: widget.items.map<DropdownMenuItem<String>>((item) {
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
