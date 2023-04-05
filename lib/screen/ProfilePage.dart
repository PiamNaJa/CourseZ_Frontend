import 'dart:io';

import 'package:coursez/controllers/auth_controller.dart';
import 'package:coursez/model/video.dart';
import 'package:coursez/utils/color.dart';
import 'package:coursez/view_model/auth_view_model.dart';
import 'package:coursez/view_model/course_view_model.dart';
import 'package:coursez/view_model/post_view_model.dart';
import 'package:coursez/view_model/profile_view_model.dart';
import 'package:coursez/widgets/button/button.dart';
import 'package:coursez/widgets/text/heading2_20px.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:coursez/utils/inputDecoration.dart';
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

  final formkey = GlobalKey<FormState>();
  final AuthViewModel authViewModel = AuthViewModel();
  CourseViewModel courseViewModel = CourseViewModel();
  ProfileViewModel profileViewModel = ProfileViewModel();
  AuthController authController = Get.find();

  onSubmit(File? image) async {
    if (formkey.currentState!.validate()) {
      formkey.currentState!.save();
      profileViewModel.updateUser(image, users);
    }
  }

  @override
  void initState() {
    super.initState();
    users.role = authController.role;
  }

  User users = User(
      email: '',
      password: '',
      fullName: '',
      nickName: '',
      role: '',
      picture: '',
      point: 0,
      likeCourses: [],
      likeVideos: [],
      paidVideos: [],
      videoHistory: [],
      courseHistory: []);

  Future<File?> pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);

      if (image == null) return null;

      final imageTemp = File(image.path);

      return imageTemp;
    } on PlatformException catch (e) {
      debugPrint("Fail to pick image : $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      authController.picture;
      if (authController.isLogin) {
        return FutureBuilder(
          future: ProfileViewModel().fetchUser(authController.userid),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return showprofile(snapshot.data);
            } else {
              return const Center(
                  child: CircularProgressIndicator(
                color: primaryColor,
              ));
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  child: InkWell(
                    onTap: () {
                      Get.toNamed('/reward');
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 110,
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        decoration: const BoxDecoration(
                            color: Color.fromARGB(173, 255, 230, 118),
                            borderRadius:
                                BorderRadius.all(Radius.circular(25.0)),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey,
                                  blurRadius: 10, // shadow radius
                                  offset: Offset(2, 4), // shadow offset
                                  spreadRadius:
                                      0.1, // The amount the box should be inflated prior to applying the blur
                                  blurStyle: BlurStyle.normal)
                            ]),
                        child: Center(
                          child: Row(
                            children: [
                              const Icon(Icons.star),
                              Title16px(
                                text: "  ${user.point}  แต้ม",
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              if (authController.teacherId != -1)
                InkWell(
                  onTap: () {
                    Get.toNamed('/withdraw');
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 80),
                    child: Container(
                      width: 110,
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      decoration: const BoxDecoration(
                          color: Color.fromARGB(172, 0, 253, 97),
                          borderRadius: BorderRadius.all(Radius.circular(25.0)),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey,
                                blurRadius: 10, // shadow radius
                                offset: Offset(2, 4), // shadow offset
                                spreadRadius:
                                    0.1, // The amount the box should be inflated prior to applying the blur
                                blurStyle: BlurStyle.normal)
                          ]),
                      child: Center(
                        child: Row(
                          children: [
                            const Icon(Icons.attach_money_outlined),
                            Title16px(
                              text: "  ${user.userTeacher!.money}   บาท",
                            )
                          ],
                        ),
                      ),
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
            decoration: const BoxDecoration(
              color: Colors.transparent,
            ),
            child: Center(
                child: user.picture.isNotEmpty
                    ? Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(15),
                            child: Container(
                                decoration: const BoxDecoration(boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey,
                                      blurRadius: 10, // shadow radius
                                      offset: Offset(4, 4), // shadow offset
                                      spreadRadius:
                                          0.1, // The amount the box should be inflated prior to applying the blur
                                      blurStyle: BlurStyle.normal)
                                ]),
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10.0)),
                                  child: Image.network(
                                    user.picture,
                                    height: 100,
                                    width: 100,
                                    fit: BoxFit.cover,
                                  ),
                                )),
                          ),
                          Positioned(
                            top: 80,
                            left: 64,
                            child: RawMaterialButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: ((context) {
                                      File? image;
                                      return Dialog(
                                        child: StatefulBuilder(
                                            builder: (context, ssetState) {
                                          return SingleChildScrollView(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(20.0),
                                              child: Form(
                                                key: formkey,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Center(
                                                        child: image != null
                                                            ? Image.file(
                                                                image!,
                                                                height: 150,
                                                                width: 150,
                                                                fit: BoxFit
                                                                    .cover,
                                                              )
                                                            : Image.network(
                                                                user.picture,
                                                                height: 150,
                                                                width: 150,
                                                                fit: BoxFit
                                                                    .cover,
                                                              )),
                                                    Center(
                                                      child: ElevatedButton(
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            disabledBackgroundColor:
                                                                primaryLighterColor,
                                                            backgroundColor:
                                                                primaryColor,
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5),
                                                            ),
                                                          ),
                                                          onPressed: (() {
                                                            pickImage().then(
                                                                (value) =>
                                                                    ssetState(
                                                                      () {
                                                                        image =
                                                                            value;
                                                                      },
                                                                    ));
                                                          }),
                                                          child: const Text(
                                                              "เปลี่ยนรูป")),
                                                    ),
                                                    const Title16px(
                                                        text: "ชื่อที่แสดง"),
                                                    TextFormField(
                                                      decoration: getInputDecoration('ชื่อที่แสดง'),
                                                      autovalidateMode:
                                                          AutovalidateMode
                                                              .onUserInteraction,
                                                      validator:
                                                          MultiValidator([
                                                        RequiredValidator(
                                                            errorText:
                                                                "โปรดกรอกชื่อของคุณ"),
                                                      ]),
                                                      onChanged:
                                                          (String? nickName) {
                                                        users.nickName =
                                                            nickName!;
                                                      },
                                                      initialValue:
                                                          user.nickName,
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    const Title16px(
                                                        text: "ชื่อจริง"),
                                                    TextFormField(
                                                      decoration: getInputDecoration('ชื่อจริง-นามสกุล'),
                                                      autovalidateMode:
                                                          AutovalidateMode
                                                              .onUserInteraction,
                                                      validator:
                                                          MultiValidator([
                                                        RequiredValidator(
                                                            errorText:
                                                                "โปรดกรอกชื่อของคุณ"),
                                                      ]),
                                                      onChanged:
                                                          (String? fullName) {
                                                        users.fullName =
                                                            fullName!;
                                                      },
                                                      initialValue:
                                                          user.fullName,
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    const Title16px(
                                                        text: "อีเมล"),
                                                    TextFormField(
                                                      decoration: getInputDecoration('อีเมล'),
                                                      autovalidateMode: 
                                                          AutovalidateMode
                                                              .onUserInteraction,
                                                      validator:
                                                          MultiValidator([
                                                        RequiredValidator(
                                                            errorText:
                                                                "โปรดกรอกอีเมลของคุณ"),
                                                        EmailValidator(
                                                            errorText:
                                                                "อีเมลของคุณผิด")
                                                      ]),
                                                      onChanged:
                                                          (String? email) {
                                                        users.email = email!;
                                                      },
                                                      initialValue: user.email,
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(20.0),
                                                          child: ElevatedButton(
                                                              style:
                                                                  ElevatedButton
                                                                      .styleFrom(
                                                                disabledBackgroundColor:
                                                                    primaryLighterColor,
                                                                backgroundColor:
                                                                    Colors.red,
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5),
                                                                ),
                                                              ),
                                                              onPressed: (() {
                                                                Get.back();
                                                                image = null;
                                                              }),
                                                              child: const Text(
                                                                  "ยกเลิก")),
                                                        ),
                                                        ElevatedButton(
                                                            style:
                                                                ElevatedButton
                                                                    .styleFrom(
                                                              disabledBackgroundColor:
                                                                  primaryLighterColor,
                                                              backgroundColor:
                                                                  primaryColor,
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5),
                                                              ),
                                                            ),
                                                            onPressed: (() {
                                                              onSubmit(image);
                                                            }),
                                                            child: const Text(
                                                                "บันทึก")),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        }),
                                      );
                                    }));
                              },
                              elevation: 2.0,
                              fillColor: primaryColor,
                              padding: const EdgeInsets.all(10),
                              shape: const CircleBorder(),
                              child: const Icon(
                                color: Colors.white,
                                Icons.edit,
                                size: 20,
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
                              Icons.person,
                              size: 50,
                            ),
                          ),
                        ),
                      )),
          ),
          Title16px(text: authController.username),
          Title14px(
            text: 'ชื่อ: ${user.fullName}',
            color: greyColor,
          ),
          Title14px(
            text: 'อีเมล: ${user.email}',
            color: greyColor,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 10,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                if (authController.teacherId != -1)
                  Expanded(
                    child: Column(
                      children: [
                        Title16px(
                            text: user.userTeacher!.courses!.length.toString()),
                        const Title14px(
                          text: 'คอร์ส',
                          color: greyColor,
                        ),
                      ],
                    ),
                  ),
                Expanded(
                  child: Column(
                    children: [
                      FutureBuilder(
                          future: PostViewModel().loadPostByUser(),
                          builder: (context, AsyncSnapshot snapshot) {
                            if (snapshot.hasData) {
                              return Title16px(
                                  text: snapshot.data.length.toString());
                            } else {
                              return const Center(
                                  child: CircularProgressIndicator(
                                color: primaryColor,
                              ));
                            }
                          }),
                      const Title14px(
                        text: 'โพสต์',
                        color: greyColor,
                      ),
                    ],
                  ),
                ),
                if (authController.teacherId != -1)
                  Expanded(
                    child: Column(
                      children: [
                        Title16px(
                            text: user.userTeacher!.reviews!.length.toString()),
                        const Title14px(
                          text: 'รีวิว',
                          color: greyColor,
                        )
                      ],
                    ),
                  ),
              ],
            ),
          ),
          const TabBar(
              indicatorColor: primaryColor,
              labelColor: blackColor,
              labelStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'Athiti',
              ),
              tabs: [
                Tab(text: "ประวัติ"),
                Tab(text: "คอร์สที่ถูกใจ"),
                Tab(text: "วิดีโอที่ซื้อแล้ว"),
              ]),
          Expanded(
              child: TabBarView(
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: courseprofile(
                      user.courseHistory.map((e) => e.courses).toList()),
                ),
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: courseprofile(user.likeCourses),
                ),
                FutureBuilder(
                  future: profileViewModel.getPaidVideoObject(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return videohistory(snapshot.data!);
                    }
                    return const Center(
                        child: CircularProgressIndicator(
                      color: primaryColor,
                    ));
                  },
                ),
              ])),
        ],
      ),
    );
  }

  Widget courseprofile(
    List<Course> data,
  ) {
    if (data.isEmpty) {
      return const Center(
          child: Heading20px(
        text: "คุณยังไม่มีประวัติการดูและสิ่งที่สนใจ",
      ));
    }
    return GridView(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 16 / 14.5,
      ),
      children: data
          .map((e) => InkWell(
                onTap: () {
                  Get.toNamed(
                    '/course/${e.courseId}',
                  );
                },
                child: Container(
                  width: 160,
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
                          width: double.infinity,
                          height: 100,
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
                        padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
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

  Widget videohistory(
    List<Video> data,
  ) {
    if (data.isEmpty) {
      return const Center(
          child: Heading20px(
        text: "ยังไม่มีวิดีโอที่ซื้อแล้ว",
      ));
    }
    return ListView.separated(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: data.length,
      separatorBuilder: (context, _) => const SizedBox(
        height: 0,
      ),
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 7,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: ListTile(
            onTap: () async {
              final courseid =
                  await courseViewModel.loadCourseById(data[index].courseId);
              Get.toNamed(
                  '/course/${data[index].courseId}/video/${data[index].videoId}',
                  parameters: {
                    'video_name': data[index].videoName,
                    'teacher_id': courseid.teacherId.toString()
                  });
            },
            leading: ClipOval(
              child: Image.network(
                data[index].picture,
                height: 50,
                width: 50,
                fit: BoxFit.cover,
              ),
            ),
            title: Title14px(
              text: '${data[index].videoName} (${data[index].price})',
            ),
            trailing: const Icon(Icons.keyboard_arrow_right),
          ),
        ),
      ),
    );
  }
}
