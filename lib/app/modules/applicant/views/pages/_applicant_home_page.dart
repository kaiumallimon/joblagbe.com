import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:joblagbe/app/core/theming/colors/_colors.dart';
import 'package:joblagbe/app/core/utils/_formatter.dart';
import 'package:joblagbe/app/core/widgets/_dashboard_appbar.dart';
import 'package:joblagbe/app/modules/applicant/controllers/_applicant_home_controller.dart';
import 'package:smooth_scroll_multiplatform/smooth_scroll_multiplatform.dart';

class ApplicantHome extends StatelessWidget {
  const ApplicantHome({super.key});

  @override
  Widget build(BuildContext context) {
    final String currentDate =
        DateTimeFormatter().getFormattedCurrentDateTime();

    final homeController = Get.put(ApplicantHomeController());

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: dashboardAppbar('Dashboard'),
      body: Padding(
        padding: EdgeInsetsGeometry.all(12),
        child: Obx(() {
          if (homeController.isLoading.value) {
            return Center(
                child: CupertinoActivityIndicator(
              color: AppColors.primary,
            ));
          }
          return DynMouseScroll(builder: (context, controller, physics) {
            return CustomScrollView(
              controller: controller,
              physics: physics,
              slivers: [
                ApplicantHomeAppbar(
                    currentDate: currentDate, homeController: homeController),
                // Recently added jobs section
                SliverToBoxAdapter(
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 24.0, left: 8, right: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Recently added jobs',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.black,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                context.go('/dashboard/applicant/jobs');
                              },
                              child: Text(
                                'See all',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.black.withOpacity(.5),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Obx(() {
                          final jobs = homeController.recentlyAddedJobs.value;
                          if (jobs == null) {
                            return Center(
                              child: CupertinoActivityIndicator(
                                color: AppColors.primary,
                              ),
                            );
                          }
                          if (jobs.isEmpty) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 24.0),
                              child: Center(
                                child: Text(
                                  'No recent jobs found.',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            );
                          }
                          return Column(
                            children: jobs.map((job) {
                              return Container(
                                margin: const EdgeInsets.only(bottom: 16),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.05),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: AppColors.primary.withOpacity(0.15),
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Company logo
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        job.companyLogoUrl,
                                        width: 56,
                                        height: 56,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                Container(
                                          width: 56,
                                          height: 56,
                                          color: Colors.grey.shade200,
                                          child: Icon(Icons.image,
                                              color: Colors.grey),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    // Job info
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            job.title,
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.black,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            job.company,
                                            style: TextStyle(
                                              fontSize: 15,
                                              color: AppColors.black
                                                  .withOpacity(0.7),
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Row(
                                            children: [
                                              Icon(Icons.location_on,
                                                  size: 16,
                                                  color: AppColors.primary),
                                              const SizedBox(width: 4),
                                              Text(
                                                job.location,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: AppColors.black
                                                      .withOpacity(0.7),
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              Icon(Icons.attach_money,
                                                  size: 16,
                                                  color: AppColors.primary),
                                              const SizedBox(width: 2),
                                              Text(
                                                job.salaryRange,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: AppColors.black
                                                      .withOpacity(0.7),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 4),
                                          Row(
                                            children: [
                                              Icon(Icons.access_time,
                                                  size: 16,
                                                  color: AppColors.primary),
                                              const SizedBox(width: 4),
                                              Text(
                                                DateTimeFormatter()
                                                    .getJobPostedTime(
                                                  job.createdAt?.toDate() ??
                                                      DateTime.now(),
                                                ),
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  color: AppColors.black
                                                      .withOpacity(0.6),
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              Icon(Icons.event,
                                                  size: 16,
                                                  color: AppColors.primary),
                                              const SizedBox(width: 4),
                                              Text(
                                                DateTimeFormatter()
                                                    .formatJobDeadline(
                                                        job.deadline),
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  color: AppColors.black
                                                      .withOpacity(0.6),
                                                ),
                                              ),
                                            ],
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
                    ),
                  ),
                ),
                // Available courses section
                SliverToBoxAdapter(
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 32.0, left: 8, right: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Available courses',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.black,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                context.go('/dashboard/applicant/courses');
                              },
                              child: Text(
                                'See all',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.black.withOpacity(.5),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Obx(() {
                          final courses = homeController.availableCourses.value;
                          if (courses == null) {
                            return Center(
                              child: CupertinoActivityIndicator(
                                color: AppColors.primary,
                              ),
                            );
                          }
                          if (courses.isEmpty) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 24.0),
                              child: Center(
                                child: Text(
                                  'No available courses found.',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            );
                          }
                          return GridView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              childAspectRatio: 1.5,
                            ),
                            itemCount: courses.length,
                            itemBuilder: (context, index) {
                              final course = courses[index];
                              return Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                    color: AppColors.primary.withOpacity(0.3),
                                    width: 2,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.04),
                                      blurRadius: 8,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                clipBehavior: Clip.antiAlias,
                                child: Stack(
                                  children: [
                                    Positioned.fill(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(13),
                                        child: Image.network(
                                          course.thumbnailUrl,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  Container(
                                            color: Colors.grey.shade200,
                                            child: Icon(Icons.image,
                                                color: Colors.grey, size: 40),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      left: 0,
                                      right: 0,
                                      bottom: 0,
                                      height: 120,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              Colors.transparent,
                                              Colors.black.withOpacity(1.0),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      left: 12,
                                      right: 12,
                                      bottom: 16,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            course.title,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              shadows: [
                                                Shadow(
                                                  color: Colors.black
                                                      .withOpacity(0.5),
                                                  blurRadius: 4,
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            course.category,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.white
                                                  .withOpacity(0.85),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ],
            );
          });
        }),
      ),
    );
  }
}

class ApplicantHomeAppbar extends StatelessWidget {
  const ApplicantHomeAppbar({
    super.key,
    required this.currentDate,
    required this.homeController,
  });

  final String currentDate;
  final ApplicantHomeController homeController;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      expandedHeight: 100,
      pinned: true,
      backgroundColor: AppColors.white,
      title: Text(
        "It's $currentDate",
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 18,
          color: AppColors.darkBackground.withOpacity(.5),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          padding: const EdgeInsets.only(left: 15, bottom: 16, top: 50),
          alignment: Alignment.bottomLeft,
          color: AppColors.white,
          child: Obx(() {
            return Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Welcome, ',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  TextSpan(
                    text: homeController.profile.value?.fullName ?? 'User',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
