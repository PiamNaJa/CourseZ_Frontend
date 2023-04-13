import 'package:coursez/model/video.dart';

class Payment {
  int paymentId;
  int money;
  String text;
  Video video;
  int createdAt;

  Payment({
    required this.paymentId,
    required this.money,
    required this.text,
    required this.video,
    required this.createdAt,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      paymentId: json['payment_id'],
      money: json['money'],
      text: json['text'],
      video: Video.fromJson(json['video']),
      createdAt: json['created_at'],
    );
  }
}
