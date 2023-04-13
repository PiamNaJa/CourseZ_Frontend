class Address {
  String houseNo;
  String? lane;
  String? villageNo;
  String? village;
  String? road;
  String subDistrict;
  String district;
  String province;
  int postal;

  Address(
      {required this.houseNo,
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
      houseNo: json['house_no'],
      lane: json['lane'],
      villageNo: json['village_no'],
      village: json['village'],
      road: json['road'],
      subDistrict: json['sub_district'],
      district: json['district'],
      province: json['province'],
      postal: json['postal'],
    );
  }
}
