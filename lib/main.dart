import 'package:coursez/screen/expandPage.dart';
import 'package:coursez/screen/Loginpage.dart';
import 'package:coursez/screen/home.dart';
import 'package:coursez/screen/Registerpage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'CourseZ',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(),
      routes: {
        '/login': (context) => const loginPage(),
        '/home': (context) => const MyHomePage(),
        '/register': ((context) => const Registerpage())
      },
    );
  }
}
