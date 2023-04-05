import 'package:coursez/controllers/auth_controller.dart';
import 'package:coursez/model/address.dart';
import 'package:coursez/utils/color.dart';
import 'package:coursez/view_model/address_view_model.dart';
import 'package:coursez/widgets/button/button.dart';
import 'package:coursez/widgets/text/heading1_24px.dart';
import 'package:coursez/widgets/text/heading2_20px.dart';
import 'package:coursez/widgets/text/title16px.dart';
import 'package:coursez/widgets/textField/addressTextForm.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddressPage extends StatelessWidget {
  AuthController authController = Get.find();
  AddressViewModel addressViewModel = AddressViewModel();

  AddressPage({super.key});
  Address address = Address(
      houseNo: '',
      lane: '',
      villageNo: '',
      village: '',
      road: '',
      subDistrict: '',
      district: '',
      province: '',
      postal: 0);

  onSubmit(Address address, bool isEdit) {
    addressViewModel.addAddress(address, authController.userid, isEdit);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          titleSpacing: 0.0,
          title: const Heading24px(text: 'กรอกที่อยู่สำหรับการจัดส่ง'),
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: primaryColor),
            onPressed: () {
              Get.back();
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: formAddress(),
          ),
        ));
  }

  Widget formAddress() {
    final formKey = GlobalKey<FormState>();
    address = Get.arguments ?? address;
    bool isEdit = Get.parameters['isEdit'] == 'true';

    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Heading20px(text: 'บ้านเลขที่'),
                        Title16px(
                          text: ' *',
                          color: Colors.red,
                        ),
                      ],
                    ),
                    AddressTextForm(
                      title: 'บ้านเลขที่',
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'กรุณากรอกบ้านเลขที่';
                        }
                        return null;
                      },
                      onChanged: (String houseNo) {
                        address.houseNo = houseNo;
                      },
                      initialValue: address.houseNo,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Heading20px(text: 'หมู่'),
                    AddressTextForm(
                      title: 'หมู่',
                      validator: null,
                      onChanged: (String villageNo) {
                        address.villageNo = villageNo;
                      },
                      initialValue: address.villageNo,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 12,
          ),
          const Heading20px(text: 'ซอย'),
          AddressTextForm(
            title: 'ซอย',
            validator: null,
            onChanged: (String lane) {
              address.lane = lane;
            },
            initialValue: address.lane,
          ),
          const SizedBox(
            height: 12,
          ),
          const Heading20px(text: 'หมู่บ้าน'),
          AddressTextForm(
            title: 'หมู่บ้าน',
            validator: null,
            onChanged: (String village) {
              address.village = village;
            },
            initialValue: address.village,
          ),
          const SizedBox(
            height: 12,
          ),
          Row(
            children: const [
              Heading20px(text: 'ถนน'),
              Title16px(
                text: ' *',
                color: Colors.red,
              ),
            ],
          ),
          AddressTextForm(
            title: 'ถนน',
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'กรุณากรอกถนน';
              }
              return null;
            },
            onChanged: (String road) {
              address.road = road;
            },
            initialValue: address.road,
          ),
          const SizedBox(
            height: 12,
          ),
          Row(
            children: const [
              Heading20px(text: 'แขวง/ตำบล'),
              Title16px(
                text: ' *',
                color: Colors.red,
              ),
            ],
          ),
          AddressTextForm(
            title: 'แขวง/ตำบล',
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'กรุณากรอกแขวง/ตำบล';
              }
              return null;
            },
            onChanged: (String subDistrict) {
              address.subDistrict = subDistrict;
            },
            initialValue: address.subDistrict,
          ),
          const SizedBox(
            height: 12,
          ),
          Row(
            children: const [
              Heading20px(text: 'เขต/อำเภอ'),
              Title16px(
                text: ' *',
                color: Colors.red,
              ),
            ],
          ),
          AddressTextForm(
            title: 'เขต/อำเภอ',
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'กรุณากรอกเขต/อำเภอ';
              }
              return null;
            },
            onChanged: (String district) {
              address.district = district;
            },
            initialValue: address.district,
          ),
          const SizedBox(
            height: 12,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Heading20px(text: 'จังหวัด'),
                        Title16px(
                          text: ' *',
                          color: Colors.red,
                        ),
                      ],
                    ),
                    AddressTextForm(
                      title: 'จังหวัด',
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'กรุณากรอกจังหวัด';
                        }
                        return null;
                      },
                      onChanged: (String province) {
                        address.province = province;
                      },
                      initialValue: address.province,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Heading20px(text: 'รหัสไปรษณีย์'),
                        Title16px(
                          text: ' *',
                          color: Colors.red,
                        ),
                      ],
                    ),
                    TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      keyboardType: TextInputType.number,
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'กรุณากรอกรหัสไปรษณีย์';
                        } else {
                          if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                            return 'กรุณากรอกรหัสไปรษณีย์ที่ถูกต้อง';
                          }
                          if (value.length != 5) {
                            return 'กรุณากรอกรหัสไปรษณีย์ที่ถูกต้อง';
                          }
                        }
                        return null;
                      },
                      onChanged: (String postal) {
                        if (!RegExp(r'^[0-9]+$').hasMatch(postal)) {
                          return;
                        }
                        address.postal = int.parse(postal);
                      },
                      initialValue: address.postal.toString(),
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: greyColor),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: primaryColor),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.red),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.red),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 20),
                        hintText: 'รหัสไปรษณีย์',
                        hintStyle: const TextStyle(
                          fontFamily: 'Athiti',
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          SizedBox(
              width: MediaQuery.of(Get.context!).size.width,
              child: Bt(
                  text: 'ยืนยัน',
                  color: primaryColor,
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      onSubmit(address, isEdit);
                    }
                  }))
        ],
      ),
    );
  }
}
