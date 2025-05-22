// ignore_for_file: must_be_immutable, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theming/colors/_colors.dart';

class MCQTextfield extends StatelessWidget {
  MCQTextfield(
      {super.key,
      this.controller,
      this.hintText,
      this.onChanged,
      this.width,
      this.inputFormatters});

  final TextEditingController? controller;
  final String? hintText;
  void Function(String)? onChanged;
  final List<TextInputFormatter>? inputFormatters;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: width ?? double.infinity,
      child: TextField(
        inputFormatters: inputFormatters,
        onChanged: onChanged,
        controller: controller,
        decoration: InputDecoration(
          labelText: hintText,
          border: InputBorder.none,
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                  color: AppColors.primary.withOpacity(.5), width: 2)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                  color: AppColors.black.withOpacity(.15), width: 2)),
        ),
      ),
    );
  }
}
