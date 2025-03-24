import 'package:flutter/material.dart';

import '../../../../../../core/theming/colors/_colors.dart';

class CustomProfileTextBox extends StatelessWidget {
  const CustomProfileTextBox(
      {super.key,
      // this.text,
      this.label,
      required this.isEditable,
      this.controller,
      this.height = 50,
      required this.hintText,
      this.width = double.infinity,
      // required this.isEmpty,
      this.maxLines = 1,
      this.keyboardType});

  // final String? text;
  final String? label;
  final bool isEditable;
  final TextEditingController? controller;
  final double height;
  final double width;
  final String hintText;
  final TextInputType? keyboardType;
  final int? maxLines;
  // final bool? isEmpty;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: TextFormField(
        controller: controller,
        readOnly: !isEditable,
        // initialValue: text,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
            // suffixIcon: isEmpty == true
            //     ? Icon(
            //         Icons.error,
            //         color: Colors.red,
            //       )
            //     : null,
            labelText: label,
            filled: !isEditable,
            fillColor: AppColors.black.withOpacity(.05),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: AppColors.primary, width: 2)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                    color: AppColors.black.withOpacity(.2), width: 2)),
            labelStyle:
                TextStyle(color: isEditable ? AppColors.black : Colors.grey),
            border: InputBorder.none),
      ),
    );
  }
}
