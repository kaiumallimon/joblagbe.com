import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../core/theming/colors/_colors.dart';
import '../../controllers/_applicant_profile_controller.dart';

class ApplicantDobSelector extends StatelessWidget {
  const ApplicantDobSelector({
    super.key,
    required this.isEditable,
    required this.hintText,
    this.initialDate,
  });

  final bool isEditable;
  final String hintText;
  final DateTime? initialDate;

  @override
  Widget build(BuildContext context) {
    final ApplicantProfileController controller = Get.find();

    return Obx(() {
      final selectedDob = controller.selectedDob.value;
      final displayText = selectedDob != null
          ? DateFormat('yyyy-MM-dd').format(selectedDob)
          : (initialDate != null
              ? DateFormat('yyyy-MM-dd').format(initialDate!)
              : '');

      bool showErrorIcon = selectedDob == null && initialDate == null;

      return Stack(
        alignment: Alignment.centerRight,
        children: [
          TextFormField(
            controller: TextEditingController(text: displayText),
            readOnly: true,
            onTap: isEditable
                ? () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate:
                          selectedDob ?? initialDate ?? DateTime(2000, 1, 1),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                    if (pickedDate != null) {
                      controller.selectedDob.value = pickedDate;
                    }
                  }
                : null,
            decoration: InputDecoration(
              labelText: hintText,
              hintText: 'Select Date',
              filled: !isEditable,
              fillColor: isEditable
                  ? Colors.transparent
                  : AppColors.black.withOpacity(.05),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                    color: AppColors.black.withOpacity(.2), width: 2),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                    color: AppColors.black.withOpacity(.2), width: 2),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: AppColors.primary, width: 2),
              ),
              labelStyle:
                  TextStyle(color: isEditable ? AppColors.black : Colors.grey),
              suffixIcon: showErrorIcon
                  ? const Icon(Icons.error, color: Colors.red, size: 24)
                  : null,
            ),
          ),
        ],
      );
    });
  }
}
