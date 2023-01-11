import 'package:coursez/screen/Loginpage.dart';
import 'package:coursez/screen/home.dart';
import 'package:coursez/screen/Registerpage.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
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
