import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:joblagbe/app/data/models/_job_category_model.dart';

import '../../../../core/theming/colors/_colors.dart';
import '../../controllers/_recruiter_add_job_controller.dart';

class AddJobCategorySelector extends StatelessWidget {
  const AddJobCategorySelector({
    super.key,
    required this.controller,
  });

  final AddJobController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return DropdownButtonFormField(
        decoration: InputDecoration(
            labelText: 'Job Category',
            prefixIcon: Icon(Icons.category_outlined),
            focusedBorder: InputBorder.none,
            focusColor: Colors.transparent,
            hoverColor: Colors.transparent,
            fillColor: Colors.transparent,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                  color: AppColors.darkPrimary.withOpacity(.15), width: 2),
            ),
            filled: false),
        value: controller.selectedCategory.value,
        items: controller.categories.map((JobCategory category) {
          return DropdownMenuItem<JobCategory>(
            value: category,
            child: Text(category.name),
          );
        }).toList(),
        onChanged: (JobCategory? newValue) {
          controller.selectedCategory.value = newValue!;
        },
      );
    });
  }
}
