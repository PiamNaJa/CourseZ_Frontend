import 'package:coursez/model/video.dart';
import 'package:coursez/widgets/rating/rating.dart';
import 'package:coursez/widgets/text/body10px.dart';
import 'package:coursez/widgets/text/body16.dart';
import 'package:coursez/widgets/text/heading2_20px.dart';
import 'package:coursez/widgets/text/title12px.dart';
import 'package:coursez/widgets/text/title16px.dart';
import 'package:flutter/material.dart';
import 'package:coursez/utils/color.dart';
import 'package:video_player/video_player.dart';

class VideoPage extends StatefulWidget {
  const VideoPage({super.key});

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  bool isFocus = false;
  late VideoPlayerController _controller;
  late Future<void> _video;

  Video video = Video(
      videoId: 1,
      courseId: 1,
      videoName: "จำนวนเต็มเเละการบวกจำนวนเต็ม",
      price: 0,
      picture: "https://i.ytimg.com/vi/unXOuA0PkCQ/maxresdefault.jpg",
      description:
          "จำนวนเต็ม ม.1 EP.1/3 | ทบทวนพื้นฐานจำนวนเต็ม และ การบวกจำนวนเต็ม เป็นคลิปสอนตั้งแต่พื้นฐานของจำนวนเต็ม ม.1 และการบวกจำนวนเต็มแบบละเอียด ",
      url:
          "https://firebasestorage.googleapis.com/v0/b/coursez-50fb3.appspot.com/o/Course%2FCourse_1%2FVideo_1%2F%E0%B8%88%E0%B8%B3%E0%B8%99%E0%B8%A7%E0%B8%99%E0%B9%80%E0%B8%95%E0%B9%87%E0%B8%A1%20%E0%B8%A1.1%20EP.1_3%20_%20%E0%B8%97%E0%B8%9A%E0%B8%97%E0%B8%A7%E0%B8%99%E0%B8%9E%E0%B8%B7%E0%B9%89%E0%B8%99%E0%B8%90%E0%B8%B2%E0%B8%99%E0%B8%88%E0%B8%B3%E0%B8%99%E0%B8%A7%E0%B8%99%E0%B9%80%E0%B8%95%E0%B9%87%E0%B8%A1%20%E0%B9%81%E0%B8%A5%E0%B8%B0%20%E0%B8%81%E0%B8%B2%E0%B8%A3%E0%B8%9A%E0%B8%A7%E0%B8%81%E0%B8%88%E0%B8%B3%E0%B8%99%E0%B8%A7%E0%B8%99%E0%B9%80%E0%B8%95%E0%B9%87%E0%B8%A1.mp4?alt=media&token=b1e9102e-d19f-4b58-9849-3ec18a809300",
      sheet:
          "https://firebasestorage.googleapis.com/v0/b/coursez-50fb3.appspot.com/o/Course%2FCourse_1%2FVideo_1%2F%E0%B8%8A%E0%B8%B5%E0%B8%97%E0%B8%88%E0%B8%B3%E0%B8%99%E0%B8%A7%E0%B8%99%E0%B9%80%E0%B8%95%E0%B9%87%E0%B8%A1%20%E0%B8%A1.1%20(course_1-Video_1).pdf?alt=media&token=20bb4339-a353-4c68-918b-c6a39cc7ba27",
      createdAt: DateTime.now());

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(video.url);
    _video = _controller.initialize().then((value) {
      setState(() {
        _controller.play();
      });
    });
    debugPrint(_controller.dataSource);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Heading20px(text: video.videoName),
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: primaryColor),
          onPressed: () {
            // Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 200,
              width: double.infinity,
              // decoration: const BoxDecoration(color: blackColor),
              child: FutureBuilder(
                  future: _video,
                  builder: ((context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: VideoPlayer(_controller),
                      );
                    }
                    return Container(
                      alignment: Alignment.center,
                      width: 30,
                      height: 30,
                      child: const CircularProgressIndicator(
                        color: primaryColor,
                      ),
                    );
                  })),
            ),
            Container(
              decoration: const BoxDecoration(color: Colors.grey),
              child: Container(
                  padding: const EdgeInsets.all(15),
                  child: Text(video.description)),
            ),
            SizedBox(
              height: 70,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.assignment,
                    color: primaryColor,
                    size: 30,
                  ),
                  TextButton(
                      onPressed: () {},
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 3),
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: const Title16px(
                          text: 'เอกสารประกอบการเรียน',
                          color: whiteColor,
                        ),
                      ))
                ],
              ),
            ),
            Container(
                decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 235, 235, 235),
                    border: Border(
                        top: BorderSide(color: greyColor),
                        bottom: BorderSide(color: greyColor))),
                padding: const EdgeInsets.fromLTRB(15, 0, 15, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Title16px(text: 'Smart Focus'),
                        Switch(
                            value: isFocus,
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            activeColor: primaryColor,
                            onChanged: (bool value) {
                              setState(() {
                                isFocus = value;
                              });
                            })
                      ],
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: const Text(
                        'เทคโนโลยีที่จะช่วยคุณให้การเรียนของคุณมีประสิทธิภาพที่ดีขึ้น ด้วยระบบ AI ตรวจจับพฤติกรรมระหว่างเรียน',
                        style: TextStyle(fontFamily: 'Athiti', fontSize: 10),
                      ),
                    )
                  ],
                )),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Heading20px(text: 'ทำแบบทดสอบหลังเรียนได้นี่'),
                        Heading20px(
                          text: '*',
                          color: tertiaryColor,
                        )
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      height: 40,
                      decoration: BoxDecoration(
                          border: Border.all(color: greyColor),
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Title12px(text: video.videoName),
                          TextButton(
                              onPressed: () {},
                              child: const Text(
                                'ทำแบบทดสอบ',
                                style: TextStyle(
                                    fontFamily: 'Athiti',
                                    fontSize: 12,
                                    color: blackColor,
                                    fontWeight: FontWeight.w700,
                                    height: 1.5,
                                    decoration: TextDecoration.underline),
                              ))
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(5),
                      child: Body10px(
                        text:
                            '*นักเรียนจะต้องเรียนคลิปให้จบก่อนจึงจะสามารถทำแบบทดสอบได้',
                        color: tertiaryColor,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Heading20px(text: 'ติวเตอร์'),
                          Padding(
                            padding: const EdgeInsets.all(5),
                            child: Row(
                              children: [
                                ClipOval(
                                  child: Image.network(
                                    video.picture,
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                TextButton(
                                    onPressed: () {},
                                    child: const Text(
                                      'ติวเตอร์',
                                      style: TextStyle(
                                          fontFamily: 'Athiti',
                                          fontSize: 16,
                                          color: blackColor,
                                          fontWeight: FontWeight.w700,
                                          height: 1.5,
                                          decoration: TextDecoration.underline),
                                    ))
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      decoration: const BoxDecoration(
                          border: Border(bottom: BorderSide(color: greyColor))),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Heading20px(text: 'รีวิว'),
                          Center(
                            child: ratingStar(rating: 5),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     if (_controller.value.isPlaying) {
      //       setState(() {
      //         _controller.pause();
      //       });
      //     } else {
      //       setState(() {
      //         _controller.play();
      //       });
      //     }
      //   },
      //   child: const Icon(Icons.play_arrow_rounded),
      // ),
    );
  }
}
