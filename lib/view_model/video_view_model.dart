import 'dart:isolate';

import 'package:camera/camera.dart';
import 'package:coursez/model/user.dart';
import 'package:coursez/model/userTeacher.dart';
import 'package:coursez/model/video.dart';
import 'package:coursez/repository/history_repository.dart';
import 'package:coursez/utils/camera_view_singleton.dart';
import 'package:coursez/utils/classifier.dart';
import 'package:coursez/utils/fetchData.dart';
import 'package:coursez/utils/isolate_utils.dart';
import 'package:coursez/utils/recognition.dart';
import 'package:coursez/view_model/date_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';
import '../repository/review_repository.dart';
import '../utils/color.dart';

class VideoViewModel {
  final ReviewRepository _reviewRepository = ReviewRepository();
  HistoryRepository historyRepository = HistoryRepository();
  Future<Video> loadVideoById(String courseid, String videoid) async {
    final v = await fecthData("course/$courseid/video/$videoid");

    return Video.fromJson(v);
  }

  double loadVideoRating(Video video) {
    double rating = 0;
    int count = 0;
    for (var i = 0; i < video.reviews.length; i++) {
      rating += video.reviews[i].rating;
      count++;
    }
    if (count != 0) return (rating / count);

    return 0;
  }

  int loadVideoRatingByStar(Video video, int star) {
    int count = 0;
    for (var i = 0; i < video.reviews.length; i++) {
      if (video.reviews[i].rating == star) count++;
    }
    return count;
  }

  double loadPercentRating(Video video, int star) {
    int count = 0;
    for (var i = 0; i < video.reviews.length; i++) {
      if (video.reviews[i].rating == star) count++;
    }
    if (video.reviews.isNotEmpty) {
      return (count / video.reviews.length);
    }

    return 0;
  }

  Future<User> getTeacherName(int teacherid) async {
    final t = await fecthData("user/teacher/$teacherid");
    final dynamic teacher = User.fromJson(t);

    return teacher;
  }

  double getTutorRating(UserTeacher teacher) {
    double rating = 0;
    if (teacher.reviews!.isEmpty) {
      return 0;
    } else {
      for (var i = 0; i < teacher.reviews!.length; i++) {
        rating += teacher.reviews![i].rating;
      }
      return (rating / teacher.reviews!.length);
    }
  }

  String formatReviewDate(int createdAt) {
    var date = DateTime.fromMillisecondsSinceEpoch(createdAt * 1000);
    return date.toString().substring(0, 16);
  }

  String formatVideoDate(int createdAt) {
    DateViewModel dateViewModel = DateViewModel();
    String timeago = dateViewModel.formatDate(createdAt);
    timeago = timeago.replaceAll(' ago', 'ที่แล้ว');

    return timeago;
  }

  Future<void> createReviewVideo(
      String videoId, double rating, String comment) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token')!;
    final bool isPass = await _reviewRepository.createReviewVideo(
        videoId, rating, comment, token);
    if (!isPass) {
      Get.snackbar('ผิดพลาด', 'มีบางอย่างผิดพลาด',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: whiteColor);
    } else {
      Get.back();
      Get.back();
      Get.back();
    }
  }

  Future<int> getVideoHistoryDuration(String videoId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token')!;
    final h = await fecthData("history/$videoId", authorization: token);
    if (h.runtimeType == String && h.contains("not found")) {
      return 0;
    }
    return h;
  }

  Future<void> addVideoHistory(String videoId, int duration) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token')!;
    final res =
        await historyRepository.addVideoHistory(videoId, duration, token);
    if (res.statusCode == 201) {
      print("add video history success");
    } else {
      throw Exception(res.body);
    }
  }
}

class SmartFocus {
  late Classifier classifier;
  late IsolateUtils isolateUtils;
  bool predicting = false;
  List<CameraDescription> cameras = [];
  CameraController? cameraController;
  List<Recognition> results = [];
  SmartFocus() {
    init();
  }
  void init() async {
    // Spawn a new isolate
    isolateUtils = IsolateUtils();
    await isolateUtils.start();

    final interpreter = await Interpreter.fromAsset("detect.tflite",
        options: InterpreterOptions()..threads = 1);
    final labels = await FileUtil.loadLabels("assets/labelmap.txt");

    // Create an instance of classifier to load model and labels
    classifier = Classifier(labels: labels, interpreter: interpreter);

    // Initially predicting = false
    predicting = false;
    cameras = await availableCameras();
  }

  Future<void> openCamera() async {
    // cameras[0] for rear-camera
    cameraController =
        CameraController(cameras[1], ResolutionPreset.low, enableAudio: false);

    await cameraController!.initialize();
    // Stream of image passed to [onLatestImageAvailable] callback
    // await cameraController!.startImageStream(onLatestImageAvailable);

    /// previewSize is size of each image frame captured by controller
    ///
    /// 352x288 on iOS, 240p (320x240) on Android with ResolutionPreset.low
    Size previewSize = cameraController!.value.previewSize!;

    /// previewSize is size of raw input image to the model
    CameraViewSingleton.inputImageSize = previewSize;

    // the display width of image on screen is
    // same as screenWidth while maintaining the aspectRatio
    Size screenSize = MediaQuery.of(Get.context!).size;
    CameraViewSingleton.screenSize = screenSize;
    CameraViewSingleton.ratio = screenSize.width / previewSize.height;
  }

  Future<void> startFocus(VoidCallback setStatefunc) async {
    await openCamera();
    await cameraController!.startImageStream(
        (image) => onLatestImageAvailable(image, setStatefunc));
  }

  Future<void> stopFocus() async {
    await cameraController!.dispose();
    cameraController = null;
  }

  /// Callback to receive each frame [CameraImage] perform inference on it
  onLatestImageAvailable(
      CameraImage cameraImage, VoidCallback setStatefunc) async {
    if (predicting) {
      return;
    }
    setStatefunc();
    predicting = true;

    // Data to be passed to inference isolate
    var isolateData = IsolateData(
        cameraImage, classifier.interpreter.address, classifier.labels);

    // We could have simply used the compute method as well however
    // it would be as in-efficient as we need to continuously passing data
    // to another isolate.

    /// perform inference in separate isolate
    Map<String, dynamic> inferenceResults = await inference(isolateData);

    // pass results to HomeView
    results = inferenceResults["recognitions"];

    // pass stats to HomeView

    // set predicting to false to allow new frames
    predicting = false;
    setStatefunc();
  }

  Future<Map<String, dynamic>> inference(IsolateData isolateData) async {
    final ReceivePort responsePort = ReceivePort();
    isolateUtils.sendPort
        .send(isolateData..responsePort = responsePort.sendPort);
    final results = await responsePort.first;
    responsePort.close();
    return results;
  }

  bool isHaveFace() {
    final f = results.where((element) => element.label == 'person').toList();
    return f.isNotEmpty;
  }
}
