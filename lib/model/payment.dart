class Payment {
  int paymentId;
  int money;
  String text;

  Payment({
    required this.paymentId,
    required this.money,
    required this.text,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      paymentId: json['payment_id'],
      money: json['money'],
      text: json['text'],
    );
  }
}
