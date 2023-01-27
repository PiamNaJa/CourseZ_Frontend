import 'package:coursez/screen/Registerpage.dart';
import 'package:coursez/screen/firstPage.dart';
import 'package:coursez/screen/home.dart';
import 'package:coursez/screen/loginPage.dart';
import 'package:get/get.dart';

class Routes {
  static final List<GetPage> _getRoutes = [
    GetPage(name: '/login', page: () => const LoginPage()),
    GetPage(name: '/home', page: () => const MyHomePage()),
    GetPage(name: '/register', page: () => const Registerpage()),
    GetPage(name: '/first', page: () => FirstPage()),
  ];
  static List<GetPage> get getRoutes => _getRoutes;
}
