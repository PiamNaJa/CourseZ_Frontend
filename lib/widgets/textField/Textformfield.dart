import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class Textformfield extends StatefulWidget {
  final Icon icon;
  final String hintText;
  final String labelText;

  const Textformfield({
    super.key,
    required this.icon,
    required this.hintText,
    required this.labelText,
  });

  @override
  State<Textformfield> createState() => _TextformfieldState();
}

class _TextformfieldState extends State<Textformfield> {
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
          // errorText: 'กรุณากรอกให้ครบ',
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return 'กรุณากรอกให้ครบ';
          } else {
            return null;
          }
        },
      ),
    );
  }
}
