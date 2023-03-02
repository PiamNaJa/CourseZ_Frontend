import 'package:coursez/model/course.dart';
import 'package:coursez/widgets/rating/rating.dart';
import 'package:coursez/widgets/text/body12px.dart';
import 'package:coursez/widgets/text/title16px.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/level_controller.dart';
import '../model/search.dart';
import '../model/tutor.dart';
import '../utils/color.dart';
import '../view_model/course_view_model.dart';
import '../view_model/search_view_model.dart';
import '../view_model/tutor_view_model.dart';
import '../widgets/text/title14px.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

void updateList(String value) {}

class _SearchPageState extends State<SearchPage> {
  final Color _prefixIconColor = greyColor;
  CourseViewModel courseViewModel = CourseViewModel();
  TutorViewModel tutorViewModel = TutorViewModel();
  LevelController levelController = Get.put(LevelController());
  SearchViewModel searchViewModel = SearchViewModel();
  late Search searchAll;
  String searchText = '';
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          bottom: const TabBar(
              labelColor: blackColor,
              labelStyle: TextStyle(fontWeight: FontWeight.bold),
              tabs: [
                Tab(text: "ทั้งหมด"),
                Tab(text: "คอร์ส"),
                Tab(text: "วีดีโอ"),
                Tab(text: "ติวเตอร์"),
              ]),
          backgroundColor: Colors.transparent,
          title: TextField(
            onChanged: (value) {
              setState(() {
                searchText = value;
              });
            },
            autofocus: true,
            style: const TextStyle(fontFamily: 'Athiti'),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.zero,
              prefixIcon: Icon(
                Icons.search,
                color: _prefixIconColor,
              ),
              hintText: 'ค้นหา',
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(25.0)),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: primaryColor),
                borderRadius: BorderRadius.all(
                  Radius.circular(25.0),
                ),
              ),
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: primaryColor),
            onPressed: () {
              Get.back();
            },
          ),
        ),
        body: searchText.isNotEmpty
            ? FutureBuilder(
                future: searchViewModel.searchAll(searchText),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return TabBarView(children: [
                      SingleChildScrollView(
                        child: Column(
                          children: [
                            courselist(snapshot.data!.courses, false),
                            courselist(snapshot.data!.videos, true),
                            tutorlist(snapshot.data!.tutors),
                          ],
                        ),
                      ),
                      SingleChildScrollView(
                        child: courselist(snapshot.data!.courses, false),
                      ),
                      SingleChildScrollView(
                        child: courselist(snapshot.data!.videos, true),
                      ),
                      SingleChildScrollView(
                        child: tutorlist(snapshot.data!.tutors),
                      ),
                    ]);
                  }
                  return const Center(
                      child: CircularProgressIndicator(
                    color: primaryColor,
                  ));
                },
              )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.search,
                      size: 80,
                      color: greyColor,
                    ),
                    Title16px(
                      text: 'ค้นหา',
                      color: greyColor,
                    )
                  ],
                ),
              ),
      ),
    );
  }

  Widget courselist(List<Course> data, bool withVideo) {
    return ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        separatorBuilder: (context, index) => const Divider(
              color: Colors.black,
              height: 0,
            ),
        itemCount: data.length,
        itemBuilder: (context, index) => Container(
              margin: const EdgeInsets.all(15),
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
              child: Column(
                children: [
                  ListTile(
                    onTap: () {
                      Get.toNamed(
                        '/course/${data[index].courseId}',
                      );
                    },
                    visualDensity: const VisualDensity(vertical: 4),
                    contentPadding: const EdgeInsets.all(15),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Image.network(
                        data[index].picture,
                        height: 100,
                        width: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Body12px(text: data[index].coursename),
                        RatingStar(
                          rating: data[index].rating,
                          size: 20,
                        ),
                      ],
                    ),
                    title: Title16px(text: data[index].coursename),
                  ),
                  if (withVideo) videoList(data[index]),
                ],
              ),
            ));
  }

  Widget videoList(Course item) {
    return Container(
      color: const Color.fromARGB(255, 233, 233, 233),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: item.videos.length,
            itemBuilder: (context, index) => ListTile(
                  onTap: () {
                    Get.toNamed(
                        '/course/${item.courseId}/video/${item.videos[index].videoId}',
                        parameters: {
                          "video_name": item.videos[index].videoName,
                          "teacher_id": item.teacherId.toString()
                        });
                  },
                  contentPadding:
                      const EdgeInsets.only(top: 10, left: 15, right: 15),
                  leading: Image.network(
                    item.videos[index].picture,
                    height: 50,
                    width: 50,
                    fit: BoxFit.cover,
                  ),
                  title: Title14px(text: item.videos[index].videoName),
                )),
      ),
    );
  }

  Widget tutorlist(List<Tutor> item) {
    return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: item.length,
        itemBuilder: (context, index) => Container(
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
              child: ListTile(
                visualDensity: const VisualDensity(vertical: 4),
                contentPadding: const EdgeInsets.all(5),
                leading: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: CircleAvatar(
                    radius: 30,
                    child: ClipOval(
                      child: Image.network(
                        item[index].picture,
                        height: 100,
                        width: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                title: Title16px(text: item[index].nickname),
                subtitle: RatingStar(
                  rating: item[index].rating.toDouble(),
                  size: 20,
                ),
              ),
            ));
  }
}
