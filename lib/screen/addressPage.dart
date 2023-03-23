import 'package:coursez/main.dart';
import 'package:coursez/model/address.dart';
import 'package:coursez/utils/color.dart';
import 'package:coursez/widgets/button/button.dart';
import 'package:coursez/widgets/text/heading1_24px.dart';
import 'package:coursez/widgets/text/heading2_20px.dart';
import 'package:coursez/widgets/text/title16px.dart';
import 'package:coursez/widgets/textField/addressTextForm.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';

class AddressPage extends StatelessWidget {
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
      postal: '');

  // onSubmit() {
  //   postViewModel.createPost(textcontroller.text.trim(), image);

  // }

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
                    AddressTextForm(
                      title: 'รหัสไปรษณีย์',
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'กรุณากรอกรหัสไปรษณีย์';
                        }
                        return null;
                      },
                      onChanged: (String postal) {
                        address.postal = postal;
                      },
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
                      Get.toNamed('/rewardbill', arguments: address);
                    }
                  }))
        ],
      ),
    );
  }
}
