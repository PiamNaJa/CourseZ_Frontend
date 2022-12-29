import 'package:coursez/utils/color.dart';
import 'package:flutter/material.dart';

class RadioBt extends StatefulWidget {
  final String text;
  final double width;
  final Color color;
  final Color fontcolor;
  const RadioBt(
      {super.key,
      required this.text,
      required this.width,
      required this.color,
      this.fontcolor = const Color(0xFFFFFFFF)});

  @override
  State<RadioBt> createState() => _RadioBtState();
}

class _RadioBtState extends State<RadioBt> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
