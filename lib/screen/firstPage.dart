import 'package:coursez/screen/Registerpage.dart';
import 'package:coursez/screen/home.dart';
import 'package:coursez/screen/loginPage.dart';
import 'package:coursez/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({super.key});

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  final page = [const MyHomePage(), const Registerpage(), const LoginPage()];
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: IndexedStack(
        index: currentIndex,
        children: page,
      )),
      bottomNavigationBar: GNav(
        tabs: const [
          GButton(
            icon: Icons.home,
            text: "Home",
          ),
          GButton(icon: Icons.newspaper, text: "Post"),
          GButton(icon: Icons.person, text: "Profile")
        ],
        activeColor: primaryColor,
        tabBackgroundColor: secondaryLighterColor,
        gap: 4,
        onTabChange: (value) {
          setState(() {
            currentIndex = value;
          });
        },
        selectedIndex: currentIndex,
      ),
    );
  }
}
