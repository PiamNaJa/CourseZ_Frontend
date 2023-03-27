import 'package:coursez/model/address.dart';
import 'package:coursez/repository/address_repository.dart';
import 'package:coursez/utils/color.dart';
import 'package:coursez/utils/fetchData.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddressViewModel {
  AddressRepository _addressRepository = AddressRepository();

  Future<Address> loadAddressByuserId(int userid) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token')!;
    final a = await fecthData('user/$userid/address', authorization: token);
    return Address.fromJson(a);
  }

  Future<bool> checkAddress(int userid) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token')!;
    final a = await fecthData('user/$userid/address', authorization: token);
    print(a);
    if (a is String) {
      return false;
    } else {
      return true;
    }
  }

  Future<void> addAddress(Address address, int userid, bool isEdit) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token')!;
    final bool isPass =
        await _addressRepository.addAddress(address, token, userid);

    if (!isPass) {
      Get.snackbar('ผิดพลาด', 'มีบางอย่างผิดพลาด',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: whiteColor);
    } else {
      if (isEdit == true) {
        Get.back();
      }
      Get.offAndToNamed('/rewardbill', arguments: address);
    }
  }
}
