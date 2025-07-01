import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:joblagbe/app/core/widgets/_dashboard_appbar.dart';
import 'package:joblagbe/app/modules/recruiter/controllers/_recruiter_applications_controller.dart';
import 'package:joblagbe/app/data/models/_application_model.dart';
import 'package:joblagbe/app/data/services/_recruiter_applications_service.dart';
import 'package:joblagbe/app/core/theming/colors/_colors.dart';
import 'package:joblagbe/app/core/widgets/_custom_button.dart';
import 'package:joblagbe/app/data/models/_applicant_profile_model.dart';
import 'dart:html' as html;
import 'package:go_router/go_router.dart';
import 'package:flutter/cupertino.dart';

class ApplicationsPage extends StatelessWidget {
  const ApplicationsPage({super.key});

  void _downloadResume(String url) {
    html.AnchorElement anchorElement = html.AnchorElement(href: url);
    anchorElement.download = 'resume.pdf';
    anchorElement.click();
  }

  void _downloadAllResumes(List<Map<String, String?>> resumes) {
    for (final resume in resumes) {
      final url = resume['resumeUrl'];
      if (url != null) {
        html.AnchorElement anchorElement = html.AnchorElement(href: url);
        anchorElement.download = '${resume['name'] ?? 'resume'}.pdf';
        anchorElement.click();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final applicationController = Get.put(RecruiterApplicationController());
    final RecruiterApplicationService service = RecruiterApplicationService();

    return Scaffold(
      appBar: dashboardAppbar('Applications Received'),
      body: Obx(() {
        if (applicationController.isLoading.value) {
          return const Center(child: CupertinoActivityIndicator());
        }
        if (applicationController.applications.isEmpty) {
          return const Center(child: Text('No applications received.'));
        }
        // Collect resumes for download all
        final List<Map<String, String?>> allResumes = [];
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Applications: ${applicationController.applications.length}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkPrimary,
                    ),
                  ),
                  CustomButton(
                    text: 'Download All Resumes',
                    onPressed: () {
                      if (allResumes.isNotEmpty)
                        _downloadAllResumes(allResumes);
                    },
                    color: AppColors.primary,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Expanded(
                child: ListView.separated(
                  itemCount: applicationController.applications.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final app = applicationController.applications[index];
                    // Defensive: skip if jobId or applicantId is missing
                    if ((app.jobId == null || app.jobId!.isEmpty) ||
                        (app.applicantId == null || app.applicantId!.isEmpty)) {
                      return Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.primary.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: const Text(
                          'Invalid application data (missing job or applicant reference).',
                          style: TextStyle(color: Colors.red),
                        ),
                      );
                    }
                    return FutureBuilder(
                      future: Future.wait([
                        service.getApplicantProfileModel(app.applicantId!),
                        service.getJobById(app.jobId!),
                      ]),
                      builder:
                          (context, AsyncSnapshot<List<dynamic>> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: AppColors.primary.withOpacity(0.2),
                                width: 1,
                              ),
                            ),
                            child: const Center(
                                child: CupertinoActivityIndicator()),
                          );
                        }
                        if (snapshot.hasError) {
                          return Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.red.withOpacity(0.2),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              'Error loading application: ${snapshot.error}',
                              style: const TextStyle(color: Colors.red),
                            ),
                          );
                        }
                        final applicant =
                            snapshot.data![0] as ApplicantProfileModel?;
                        final job = snapshot.data![1];
                        if (applicant == null || job == null) {
                          return Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.red.withOpacity(0.2),
                                width: 1,
                              ),
                            ),
                            child: const Text(
                              'Applicant or job not found.',
                              style: TextStyle(color: Colors.red),
                            ),
                          );
                        }
                        // Collect resume for download all
                        if (applicant.resumeUrl != null) {
                          allResumes.add({
                            'resumeUrl': applicant.resumeUrl,
                            'name': applicant.fullName,
                          });
                        }
                        return InkWell(
                          onTap: () {
                            // TODO: Navigate to recruiter-facing applicant profile page
                            // context.go('/dashboard/recruiter/applicant-profile/${app.applicantId}');
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: AppColors.primary.withOpacity(0.2),
                                width: 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withOpacity(0.04),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 32,
                                  backgroundImage: applicant.profilePhotoUrl !=
                                          null
                                      ? NetworkImage(applicant.profilePhotoUrl!)
                                      : null,
                                  child: applicant.profilePhotoUrl == null
                                      ? const Icon(Icons.person, size: 32)
                                      : null,
                                ),
                                const SizedBox(width: 24),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        applicant.fullName,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        applicant.email,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: AppColors.darkBackground,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Applied for: ${job?.title ?? '-'}',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 24),
                                if (applicant.resumeUrl != null)
                                  CustomButton(
                                    text: 'Download Resume',
                                    onPressed: () =>
                                        _downloadResume(applicant.resumeUrl!),
                                    color: AppColors.primary,
                                  ),
                                const SizedBox(width: 12),
                                CustomButton(
                                  text: 'View Profile',
                                  onPressed: () {
                                    context.go(
                                        '/dashboard/recruiter/applicant-profile/${app.applicantId}');
                                  },
                                  color: AppColors.secondary,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
