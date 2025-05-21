import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/theming/colors/_colors.dart';
import '../../controllers/_recruiter_profile_controller.dart';

class CustomLogoSelector extends StatelessWidget {
  const CustomLogoSelector({
    super.key,
    required this.isEditable,
  });

  final bool isEditable;

  @override
  Widget build(BuildContext context) {
    final RecruiterProfileController controller = Get.find();

    return Obx(() {
      final displayText = controller.profileData.value!.companyLogoUrl != null
          ? "Selected"
          : "Please select a logo";

      bool showErrorIcon = controller.profileData.value!.companyLogoUrl == null;

      return Stack(
        alignment: Alignment.centerRight, // Align the error icon to the right
        children: [
          TextFormField(
            controller: TextEditingController(text: displayText),
            readOnly: true,
            onTap: isEditable
                ? () async {
                    await controller.pickLogo(context);
                  }
                : null,
            decoration: InputDecoration(
              labelText: 'Company Logo',
              hintText: displayText,
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
              suffixIcon: controller.isLogoUploading.value
                  ? CupertinoActivityIndicator(
                      color: AppColors.darkPrimary,
                    )
                  : showErrorIcon
                      ? const Icon(Icons.error, color: Colors.red, size: 24)
                      : null, // Show error icon only when needed
            ),
          ),
        ],
      );
    });
  }
}
