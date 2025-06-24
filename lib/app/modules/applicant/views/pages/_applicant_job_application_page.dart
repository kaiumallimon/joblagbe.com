import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:joblagbe/app/core/theming/colors/_colors.dart';
import 'package:joblagbe/app/core/widgets/_custom_button.dart';
import 'package:joblagbe/app/core/widgets/_dashboard_appbar.dart';
import 'package:joblagbe/app/modules/applicant/controllers/_applicant_course_controller.dart';
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
                  text: controller.chancesLeft.value.toString(),
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

        // Show message if all chances are used
        if (controller.areAllChancesUsed) {
          return controller.applicationProgress.value?.testPassed == true
              ? Center(
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.primary.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.check_circle,
                          size: 64,
                          color: Colors.green,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Test Completed Successfully',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.black,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'You have successfully completed the test for this job. Your application is submitted and will be reviewed by the recruiter. Please wait for further updates via email.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.black.withOpacity(0.7),
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
                          child: const Text('Find Other Jobs'),
                        ),
                      ],
                    ),
                  ),
                )
              : Center(
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.primary.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.red,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Maximum Attempts Reached',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.black,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'You have used all your attempts for this job. Please try applying for other job positions.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.black.withOpacity(0.7),
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
                          child: const Text('Find Other Jobs'),
                        ),
                      ],
                    ),
                  ),
                );
        }

        // Show warning if course is not completed
        if (controller.chancesLeft.value == 1 &&
            controller.applicationProgress.value?.assignedCourseId != null &&
            !controller.courseCompletionStatus.value) {
          return Center(
            child: Container(
              padding: const EdgeInsets.all(24),
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.primary.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    size: 64,
                    color: Colors.orange,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Complete Your Course First',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'You need to complete the assigned course before attempting the test again.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.black.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      context.go('/dashboard/applicant/courses');
                      Get.find<ApplicantCourseController>()
                          .selectedTabIndex
                          .value = 1;
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
                    child: const Text('Go to Course'),
                  ),
                ],
              ),
            ),
          );
        }

        // Show test results if test is completed or chances left is 1 with no course assigned
        if (controller.isTestCompleted.value || !controller.shouldShowTest) {
          // Initialize courses if needed
          controller.initializeCoursesIfNeeded();

          return DynMouseScroll(
            builder: (context, scrollController, physics) {
              return SingleChildScrollView(
                controller: scrollController,
                physics: physics,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.primary.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            controller.applicationProgress.value?.testPassed ==
                                    true
                                ? Icons.check_circle
                                : Icons.cancel,
                            size: 64,
                            color: controller.applicationProgress.value
                                        ?.testPassed ==
                                    true
                                ? Colors.green
                                : Colors.red,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            controller.applicationProgress.value?.testPassed ==
                                    true
                                ? 'Congratulations!'
                                : 'Test Completed',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColors.black,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            controller.applicationProgress.value?.testPassed ==
                                    true
                                ? 'Your application has been submitted successfully.'
                                : 'Unfortunately, you did not pass the test.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColors.black.withOpacity(0.7),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Your Score: ${controller.applicationProgress.value?.testScore ?? 0}',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                          if (!controller.shouldShowTest) ...[
                            const SizedBox(height: 16),
                            Text(
                              'You have one chance left. Please complete a recommended course before attempting the test again.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColors.black.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    if ((!(controller.applicationProgress.value?.testPassed ??
                            false) ||
                        !controller.shouldShowTest)) ...[
                      const SizedBox(height: 32),
                      Text(
                        'Recommended Courses',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.black,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Improve your skills with these recommended courses:',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.black.withOpacity(0.7),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Obx(() {
                        debugPrint(
                            'Building courses list. Loading: ${controller.isLoadingCourses.value}, Courses: ${controller.relevantCourses.length}');

                        if (controller.isLoadingCourses.value) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(24.0),
                              child: CupertinoActivityIndicator(
                                color: AppColors.primary,
                              ),
                            ),
                          );
                        }

                        if (controller.relevantCourses.isEmpty) {
                          return Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: AppColors.primary.withOpacity(0.2),
                                width: 1,
                              ),
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.search_off,
                                  size: 48,
                                  color: AppColors.black.withOpacity(0.5),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No Recommended Courses Found',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.black,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'We couldn\'t find any courses matching the job requirements.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.black.withOpacity(0.7),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        return Column(
                          children: controller.relevantCourses.map((course) {
                            return Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: AppColors.primary.withOpacity(0.2),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      course.thumbnailUrl,
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          course.title,
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.black,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          course.description,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: AppColors.black
                                                .withOpacity(0.7),
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                        CustomButton(
                                          onPressed: () => controller
                                              .enrollInCourse(course.id!),
                                          isLoading:
                                              controller.isEnrolling.value,
                                          text: 'Enroll Now',
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        );
                      }),
                    ],
                  ],
                ),
              );
            },
          );
        }

        // Show message if no questions are available
        if (controller.mcqQuestions.isEmpty) {
          return const Center(
            child: Text('No questions available for this job.'),
          );
        }

        // Show MCQ test
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
