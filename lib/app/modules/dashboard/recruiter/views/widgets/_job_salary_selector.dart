import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/theming/colors/_colors.dart';
import '../../controllers/_recruiter_add_job_controller.dart';

class AddJobSalarySelector extends StatelessWidget {
  const AddJobSalarySelector({
    super.key,
    required this.controller,
  });

  final AddJobController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return DropdownButtonFormField(
        decoration: InputDecoration(
            labelText: 'Salary Range',
            prefixIcon: Icon(Icons.work),
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
        value: controller.selectedSalaryRange.value,
        items: controller.salaryRange.map((String salaryRange) {
          return DropdownMenuItem<String>(
            value: salaryRange,
            child: Text(salaryRange),
          );
        }).toList(),
        onChanged: (String? newValue) {
          controller.selectedSalaryRange.value = newValue!;
        },
      );
    });
  }
}
