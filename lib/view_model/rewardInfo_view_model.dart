import 'package:coursez/model/rewardInfo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:coursez/utils/fetchData.dart';

class rewardInfoViewModel {
  Future<RewardInfo> getRewardInfoByUser(String userID) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token')!;
    final res =
        await fecthData('reward/info/user/$userID', authorization: token);
    print(res);
    return RewardInfo.fromJson(res);
  }
}
