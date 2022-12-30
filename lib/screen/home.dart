import 'package:coursez/utils/color.dart';
import 'package:coursez/widgets/button/button.dart';
import 'package:coursez/widgets/button/iconbutton.dart';
import 'package:coursez/widgets/button/radiobutton.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Bt(text: "Peerawat", color: primaryDisable),
            IconBt(text: "Peerawat", width: 200, color: primaryColor),
            RadioBt(text: "Pww", width: 200, color: secondaryColor, fontcolor: primaryColor)

          ],
        ),
      ),
    );
  }
}
