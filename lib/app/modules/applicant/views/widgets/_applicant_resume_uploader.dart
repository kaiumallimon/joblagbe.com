import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

import '../../../../core/theming/colors/_colors.dart';
import '../../controllers/_applicant_profile_controller.dart';

class ApplicantResumeUploader extends StatelessWidget {
  const ApplicantResumeUploader({
    super.key,
    required this.isEditable,
  });

  final bool isEditable;

  void _downloadResume(String url) {
    html.AnchorElement anchorElement = html.AnchorElement(href: url);
    anchorElement.download = 'resume.pdf';
    anchorElement.click();
  }

  @override
  Widget build(BuildContext context) {
    final ApplicantProfileController controller = Get.find();

    return Obx(() {
      final bool hasResume =
          controller.applicantProfileData.value?.resumeUrl != null;
      final bool isUploading = controller.isResumeUploading.value;

      return Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.black.withOpacity(.2),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (isUploading)
              LoadingAnimationWidget.twoRotatingArc(
                color: AppColors.primary,
                size: 30,
              )
            else
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    hasResume ? Icons.description : Icons.upload_file,
                    color: AppColors.primary,
                  ),
                  SizedBox(width: 10),
                  Text(
                    hasResume ? 'Update Resume' : 'Upload Resume',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (hasResume) ...[
                    SizedBox(width: 10),
                    Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 20,
                    ),
                    SizedBox(width: 20),
                    TextButton.icon(
                      onPressed: () => _downloadResume(
                          controller.applicantProfileData.value!.resumeUrl!),
                      icon: Icon(
                        Icons.download,
                        color: AppColors.primary,
                        size: 20,
                      ),
                      label: Text(
                        'Download',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: TextButton.styleFrom(
                        backgroundColor: AppColors.primary.withOpacity(0.1),
                        padding: EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            if (isEditable)
              Positioned.fill(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => controller.pickResume(context),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
          ],
        ),
      );
    });
  }
}
