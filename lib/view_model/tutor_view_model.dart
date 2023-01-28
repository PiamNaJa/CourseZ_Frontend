import 'package:coursez/model/user.dart';
import 'package:coursez/utils/fetchData.dart';
import 'package:flutter/material.dart';

class TutorViewModel {
  Future<List<dynamic>> loadTutor(int level) async {
    List<dynamic> tutorLevel = [];
    if (level != 0) {
      final t = await fecthData('user/teacher/class/$level');
      debugPrint(t.toString());
      t.map((e) => tutorLevel.add(e)).toList();
      
    } else {
      final t = await fecthData('user/teacher');
      t.forEach((e) => tutorLevel.add(e));
    }

    return tutorLevel;
  }
}
