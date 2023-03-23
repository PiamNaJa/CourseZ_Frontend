import 'package:coursez/model/address.dart';
import 'package:coursez/utils/fetchData.dart';

class AddressViewModel {
  Future<Address> loadAddressByuserId(int userid) async {
    final a = await fecthData('user/$userid/address');
    final address = Address.fromJson(a);
    return address;
  }

  Future<bool> checkAddress(int userid) async {
    final a = await fecthData('user/$userid/address');
    if (a == null) {
      return false;
    } else {
      return true;
    }
  }
}
