import 'package:coursez/utils/inputDecoration.dart';
import 'package:flutter/material.dart';

class CustomTextForm extends StatelessWidget {
  final String title;
  final Function(String) onChanged;
  final String? Function(String?)? validator;
  final String? initialValue;
  final TextInputType keyboardType;

  const CustomTextForm(
      {super.key,
      required this.title,
      required this.onChanged,
      this.initialValue,
      this.keyboardType = TextInputType.text,
      this.validator});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        keyboardType: keyboardType,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: validator,
        onChanged: onChanged,
        initialValue: initialValue,
        decoration: getInputDecoration(title));
  }
}
