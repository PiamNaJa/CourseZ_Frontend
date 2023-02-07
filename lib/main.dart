import 'package:coursez/controllers/auth_controller.dart';
import 'package:coursez/firebase_options.dart';
import 'package:coursez/utils/routes/routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<void> main() async {
  runApp(const MyApp());
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Get.put(AuthController());
    return GetMaterialApp(
      title: 'CourseZ',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      debugShowCheckedModeBanner: false,
      getPages: Routes.getRoutes,
      initialRoute: '/first',
    );
  }
}
