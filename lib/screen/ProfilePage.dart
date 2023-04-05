import 'package:coursez/controllers/auth_controller.dart';
import 'package:coursez/utils/color.dart';
import 'package:coursez/view_model/profile_view_model.dart';
import 'package:coursez/widgets/button/button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileViewModel profileViewModel = ProfileViewModel();
    final AuthController authController = Get.find();
    return Container(
        decoration: const BoxDecoration(color: whiteColor),
        child: (authController.isLogin)
            ? FutureBuilder(
                future: profileViewModel.fetchUser(authController.userid),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return SizedBox(
                    width: 200,
                    height: 100,
                    child: Bt(
                      text: 'withdraw',
                      color: primaryColor,
                      onPressed: (() => {
                            (snapshot.data!.userTeacher == null)
                                ? showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text('ไม่ใช่ครูจ้า'),
                                        content:
                                            const Text('ไปล็อคอินเป็นครูเนาะ'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Get.back();
                                            },
                                            child: const Text('โอเคเลอ'),
                                          ),
                                        ],
                                      );
                                    })
                                : Get.toNamed('/withdraw',
                                    ),
                          }),
                    ),
                  );
                },
              )
            : Center(
                child: Bt(
                    text: 'login',
                    color: primaryColor,
                    onPressed: (() => {Get.toNamed('/login')})),
              ));
  }
}
