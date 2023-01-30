import 'package:coursez/screen/Registerpage.dart';
import 'package:coursez/screen/home.dart';
import 'package:coursez/screen/loginPage.dart';
import 'package:coursez/utils/color.dart';
import 'package:flutter/material.dart';

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
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(45), topRight: Radius.circular(45)),
          boxShadow: [
            BoxShadow(color: Colors.black38, spreadRadius: 0, blurRadius: 10),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(45),
            topRight: Radius.circular(45),
          ),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            iconSize: 30,
            selectedFontSize: 0,
            unselectedFontSize: 0,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
              BottomNavigationBarItem(
                  icon: Icon(Icons.newspaper_rounded), label: ''),
              BottomNavigationBarItem(icon: Icon(Icons.message), label: ''),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
            ],
            selectedItemColor: primaryColor,
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
        ),
      ),
    );
  }
}