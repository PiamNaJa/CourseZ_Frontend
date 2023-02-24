import '../model/user.dart';
import '../utils/fetchData.dart';

class ProfileViewModel {
  Future<User> fetchUser(int userID) async {
    final u = await fecthData('user/$userID');
    return User.fromJson(u);
  }
}
