import 'package:coursez/screen/Registerpage.dart';
import 'package:coursez/screen/home.dart';
import 'package:coursez/screen/loginPage.dart';
import 'package:coursez/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:custom_navigation_bar/custom_navigation_bar.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({super.key});

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  final page = [const MyHomePage(), const Registerpage(), const LoginPage()];
  final PageController _pageController = PageController();
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: PageView(
        controller: _pageController,
        children: page,
        onPageChanged: (value) => setState(() {
          currentIndex = value;
        }),
      )),
      bottomNavigationBar: CustomNavigationBar(
        iconSize: 32,
        borderRadius: const Radius.circular(20),
        items: [
          CustomNavigationBarItem(
            icon: const Icon(Icons.home),
          ),
          CustomNavigationBarItem(icon: const Icon(Icons.newspaper)),
          CustomNavigationBarItem(icon: const Icon(Icons.person))
        ],
        selectedColor: primaryColor,
        onTap: (value) {
          setState(() {
            currentIndex = value;
            _pageController.animateToPage(currentIndex,
                duration: const Duration(milliseconds: 500),
                curve: Curves.decelerate);
          });
        },
        currentIndex: currentIndex,
      ),
    );
  }
}
