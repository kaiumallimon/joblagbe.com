import 'package:flutter/material.dart';

import '../theming/colors/_colors.dart';

class CustomTextfield extends StatelessWidget {
  const CustomTextfield(
      {super.key,
      this.hintText,
      this.labelText,
      this.prefixIcon,
      required this.width,
      required this.height,
      required this.isPassword,
      this.keyboardType,
      this.controller,
      this.onChanged});

  final String? hintText;
  final String? labelText;
  final IconData? prefixIcon;
  final double width;
  final double height;
  final bool isPassword;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        keyboardType: keyboardType,
        obscureText: isPassword,
        decoration: InputDecoration(
          hintText: hintText,
          labelText: labelText,
          prefixIcon: Icon(prefixIcon),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: AppColors.primary, width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: AppColors.primary, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
                color: AppColors.darkPrimary.withOpacity(.2), width: 2),
          ),
        ),
      ),
    );
  }
}
