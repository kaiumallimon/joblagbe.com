import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../core/theming/colors/_colors.dart';
import '../../controllers/_recruiter_profile_controller.dart';

class CustomGenderSelector extends StatelessWidget {
  const CustomGenderSelector({
    super.key,
    required this.isEditable,
    required this.hintText,
  });

  final bool isEditable;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    final RecruiterProfileController controller = Get.find();

    return Obx(() => DropdownButtonFormField<String>(
          value: controller.selectedGender.value,
          decoration: InputDecoration(
            labelText: hintText,
            filled: !isEditable,
            fillColor: isEditable
                ? Colors.transparent
                : AppColors.black.withOpacity(.05),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:
                  BorderSide(color: AppColors.black.withOpacity(.15), width: 2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:
                  BorderSide(color: AppColors.black.withOpacity(.15), width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: AppColors.primary, width: 2),
            ),
          ),
          icon: Icon(
            Icons.arrow_drop_down,
            color: isEditable ? AppColors.black.withOpacity(.5) : Colors.grey,
          ),
          isExpanded: true,
          onChanged: isEditable
              ? (String? newValue) {
                  if (newValue != null) {
                    controller.selectedGender.value = newValue;
                  }
                }
              : null, // Disables dropdown if not editable
          items: controller.genders.map((String gender) {
            return DropdownMenuItem<String>(
              value: gender,
              child: Text(
                gender,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            );
          }).toList(),
        ));
  }
}
