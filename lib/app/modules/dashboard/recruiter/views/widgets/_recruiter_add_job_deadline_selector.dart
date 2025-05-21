import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../../core/theming/colors/_colors.dart';
import '../../controllers/_recruiter_add_job_controller.dart';

class AddJobDeadlineSelector extends StatelessWidget {
  const AddJobDeadlineSelector({
    super.key,
    required this.controller,
  });

  final AddJobController controller;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Obx(() {
        return MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: controller.applicationDeadline.value ??
                    DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime(2101),
              );
              if (pickedDate != null) {
                controller.applicationDeadline.value = pickedDate;
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 10), // Added padding
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color: AppColors.darkPrimary.withOpacity(.15),
                    width: 2),
              ),
              width: double.infinity,
              height: 50,
              child: Center(
                child: Text(
                  controller.applicationDeadline.value == null
                      ? 'Select Application Deadline'
                      : DateFormat('yyyy-MM-dd').format(
                          controller.applicationDeadline.value!),
                  style: TextStyle(
                    color: AppColors.black.withOpacity(.9),
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
