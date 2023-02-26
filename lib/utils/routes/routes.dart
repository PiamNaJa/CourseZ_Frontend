import 'package:coursez/screen/Reg.dart';
import 'package:coursez/screen/Register2.dart';
import 'package:coursez/screen/chatPage.dart';
import 'package:coursez/screen/coursePage.dart';
import 'package:coursez/screen/courseSubjectPage.dart';
import 'package:coursez/screen/expandPage.dart';
import 'package:coursez/screen/firstPage.dart';
import 'package:coursez/screen/home.dart';
import 'package:coursez/screen/loginPage.dart';
import 'package:coursez/screen/postPage.dart';
import 'package:coursez/screen/profilePage.dart';
import 'package:coursez/screen/videoPage.dart';
import 'package:coursez/screen/searchPage.dart';
import 'package:get/get.dart';

import '../../screen/postdetailPage.dart';

class Routes {
  static final List<GetPage> _getRoutes = [
    GetPage(name: '/login', page: () => const LoginPage()),
    GetPage(
      name: '/home',
      page: () => const MyHomePage(),
      // middlewares: [AuthMiddleware()]
    ),
    GetPage(name: '/register', page: () => const RegisterPage()),
    GetPage(name: '/register2', page: () => const RegisterPage2()),
    GetPage(name: '/first', page: () => const FirstPage()),
    GetPage(name: '/profile', page: () => const ProfilePage()),
    GetPage(name: '/expand', page: () => const ExpandPage()),
    GetPage(name: '/post', page: () => const PostPage()),
    GetPage(name: '/coursesubject', page: () => CourseSubject()),
    GetPage(name: '/search', page: () => const SearchPage()),
    GetPage(name: '/course/:course_id', page: () => const CoursePage()),
    GetPage(name: '/chat', page: () => const ChatPage()),
    GetPage(
        name: '/course/:course_id/video/:video_id',
        page: () => const VideoPage()),
    GetPage(name: '/post/:post_id', page: () => const PostdetailPage())
  ];
  static List<GetPage> get getRoutes => _getRoutes;
}
