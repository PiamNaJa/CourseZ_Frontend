import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';

class Textformfield extends StatefulWidget {
  final Icon icon;
  final String hintText;
  final String labelText;
  final TextInputType keyboardType;
  final bool obscure;
  final TextEditingController controller;

  TextEditingController get textFormController => controller;

  const Textformfield(
      {super.key,
      required this.icon,
      required this.hintText,
      required this.labelText,
      required this.keyboardType,
      required this.obscure,
      required this.controller
    });
      

  @override
  State<Textformfield> createState() => _TextformfieldState();
}

class _TextformfieldState extends State<Textformfield> {
  @override
  void initState() {
    super.initState();

    widget.controller.addListener((){

    });
  }

  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: TextFormField(
          // controller: _controller,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            icon: widget.icon,
            hintText: widget.hintText,
            labelText: widget.labelText,
            // errorText: '${widget.labelText}ไม่ถูกต้อง',
          ),
          controller: widget.controller,
          keyboardType: widget.keyboardType,
          obscureText: widget.obscure,
          validator:
              RequiredValidator(errorText: '${widget.labelText}ไม่ถูกต้อง')),
    );
  }
}
