import 'package:coursez/controllers/choice_controller.dart';
import 'package:coursez/model/choice.dart';
import 'package:coursez/model/exercise.dart';
import 'package:coursez/utils/color.dart';
import 'package:coursez/view_model/exercise_view_model.dart';
import 'package:coursez/widgets/button/button.dart';
import 'package:coursez/widgets/text/body14px.dart';
import 'package:coursez/widgets/text/body16.dart';
import 'package:coursez/widgets/text/heading1_24px.dart';
import 'package:coursez/widgets/text/heading2_20px.dart';
import 'package:coursez/widgets/text/title16px.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExerciseResultPage extends StatelessWidget {
  const ExerciseResultPage({super.key});
  @override
  Widget build(BuildContext context) {
    final Map<String, Object> dataArguments = Get.arguments;
    final double correctPercentage =
        dataArguments["correctPercentage"] as double;
    final Map<int, Choice> userSelectedChoice =
        dataArguments["userselectedchoice"] as Map<int, Choice>;
    final int points = dataArguments["points"] as int;
    final int correctCount = dataArguments["correctCount"] as int;
    final List<Exercise> exercise =
        dataArguments["exercises"] as List<Exercise>;
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: const Heading20px(text: "แบบทดสอบหลังเรียน"),
        backgroundColor: whiteColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: primaryColor),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Heading24px(text: "คะแนนของคุณ"),
                Heading24px(
                  text: "$correctCount/${exercise.length}",
                  color: primaryColor,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                      color: tertiaryColor,
                      borderRadius: BorderRadius.circular(25)),
                  child: Heading24px(color: whiteColor, text: "+ $points P"),
                ),
                ListView.separated(
                  separatorBuilder: (context, index) => const Divider(
                    color: secondaryColor,
                    thickness: 1.5,
                  ),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: exercise.length,
                  itemBuilder: (context, index) {
                    return resultExerciseList(
                        exercise[index], userSelectedChoice);
                  },
                ),
                const Divider(
                  color: secondaryColor,
                  thickness: 1.5,
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Bt(
                          text: "กลับไปหน้าคอร์ส",
                          color: primaryColor,
                          onPressed: () {
                            Get.back();
                            Get.back();
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Bt(
                          text: "รีวิววิดีโอ",
                          color: secondaryColor,
                          onPressed: () {
                            Get.toNamed(
                                "/course/${Get.parameters["course_id"]!}/video/${Get.parameters["video_id"]!}/review");
                          },
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          )),
    );
  }

  Widget resultExerciseList(
      Exercise exercise, Map<int, Choice> userSelectedChoice) {
    final Choice correctChoice =
        exercise.choices.firstWhere((element) => element.correct == true);
    final bool isCorrect =
        userSelectedChoice[exercise.exerciseId]?.title == correctChoice.title;
    return Column(
      children: [
        ListTile(
          title: Title16px(text: exercise.question),
        ),
        if (exercise.image.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Image.network(
              exercise.image,
              fit: BoxFit.cover,
              height: 200,
            ),
          ),
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: ((context, index) {
            return RadioListTile(
              activeColor: isCorrect ? primaryColor : Colors.red,
              title: Body14px(text: exercise.choices[index].title),
              value: exercise.choices[index],
              groupValue: userSelectedChoice[exercise.exerciseId],
              onChanged: (_) {},
            );
          }),
          itemCount: exercise.choices.length,
          shrinkWrap: true,
        ),
        if (!isCorrect) ...[
          const Divider(
            color: secondaryColor,
            thickness: 1.5,
          ),
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              alignment: Alignment.centerLeft,
              child: Text(
                "คำตอบที่ถูกต้องคือ ${correctChoice.title}",
                style: const TextStyle(
                    color: primaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ))
        ]
      ],
    );
  }
}
