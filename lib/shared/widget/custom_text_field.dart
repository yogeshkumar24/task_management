import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  TextEditingController controller;
  String? Function(String?)? validator;
  String hintText;
  Function(String)? onChanged;
  Widget? prefixIcon;
  bool readOnly = false;
  final VoidCallback? onTap;

  CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.validator,
    this.onChanged,
    this.readOnly = false,
    this.prefixIcon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: readOnly,
      controller: controller,
      onChanged: onChanged,
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onTap: onTap,
      decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
          prefixIcon: prefixIcon,
          hintText: hintText,
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)))),
    );
  }
}
