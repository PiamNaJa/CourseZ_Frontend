class Withdraw {
  final int teacherId;
  final int money;
  final String bankName;
  final String bankNumber;
  final int createAt;

  Withdraw({
    required this.teacherId,
    required this.money,
    required this.bankName,
    required this.bankNumber,
    required this.createAt,
  });

  factory Withdraw.fromJson(Map<String, dynamic> json) {
    return Withdraw(
      teacherId: json['recipient(teacher_id)'],
      money: json['money'],
      bankName: json['bank_name'],
      bankNumber: json['bank_number'],
      createAt: json['created_at'],
    );
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['money'] = money;
    data['bank_name'] = bankName;
    data['bank_number'] = bankNumber;
    return data;
  }
}
