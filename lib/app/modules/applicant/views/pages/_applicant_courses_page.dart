import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:joblagbe/app/core/theming/colors/_colors.dart';
import 'package:joblagbe/app/core/widgets/_dashboard_appbar.dart';
import 'package:joblagbe/app/modules/applicant/controllers/_applicant_course_controller.dart';
import 'package:smooth_scroll_multiplatform/smooth_scroll_multiplatform.dart';

class ApplicantCoursePage extends StatelessWidget {
  const ApplicantCoursePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ApplicantCourseController());

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: dashboardAppbar('Courses'),
      body: Column(
        children: [
          // Tabs
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.white,
              border: Border(
                bottom: BorderSide(
                  color: AppColors.primary.withOpacity(0.2),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Obx(() => _buildTab(
                        'All Courses',
                        0,
                        controller.selectedTabIndex.value == 0,
                        () => controller.changeTab(0),
                      )),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Obx(() => _buildTab(
                        'Enrolled Courses',
                        1,
                        controller.selectedTabIndex.value == 1,
                        () => controller.changeTab(1),
                      )),
                ),
              ],
            ),
          ),

          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Obx(() => TextField(
                  onChanged: (value) => controller.selectedTabIndex.value == 0
                      ? controller.searchAllCourses(value)
                      : controller.searchEnrolledCourses(value),
                  decoration: InputDecoration(
                    hintText: controller.selectedTabIndex.value == 0
                        ? 'Search all courses...'
                        : 'Search enrolled courses...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                          color: AppColors.primary.withOpacity(0.3), width: 2),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                          color: AppColors.primary.withOpacity(0.3), width: 2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          BorderSide(color: AppColors.primary, width: 2),
                    ),
                  ),
                )),
          ),

          // Course List
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: CupertinoActivityIndicator(
                    color: AppColors.primary,
                  ),
                );
              }

              final courses = controller.selectedTabIndex.value == 0
                  ? controller.filteredAllCourses
                  : controller.filteredEnrolledCourses;

              if (courses.isEmpty) {
                return EmptyCoursesTab(controller: controller);
              }

              return DynMouseScroll(
                builder: (context, scrollController, physics) {
                  return SingleChildScrollView(
                    controller: scrollController,
                    physics: physics,
                    padding: const EdgeInsets.all(16),
                    child: Wrap(
                      spacing: 20,
                      runSpacing: 20,
                      children: courses.map((course) {
                        final isEnrolled =
                            controller.isEnrolled(course.id ?? '');

                        return Container(
                          width: MediaQuery.of(context).size.width * 0.4,
                          height: 300,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColors.primary.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(12),
                                  ),
                                  child: Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      Image.network(
                                        course.thumbnailUrl,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Container(
                                            color: Colors.grey.shade200,
                                            child: const Icon(
                                              Icons.image_not_supported,
                                              color: Colors.grey,
                                            ),
                                          );
                                        },
                                      ),
                                      if (controller
                                          .isEnrolled(course.id ?? ''))
                                        Positioned(
                                          top: 8,
                                          right: 8,
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color:
                                                  Colors.black.withOpacity(0.7),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(
                                                  (controller.getCourseProgress(
                                                                  course.id ??
                                                                      ''))
                                                              .toInt() ==
                                                          100
                                                      ? Icons.check_circle
                                                      : Icons.hourglass_top,
                                                  color: Colors.white,
                                                  size: 16,
                                                ),
                                                const SizedBox(width: 4),
                                                Text(
                                                  '${(controller.getCourseProgress(course.id ?? '')).toInt()}%',
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(12),
                                    bottomRight: Radius.circular(12),
                                  ),
                                ),
                                padding: const EdgeInsets.all(15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      course.title,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      course.category,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.white.withOpacity(0.8),
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    if (controller.selectedTabIndex.value == 0)
                                      isEnrolled
                                          ? Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                vertical: 8,
                                                horizontal: 12,
                                              ),
                                              decoration: BoxDecoration(
                                                color: Colors.green
                                                    .withOpacity(0.1),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                border: Border.all(
                                                  color: Colors.green,
                                                  width: 1,
                                                ),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  const Icon(
                                                    Icons.check_circle,
                                                    color: Colors.green,
                                                    size: 16,
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Text(
                                                    'Enrolled',
                                                    style: TextStyle(
                                                      color: Colors.green,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          : SizedBox.shrink()
                                    else
                                      SizedBox(
                                        width: double.infinity,
                                        child: ElevatedButton(
                                          onPressed: () => context.go(
                                              '/dashboard/applicant/courses/view/${course.id ?? ''}'),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.white,
                                            foregroundColor: AppColors.primary,
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 12,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                          child: const Text(
                                            'Continue Learning',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(
      String title, int index, bool isSelected, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class EmptyCoursesTab extends StatelessWidget {
  const EmptyCoursesTab({
    super.key,
    required this.controller,
  });

  final ApplicantCourseController controller;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.school_outlined,
            size: 64,
            color: AppColors.black.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            controller.selectedTabIndex.value == 0
                ? 'No Courses Found'
                : 'No Enrolled Courses',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.black,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            controller.selectedTabIndex.value == 0
                ? 'Try adjusting your search or browse all courses.'
                : 'You haven\'t enrolled in any courses yet.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: AppColors.black.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }
}
