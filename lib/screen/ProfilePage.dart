import 'package:coursez/controllers/auth_controller.dart';
import 'package:coursez/utils/color.dart';
import 'package:coursez/view_model/profile_view_model.dart';
import 'package:coursez/widgets/button/button.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    ProfileViewModel profileViewModel = ProfileViewModel();
    AuthController authController = Get.find();
    return Container(
        decoration: const BoxDecoration(color: whiteColor),
        child: Container(
          child: (authController.isLogin)
              ? FutureBuilder(
                  future: profileViewModel.fetchUser(authController.userid),
                  builder: (context, snapshot) {
                    return SizedBox(
                      width: 200,
                      height: 100,
                      child: Bt(
                        text: 'rewards',
                        color: primaryColor,
                        onPressed: (() => {Get.toNamed('/reward')}),
                      ),
                    );
                  },
                )
              : const Center(
                  child: Text('Please Login'),
                ),
        ));
  }
}
