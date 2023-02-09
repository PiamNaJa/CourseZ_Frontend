import 'dart:convert';
import 'dart:io';
import 'package:coursez/controllers/auth_controller.dart';
import 'package:coursez/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PaymentApi {
  static Future<Map<String, dynamic>> createPaymentIntent(String amount) async {
    var url = 'https://api.stripe.com/v1/payment_intents';
    var response = await http.post(Uri.parse(url), body: {
      'amount': amount,
      'currency': 'thb',
    }, headers: {
      "Authorization": "Bearer $stripeSecret",
      "Content-Type": "application/x-www-form-urlencoded"
    });
    return json.decode(response.body);
  }

  static makePayment(String clientSecret) async {
    final AuthController authController = Get.find<AuthController>();
    const gpay = PaymentSheetGooglePay(
        merchantCountryCode: "TH", currencyCode: "THB", testEnv: true);
    await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
      googlePay: gpay,
      paymentIntentClientSecret: clientSecret,
      merchantDisplayName: 'CourseZ',
      style: ThemeMode.light,
      customerId: authController.userid.toString(),
    ));
  }

  static showPayment(String clientSecret) async {
    await Stripe.instance.presentPaymentSheet();
  }

  static savePayment(List<int> videosId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      const url = 'http://10.0.2.2:5000/api/payment/videos';
      await http.post(Uri.parse(url), body: {
        'videosId': json.encode(videosId),
      }, headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json"
      });
    } on SocketException {
      throw Exception('No Internet Connection');
    }
  }
}
