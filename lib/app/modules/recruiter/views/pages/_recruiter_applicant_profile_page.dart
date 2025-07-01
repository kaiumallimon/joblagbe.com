import 'package:flutter/material.dart';
import 'package:joblagbe/app/core/theming/colors/_colors.dart';
import 'package:joblagbe/app/core/widgets/_dashboard_appbar.dart';
import 'package:joblagbe/app/core/widgets/_custom_button.dart';
import 'package:joblagbe/app/data/models/_applicant_profile_model.dart';
import 'package:joblagbe/app/data/services/_recruiter_applications_service.dart';
import 'dart:html' as html;
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:joblagbe/app/modules/recruiter/controllers/_recruiter_wrapper_controller.dart';

import 'package:smooth_scroll_multiplatform/smooth_scroll_multiplatform.dart';

class RecruiterApplicantProfilePage extends StatelessWidget {
  final String applicantId;
  const RecruiterApplicantProfilePage({super.key, required this.applicantId});

  void _downloadResume(String url) {
    html.AnchorElement anchorElement = html.AnchorElement(href: url);
    anchorElement.download = 'resume.pdf';
    anchorElement.click();
  }

  @override
  Widget build(BuildContext context) {
    final service = RecruiterApplicationService();
    // Sync sidebar with current URL
    Get.put(RecruiterWrapperController()).syncMenuWithRoute(context);
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: dashboardAppbar('Applicant Profile'),
      body: FutureBuilder<ApplicantProfileModel>(
        future: service.getApplicantProfileModel(applicantId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CupertinoActivityIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: \\${snapshot.error}',
                  style: const TextStyle(color: Colors.red)),
            );
          }
          final profile = snapshot.data;
          if (profile == null) {
            return const Center(child: Text('Applicant profile not found.'));
          }
          return DynMouseScroll(builder: (context, controller, physics) {
            return SingleChildScrollView(
              controller: controller,
              physics: physics,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 30),
                  // Top profile section
                  Container(
                    height: 120,
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 48,
                              backgroundImage: profile.profilePhotoUrl != null
                                  ? NetworkImage(profile.profilePhotoUrl!)
                                  : null,
                              child: profile.profilePhotoUrl == null
                                  ? const Icon(Icons.person, size: 48)
                                  : null,
                            ),
                            const SizedBox(width: 32),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  profile.fullName,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(profile.email,
                                    style: const TextStyle(fontSize: 16)),
                                if (profile.phone != null &&
                                    profile.phone!.isNotEmpty)
                                  Text(profile.phone!,
                                      style: const TextStyle(fontSize: 16)),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: _profileFieldContainer(
                            label: 'Gender',
                            value: profile.gender ?? '-',
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: _profileFieldContainer(
                            label: 'Date of Birth',
                            value: profile.dob != null
                                ? _formatDate(profile.dob!)
                                : '-',
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: _profileFieldContainer(
                            label: 'Phone Number',
                            value: profile.phone ?? '-',
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: _profileFieldContainer(
                            label: 'Location',
                            value: profile.location ?? '-',
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: _profileFieldContainer(
                            label: 'Professional Title',
                            value: profile.professionalTitle ?? '-',
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: _profileFieldContainer(
                            label: 'Skills',
                            value: profile.skills != null &&
                                    profile.skills!.isNotEmpty
                                ? profile.skills!.join(', ')
                                : '-',
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: _profileFieldContainer(
                      label: 'Bio',
                      value: profile.bio ?? '-',
                      maxLines: 3,
                      height: 120,
                      width: double.infinity,
                    ),
                  ),
                  const SizedBox(height: 32),
                  if (profile.resumeUrl != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: CustomButton(
                          text: 'Download Resume',
                          onPressed: () => _downloadResume(profile.resumeUrl!),
                          color: AppColors.primary,
                          textColor: Colors.white,
                          width: 200,
                          leadingIcon:
                              const Icon(Icons.download, color: Colors.white),
                        ),
                      ),
                    ),
                ],
              ),
            );
          });
        },
      ),
    );
  }

  Widget _profileFieldContainer({
    required String label,
    required String value,
    int maxLines = 1,
    double? height,
    double? width,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: AppColors.black.withOpacity(.05),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppColors.black.withOpacity(.2),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            maxLines: maxLines,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.black,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}
