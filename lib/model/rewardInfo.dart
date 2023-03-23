import 'user.dart';
import 'rewardItem.dart';

class RewardInfo {
  final int rewardId;
  final int userId;
  final User? user;
  final int itemId;
  final RewardItem? item;
  final String houseNo;
  final String lane;
  final String villageNo;
  final String village;
  final String road;
  final String subDistrict;
  final String district;
  final String province;
  final String postal;

  RewardInfo(
      {required this.rewardId,
      required this.userId,
      this.user,
      required this.houseNo,
      required this.itemId,
      this.item,
      required this.lane,
      required this.villageNo,
      required this.village,
      required this.road,
      required this.subDistrict,
      required this.district,
      required this.province,
      required this.postal});

  factory RewardInfo.fromJson(Map<String, dynamic> json) {
    return RewardInfo(
      rewardId: json['reward_id'],
      userId: json['user_id'],
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      houseNo: json['house_no'],
      itemId: json['item_id'],
      item: json['item'] != null ? RewardItem.fromJson(json['item']) : null,
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
