import 'package:coursez/utils/routes/routes.dart';
import 'package:coursez/view_model/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:coursez/controllers/auth_controller.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'CourseZ',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      debugShowCheckedModeBanner: false,
      getPages: Routes.getRoutes,
      initialBinding: BindingsBuilder.put(() => AuthController()),
      initialRoute: '/first',
    );
  }
}
