import 'package:coursez/model/rewardInfo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:coursez/utils/fetchData.dart';

import '../model/rewardItem.dart';

class RewardInfoViewModel {
  Future<List<RewardItem>> getRewardInfoByUser(String userID) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token')!;
    final res =
        await fecthData('reward/info/user/$userID', authorization: token);
    if (res is String) {
      return Future.value([]);
    }
    final List<dynamic> itemList = res;
    final item = itemList.map((e) => RewardItem.fromJson(e)).toList();
    return Future.value(item);
  }

  Future<RewardInfo> getRewardInfoByID(String rewardID) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token')!;
    final res = await fecthData('reward/info/$rewardID', authorization: token);
    return RewardInfo.fromJson(res);
  }
}
