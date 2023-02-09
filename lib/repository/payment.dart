import 'dart:convert';

import 'package:coursez/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

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
    const gpay = PaymentSheetGooglePay(
        merchantCountryCode: "TH", currencyCode: "THB", testEnv: true);
    await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
      googlePay: gpay,
      paymentIntentClientSecret: clientSecret,
      merchantDisplayName: 'CourseZ',
      style: ThemeMode.light,
    ));
  }

  static showPayment(String clientSecret) async {
    await Stripe.instance.presentPaymentSheet();
  }
}
