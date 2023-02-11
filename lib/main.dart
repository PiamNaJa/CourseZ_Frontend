import 'package:coursez/binding.dart';
import 'package:coursez/firebase_options.dart';
import 'package:coursez/utils/routes/routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Stripe.publishableKey =
        "pk_test_51MZElyCAl36cmn5LTpHty4ZaOx3zUdc0SipdECjQOt17CT3aNvI3VbiC0Po2TGvu8PuV26l1dUB1cV9bOAQ7kKf8005icXFGkp";
    return GetMaterialApp(
      initialBinding: FirstBinding(),
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
