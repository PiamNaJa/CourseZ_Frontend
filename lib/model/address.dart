class Address {
  final int userId;
  final String houseNo;
  final String? lane;
  final String? villageNo;
  final String? village;
  final String? road;
  final String subDistrict;
  final String district;
  final String province;
  final String postal;

  Address(
      {
      required this.userId,
      required this.houseNo,
      this.lane,
      this.villageNo,
      this.village,
      this.road,
      required this.subDistrict,
      required this.district,
      required this.province,
      required this.postal});

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      userId: json['user_id'],
      houseNo: json['house_no'],
      lane: json['lane'],
      villageNo: json['villageNo'],
      village: json['village'],
      road: json['road'],
      subDistrict: json['subDistrict'],
      district: json['district'],
      province: json['province'],
      postal: json['postal'],
    );
  }
}