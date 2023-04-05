import 'package:coursez/model/rewardInfo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:coursez/utils/fetchData.dart';

class RewardInfoViewModel {
  Future<List<RewardInfo>> getRewardInfoByUser(String userID) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token')!;
    final res =
        await fecthData('reward/info/user/$userID', authorization: token);
    if (res is String || res == null) {
      return Future.value([]);
    }
    final List<dynamic> itemList = res;
    final item = itemList.map((e) => RewardInfo.fromJson(e)).toList();
    item.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return Future.value(item);
  }

  Future<RewardInfo> getRewardInfoByID(String rewardID) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token')!;
    final res = await fecthData('reward/info/$rewardID', authorization: token);
    return RewardInfo.fromJson(res);
  }

  String formatReviewDate(int createdAt) {
    final date = DateTime.fromMillisecondsSinceEpoch(createdAt * 1000);
    return date.toString().substring(0, 16);
  }
}
