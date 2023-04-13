import 'user.dart';
import 'rewardItem.dart';

class RewardInfo {
  final int? rewardId;
  final int userId;
  final User? user;
  final int itemId;
  final RewardItem? item;
  final int createdAt;

  RewardInfo(
      {required this.rewardId,
      required this.userId,
      this.user,
      required this.itemId,
      this.item,
      required this.createdAt});

  factory RewardInfo.fromJson(Map<String, dynamic> json) {
    return RewardInfo(
      rewardId: json['reward_id'],
      userId: json['user_id'],
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      itemId: json['item_id'],
      item: json['item'] != null ? RewardItem.fromJson(json['item']) : null,
      createdAt: json['created_at'],
    );
  }
}
