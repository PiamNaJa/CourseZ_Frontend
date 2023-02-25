import 'package:coursez/controllers/choice_controller.dart';
import 'package:coursez/model/choice.dart';
import 'package:coursez/model/exercise.dart';
import 'package:coursez/utils/color.dart';
import 'package:coursez/view_model/exercise_view_model.dart';
import 'package:coursez/widgets/button/button.dart';
import 'package:coursez/widgets/text/body14px.dart';
import 'package:coursez/widgets/text/heading2_20px.dart';
import 'package:coursez/widgets/text/title16px.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExercisePage extends StatelessWidget {
  const ExercisePage({super.key});
  @override
  Widget build(BuildContext context) {
    final ChoiceController choiceController = Get.put(ChoiceController());
    onSubmit(List<Exercise> exercise) {
      final userSelectedChoice = choiceController.getchoice;
      for (final choice in userSelectedChoice.values) {
        if (choice.correct) {
          choiceController.correctCount++;
        }
      }
      final correctPercentage =
          (choiceController.correctCount / exercise.length) * 100;
      if (correctPercentage < 50) {
        choiceController.points = 3;
      } else if (correctPercentage >= 50 && correctPercentage < 70) {
        choiceController.points = 5;
      } else if (correctPercentage >= 70 && correctPercentage < 100) {
        choiceController.points = 7;
      } else {
        choiceController.points = 10;
      }
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: const Heading20px(text: "Exercise Page"),
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
        child: FutureBuilder(
          future: ExerciseViewModel().fetchExercise(
              Get.parameters["course_id"]!, Get.parameters["video_id"]!),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              final List<Exercise> exercise = snapshot.data as List<Exercise>;
              return SingleChildScrollView(
                child: Column(
                  children: [
                    ListView.separated(
                      separatorBuilder: (context, index) => const Divider(
                        color: secondaryColor,
                        thickness: 1.5,
                      ),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: exercise.length,
                      itemBuilder: (context, index) {
                        return ExerciseList(exercise: exercise[index]);
                      },
                    ),
                    Obx(() => ElevatedButton(
                        onPressed: choiceController.getchoice.values.isNotEmpty
                            ? onSubmit(exercise)
                            : null,
                        style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor),
                        child: const Text("ส่งคำตอบ"))),
                  ],
                ),
              );
            }
            return const Center(
                child: CircularProgressIndicator(
              color: primaryColor,
            ));
          },
        ),
      ),
    );
  }
}

class ExerciseList extends StatefulWidget {
  final Exercise exercise;

  const ExerciseList({super.key, required this.exercise});

  @override
  State<ExerciseList> createState() => _ExerciseListState();
}

class _ExerciseListState extends State<ExerciseList> {
  final ChoiceController choiceController = Get.find<ChoiceController>();
  Choice? _selectedChoice;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Title16px(text: widget.exercise.question),
        ),
        if (widget.exercise.image.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Image.network(
              widget.exercise.image,
              fit: BoxFit.cover,
              height: 200,
            ),
          ),
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: ((context, index) {
            return RadioListTile(
              activeColor: secondaryColor,
              title: Body14px(text: widget.exercise.choices[index].title),
              value: widget.exercise.choices[index],
              groupValue: _selectedChoice,
              onChanged: (value) {
                setState(() {
                  choiceController.setchoice(
                      widget.exercise.exerciseId, value!);
                  _selectedChoice = value;
                });
              },
            );
          }),
          itemCount: widget.exercise.choices.length,
          shrinkWrap: true,
        ),
      ],
    );
  }
}
