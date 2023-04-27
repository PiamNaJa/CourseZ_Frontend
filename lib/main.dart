import 'package:coursez/binding.dart';
import 'package:coursez/firebase_options.dart';
import 'package:coursez/utils/routes/routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(
      debug:
          true, // optional: set to false to disable printing logs to console (default: true)
      ignoreSsl:
          true // option: set to false to disable working with http links (default: false)
      );
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
      theme: ThemeData(primarySwatch: Colors.green, fontFamily: 'Athiti'),
      debugShowCheckedModeBanner: false,
      getPages: Routes.getRoutes,
      initialRoute: '/createvideo',
      themeMode: ThemeMode.dark,
    );
  }
}
