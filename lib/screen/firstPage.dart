import 'package:coursez/controllers/auth_controller.dart';
import 'package:coursez/screen/ProfilePage.dart';
import 'package:coursez/screen/chatPage.dart';
import 'package:coursez/screen/home.dart';
import 'package:coursez/screen/loginPage.dart';
import 'package:coursez/screen/postPage.dart';
import 'package:coursez/utils/color.dart';
import 'package:coursez/view_model/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({super.key});

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  final page = [
    const MyHomePage(),
    PostPage(),
    const ChatPage(),
    const ProfilePage()
  ];
  final PageController _pageController = PageController();
  final AuthViewModel authViewModel = AuthViewModel();
  int currentIndex = 0;

  @override
  initState() {
    super.initState();
    authViewModel.checkAuth().then((value) => debugPrint(value.toString()));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _pageController.dispose();
    super.dispose();
  }

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
