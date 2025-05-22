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
      this.iconSize = 20,
      this.controller,
      this.iconColor,
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
  final double iconSize;
  final Color? iconColor;

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
          prefixIcon: Icon(prefixIcon, size: iconSize, color: iconColor),
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
                color: AppColors.darkPrimary.withOpacity(.15), width: 2),
          ),
        ),
      ),
    );
  }
}

class CustomDescriptionField extends StatelessWidget {
  const CustomDescriptionField({
    super.key,
    required this.controller,
    this.hintText,
    this.labelText,
    this.prefixIcon,
    this.height = 300,
    this.width,
    this.onChanged,
  });

  final TextEditingController controller;
  final String? hintText;
  final String? labelText;
  final IconData? prefixIcon;
  final double height;
  final double? width;
  final Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.black.withOpacity(.15), width: 2),
      ),
      width: width ?? double.infinity,
      height: height,
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        maxLines: null,
        decoration: InputDecoration(
          prefixIcon: Icon(
            prefixIcon,
            size: 20,
          ),
          hintText: hintText,
          labelText: labelText,
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(10),
        ),
      ),
    );
  }
}
