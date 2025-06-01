import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:joblagbe/app/core/theming/colors/_colors.dart';
import 'package:joblagbe/app/core/widgets/_dashboard_appbar.dart';
import 'package:joblagbe/app/modules/applicant/controllers/_applicant_jobs_application_controller.dart';
import 'package:smooth_scroll_multiplatform/smooth_scroll_multiplatform.dart';

class ApplicantJobApplicationPage extends StatelessWidget {
  final String jobId;
  const ApplicantJobApplicationPage({super.key, required this.jobId});

  @override
  Widget build(BuildContext context) {
    // Check if controller exists for this job
    if (!Get.isRegistered<ApplicantJobsApplicationController>(tag: jobId)) {
      return Scaffold(
        backgroundColor: AppColors.white,
        appBar: dashboardAppbar('Job Application Test'),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'No job selected',
                style: TextStyle(
                  color: AppColors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Please go back and select a job to apply for.',
                style: TextStyle(
                  color: AppColors.black.withOpacity(0.7),
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Get.back(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Go Back'),
              ),
            ],
          ),
        ),
      );
    }

    final controller = Get.find<ApplicantJobsApplicationController>(tag: jobId);

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: dashboardAppbar('Job Application Test', actions: [
        Obx(() {
          if (controller.applicationProgress.value == null) {
            return const SizedBox.shrink();
          }
          return RichText(
            text: TextSpan(
              text: 'Chances left: ',
              style: TextStyle(
                color: AppColors.black,
                fontSize: 16,
                fontFamily: 'Poppins',
              ),
              children: [
                TextSpan(
                  text: controller.getChancesLeft().toString(),
                  style: TextStyle(
                    color: AppColors.darkPrimary,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          );
        }),
      ]),
      body: Obx(() {
        // Show loading indicator while loading MCQs or application progress
        if (controller.isLoading.value ||
            controller.applicationProgress.value == null) {
          return const Center(
            child: CupertinoActivityIndicator(
              color: AppColors.primary,
            ),
          );
        }

        // Show message if no questions are available
        if (controller.mcqQuestions.isEmpty) {
          return const Center(
            child: Text('No questions available for this job.'),
          );
        }

        return DynMouseScroll(
          builder: (context, scrollController, physics) {
            return SingleChildScrollView(
              controller: scrollController,
              physics: physics,
              padding: const EdgeInsets.all(16),
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.primary.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Please answer all questions carefully. Your answers will be evaluated as part of your job application.',
                      style: TextStyle(
                        color: AppColors.black.withOpacity(0.7),
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ...controller.mcqQuestions.asMap().entries.map((entry) {
                      final index = entry.key;
                      final question = entry.value;
                      return Container(
                        margin: const EdgeInsets.only(bottom: 24),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppColors.primary.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Question ${index + 1}',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              question.question,
                              style: TextStyle(
                                color: AppColors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 16),
                            ...question.options
                                .asMap()
                                .entries
                                .map((optionEntry) {
                              final optionIndex = optionEntry.key;
                              final optionText = optionEntry.value;
                              return Obx(() {
                                final selectedOption =
                                    controller.selectedAnswers[index];
                                return InkWell(
                                  onTap: () {
                                    controller.selectAnswer(index, optionIndex);
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(bottom: 8),
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: selectedOption == optionIndex
                                          ? AppColors.primary.withOpacity(0.1)
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: selectedOption == optionIndex
                                            ? AppColors.primary
                                            : AppColors.primary
                                                .withOpacity(0.2),
                                        width: 1,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 20,
                                          height: 20,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color:
                                                  selectedOption == optionIndex
                                                      ? AppColors.primary
                                                      : AppColors.primary
                                                          .withOpacity(0.2),
                                              width: 2,
                                            ),
                                          ),
                                          child: selectedOption == optionIndex
                                              ? Center(
                                                  child: Container(
                                                    width: 10,
                                                    height: 10,
                                                    decoration:
                                                        const BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: AppColors.primary,
                                                    ),
                                                  ),
                                                )
                                              : null,
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Text(
                                            optionText,
                                            style: TextStyle(
                                              color: AppColors.black
                                                  .withOpacity(0.8),
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              });
                            }).toList(),
                          ],
                        ),
                      );
                    }).toList(),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            controller.submitTest();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('Submit Test'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
