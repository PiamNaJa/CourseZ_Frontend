import 'package:coursez/model/rewardInfo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:coursez/utils/fetchData.dart';

class RewardInfoViewModel {
  Future<List<RewardInfo>> getRewardInfoByUser(String userID) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token')!;
    final res =
        await fecthData('reward/info/user/$userID', authorization: token);
    if (res == String) {
      return [];
    }
    final item =
        res.map<RewardInfo>((json) => RewardInfo.fromJson(json)).toList();
    return item;
  }

  Future<RewardInfo> getRewardInfoByID(String rewardID) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token')!;
    final res = await fecthData('reward/info/$rewardID', authorization: token);
    return RewardInfo.fromJson(res);
  }
}
