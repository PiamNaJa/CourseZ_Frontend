import 'package:coursez/middleware/auth_middleware.dart';
import 'package:coursez/screen/Registerpage.dart';
import 'package:coursez/screen/coursePage.dart';
import 'package:coursez/screen/courseSubjectPage.dart';
import 'package:coursez/screen/expandPage.dart';
import 'package:coursez/screen/firstPage.dart';
import 'package:coursez/screen/home.dart';
import 'package:coursez/screen/loginPage.dart';
import 'package:coursez/screen/postPage.dart';
import 'package:coursez/screen/profilePage.dart';
import 'package:get/get.dart';

class Routes {
  static final List<GetPage> _getRoutes = [
    GetPage(name: '/login', page: () => const LoginPage()),
    GetPage(
        name: '/home',
        page: () => const MyHomePage(),
        // middlewares: [AuthMiddleware()]
        ),
    GetPage(name: '/register', page: () => const Registerpage()),
    GetPage(name: '/first', page: () => const FirstPage()),
    GetPage(name: '/profile', page: () => const ProfilePage()),
    GetPage(name: '/expand', page: () => const ExpandPage()),
    GetPage(name: '/post', page: () => const PostPage()),
    GetPage(name: '/coursesubject', page: () => CourseSubject()),
    GetPage(name: '/coursedetail', page: () => const CoursePage())
  ];
  static List<GetPage> get getRoutes => _getRoutes;
}
