import 'package:coursez/controllers/auth_controller.dart';
import 'package:coursez/model/withdraw.dart';
import 'package:coursez/utils/color.dart';
import 'package:coursez/utils/inputDecoration.dart';
import 'package:coursez/view_model/withdraw_view_model.dart';
import 'package:coursez/widgets/button/button.dart';
import 'package:coursez/widgets/text/heading1_24px.dart';
import 'package:coursez/widgets/text/heading2_20px.dart';
import 'package:coursez/widgets/text/title14px.dart';
import 'package:coursez/widgets/text/title16px.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WithdrawForm extends StatefulWidget {
  const WithdrawForm({super.key});

  @override
  State<WithdrawForm> createState() => _WithdrawFormState();
}

class _WithdrawFormState extends State<WithdrawForm> {
  final AuthController authController = Get.find<AuthController>();
  final String image = Get.parameters['bankimage']!;
  final String title = Get.parameters['bank']!;
  final TextEditingController bankNumberController = TextEditingController();
  final TextEditingController moneyController = TextEditingController();
  bool isTrueorPromptPay = false;
  final WithDrawViewModel withDrawviewModel = WithDrawViewModel();
  final _formKey = GlobalKey<FormState>();
  void onSubmit() {
    final Withdraw withdraw = Withdraw(
        teacherId: 0,
        bankName: title,
        bankNumber: bankNumberController.text,
        money: int.parse(moneyController.text),
        createAt: 0);
    withDrawviewModel.createWithdraw(withdraw);
  }

  @override
  void initState() {
    isTrueorPromptPay = title == 'ทรูวอลเล็ต' || title == 'พร้อมเพย์';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: const Heading20px(text: 'ใส่เลขบัญชี'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: primaryLighterColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: primaryColor),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      bottomNavigationBar: Row(
        children: [
          Expanded(
              child: Bt(
                  text: 'ถอนเงิน',
                  color: (moneyController.text.isEmpty ||
                          bankNumberController.text.isEmpty)
                      ? primaryLighterColor
                      : primaryColor,
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('ยืนยันการถอนเงิน'),
                              content: const Text(
                                  'คุณต้องการถอนเงินจากบัญชีนี้ใช่หรือไม่'),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Get.back();
                                    },
                                    child: const Title14px(
                                      text: 'ยกเลิก',
                                      color: greyColor,
                                    )),
                                TextButton(
                                    onPressed: () {
                                      Get.back();
                                      onSubmit();
                                    },
                                    child: const Title14px(
                                        text: 'ยืนยัน', color: primaryColor)),
                              ],
                            );
                          });
                    }
                  })),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    ClipOval(
                      child: Image.network(
                        image,
                        width: MediaQuery.of(context).size.width * 0.15,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Title16px(text: title),
                  ],
                ),
                const Divider(
                  color: greyColor,
                  thickness: 1,
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Title16px(
                        text: isTrueorPromptPay ? 'เบอร์โทรศัพท์' : 'เลขบัญชี'),
                    const Title16px(
                      text: '*',
                      color: Colors.red,
                    )
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextFormField(
                      controller: bankNumberController,
                      keyboardType: TextInputType.number,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return isTrueorPromptPay
                              ? 'กรุณากรอกเบอร์โทรศัพท์'
                              : 'กรุณากรอกเลขบัญชี';
                        } else if (value.length != 10 ||
                            !RegExp(r'^[0-9]*$').hasMatch(value)) {
                          return isTrueorPromptPay
                              ? 'กรุณากรอกเบอร์โทรศัพท์ให้ถูกต้อง'
                              : 'กรุณากรอกเลขบัญชีให้ถูกต้อง';
                        }

                        return null;
                      },
                      decoration: getInputDecoration(isTrueorPromptPay
                          ? 'กรอกเบอร์โทรศัพท์'
                          : 'กรอกเลขบัญชี')),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                Heading24px(text: 'ยอดเงินคงเหลือ ${authController.money} บาท'),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: const [
                        Title16px(text: 'จำนวนเงิน'),
                        Title16px(
                          text: '*',
                          color: Colors.red,
                        )
                      ],
                    ),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextFormField(
                    controller: moneyController,
                    keyboardType: TextInputType.number,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return 'กรุณากรอกจำนวนเงิน';
                      } else if (!RegExp(r'^[0-9]*$').hasMatch(value)) {
                        return 'กรุณากรอกจำนวนเงินให้ถูกต้อง';
                      } else if (int.parse(value) > authController.money) {
                        return 'จำนวนเงินไม่เพียงพอ';
                      } else if (int.parse(value) < 100) {
                        return 'จำนวนเงินที่ต้องการถอนต้องไม่น้อยกว่า 100 บาท';
                      }
                      return null;
                    },
                    decoration: getInputDecoration('กรอกจำนวนเงิน'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
