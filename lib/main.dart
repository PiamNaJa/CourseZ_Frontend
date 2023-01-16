import 'package:coursez/screen/Reg.dart';
import 'package:coursez/screen/home.dart';
import 'package:coursez/screen/loginPage.dart';
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
      initialRoute: '/register',
      routes: {
        '/login': (context) => const LoginPage(),
        '/home': (context) => const MyHomePage(),
        '/register': ((context) => const RegisterPage())
      },
    );
  }
}
