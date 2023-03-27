import 'dart:io';

import 'package:coursez/controllers/auth_controller.dart';
import 'package:coursez/utils/color.dart';
import 'package:coursez/view_model/auth_view_model.dart';
import 'package:coursez/view_model/profile_view_model.dart';
import 'package:coursez/widgets/button/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../model/course.dart';
import '../model/user.dart';
import '../widgets/rating/rating.dart';
import '../widgets/text/title14px.dart';
import '../widgets/text/title16px.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Widget notLoginUI() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text("กรุณาเข้าสู่ระบบเพื่อดูรายละเอียดโปรไฟล์"),
        const SizedBox(
          height: 15,
        ),
        Bt(
          onPressed: () {
            Get.toNamed('/login');
          },
          text: "ลงทะเบียน / เข้าสู่ระบบ",
          color: primaryColor,
        )
      ],
    );
  }

  ProfileViewModel profileViewModel = ProfileViewModel();
  AuthController authController = Get.find();
  File? image;

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);

      if (image == null) return;

      final imageTemp = File(image.path);

      setState(() => this.image = imageTemp);
    } on PlatformException catch (e) {
      debugPrint("Fail to pick image : $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (authController.isLogin) {
        return FutureBuilder(
          future: ProfileViewModel().fetchUser(authController.userid),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return showprofile(snapshot.data);
            } else {
              return const Center(child: CircularProgressIndicator(color: primaryColor,));
            }
          },
        );
      } else {
        return notLoginUI();
      }
    });
  }

  Widget showprofile(User user) {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                child: InkWell(
                  onTap: () {
                    // Get.toNamed('/reward');
                  },
                  child: Row(
                    children: [
                      const Icon(Icons.star),
                      Title16px(text: "${user.point}  แต้ม")
                    ],
                  ),
                ),
              ),
              IconButton(
                  color: Colors.red,
                  onPressed: (() {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text("ออกจากระบบ"),
                            content:
                                const Text("คุณต้องการออกจากระบบใช่หรือไม่"),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Get.back();
                                  },
                                  child: const Title14px(
                                      text: 'ยกเลิก', color: greyColor)),
                              TextButton(
                                  onPressed: () {
                                    AuthViewModel().logout();
                                    Get.offAllNamed('/first');
                                  },
                                  child: const Title14px(
                                      text: "ออกจากระบบ", color: Colors.red))
                            ],
                          );
                        });
                  }),
                  icon: const Icon(Icons.logout))
            ],
          ),
          Container(
            decoration: const BoxDecoration(color: whiteColor),
            child: Center(
                child: image != null
                    ? Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(15),
                            child: ClipOval(
                                child: Image.file(
                              image!,
                              height: 120,
                              width: 120,
                              fit: BoxFit.cover,
                            )),
                          ),
                          Positioned(
                            top: 10,
                            left: 75,
                            child: RawMaterialButton(
                              onPressed: () {
                                pickImage();
                              },
                              elevation: 2.0,
                              fillColor: primaryColor,
                              padding: const EdgeInsets.all(15),
                              shape: const CircleBorder(),
                              child: const Icon(
                                color: Colors.white,
                                Icons.edit,
                                size: 25,
                              ),
                            ),
                          )
                        ],
                      )
                    : InkWell(
                        onTap: () {
                          pickImage();
                        },
                        child: Container(
                          height: 100,
                          decoration: const BoxDecoration(
                              color: greyColor, shape: BoxShape.circle),
                          child: const Center(
                            child: Icon(
                              Icons.add_a_photo_outlined,
                              size: 50,
                            ),
                          ),
                        ),
                      )),
          ),
          Title16px(text: authController.username),
          Title14px(text: user.fullName),
          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: const <Widget>[
              Text(
                "4",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Text(
                "Posts",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
          const TabBar(
              labelColor: blackColor,
              labelStyle: TextStyle(fontWeight: FontWeight.bold),
              tabs: [
                Tab(text: "ประวัติ"),
                Tab(text: "คอร์สที่ถูกใจ"),
                Tab(text: "ดาวน์โหลด"),
              ]),
          Expanded(
              child: TabBarView(
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                const Text("1"),
                courseprofile(user.likeCourses),
                const Text("3"),
              ])),
        ],
      ),
    );
  }

  Widget courseprofile(
    List<Course> data,
  ) {
    return Wrap(
      alignment: WrapAlignment.center,
      children: data
          .map((e) => InkWell(
                onTap: () {
                  Get.toNamed(
                    '/course/${e.courseId}',
                  );
                },
                child: Container(
                  width: 160,
                  height: 150,
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: whiteColor,
                      border: Border.all(color: greyColor, width: 0.6),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
                        BoxShadow(
                          color: greyColor,
                          blurRadius: 5,
                          offset: Offset(0, 1),
                        )
                      ]),
                  // visualDensity: const VisualDensity(vertical: 4),
                  // contentPadding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: Image.network(
                          e.picture,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 8.0,
                          top: 8.0,
                          right: 8.0,
                        ),
                        child: Title14px(text: e.coursename),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 8.0,
                        ),
                        child: RatingStar(
                          rating: e.rating,
                          size: 20,
                        ),
                      )
                    ],
                  ),
                ),
              ))
          .toList(),
    );
  }
}
