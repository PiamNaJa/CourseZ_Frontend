import 'package:coursez/model/rewardItem.dart';
import 'package:coursez/utils/fetchData.dart';

class RewardVIewModel {
  Future<List<RewardItem>> loadReward() async {
    List<RewardItem> reward = [];

    final r = await fecthData("reward/item");
    reward = List.from(r.map((e) => RewardItem.fromJson(e)).toList());
    return reward;
  }
}
