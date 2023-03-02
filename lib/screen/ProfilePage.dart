import 'package:coursez/utils/color.dart';
import 'package:flutter/cupertino.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: whiteColor),
      child: Center(child: Text('Profile Page')),
    );
  }
}
