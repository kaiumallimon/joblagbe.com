// ignore_for_file: deprecated_member_use

import 'package:chips_choice/chips_choice.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:joblagbe/app/core/theming/colors/_colors.dart';
import 'package:joblagbe/app/core/widgets/_dashboard_appbar.dart';
import 'package:joblagbe/app/modules/recruiter/controllers/_recruiter_jobs_controller.dart';
import 'package:joblagbe/app/modules/recruiter/views/widgets/_recruiter_detailed_job_view.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../widgets/_recruiter_job_post_card.dart';

class RecruiterJobsPage extends StatelessWidget {
  const RecruiterJobsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final jobsController = Get.put(RecruiterJobsController());

    // Fetch initial jobs when the page is loaded
    if (jobsController.jobs.isEmpty && !jobsController.isLoading.value) {
      jobsController.fetchJobs(context: context);
    }

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: dashboardAppbar('Explore/Manage Jobs'),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (value) =>
                        jobsController.searchQuery.value = value,
                    decoration: InputDecoration(
                      hintText: 'Search jobs...',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                            color: AppColors.primary.withOpacity(0.3),
                            width: 2),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                            color: AppColors.primary.withOpacity(0.3),
                            width: 2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            BorderSide(color: AppColors.primary, width: 2),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                IconButton.filled(
                  onPressed: () => jobsController.refreshCurrentPage(context),
                  icon: Icon(Icons.refresh, color: AppColors.primary),
                ),
              ],
            ),
          ),
          Expanded(
            child: Obx(() {
              if (jobsController.isLoading.value &&
                  jobsController.jobs.isEmpty) {
                return Center(
                  child: LoadingAnimationWidget.twoRotatingArc(
                    color: AppColors.primary,
                    size: 50,
                  ),
                );
              }

              if (jobsController.filteredJobs.isEmpty) {
                return const Center(
                  child: Text(
                    'No Jobs Found',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                );
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 20,
                children: [
                  // jobs list
                  Expanded(
                    child: NotificationListener<ScrollNotification>(
                      onNotification: (ScrollNotification scrollInfo) {
                        if (scrollInfo.metrics.pixels ==
                                scrollInfo.metrics.maxScrollExtent &&
                            !jobsController.isLoading.value &&
                            jobsController.hasMore.value) {
                          jobsController.fetchJobs(
                              loadMore: true, context: context);
                        }
                        return false;
                      },
                      child: ListView.builder(
                        padding: EdgeInsets.all(16),
                        itemCount: jobsController.filteredJobs.length +
                            (jobsController.hasMore.value ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index >= jobsController.filteredJobs.length) {
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: LoadingAnimationWidget.twoRotatingArc(
                                  color: AppColors.primary,
                                  size: 30,
                                ),
                              ),
                            );
                          }

                          final job = jobsController.filteredJobs[index];
                          return JobPostCard(
                              job: job,
                              recruiterJobsController: jobsController,
                              index: index);
                        },
                      ),
                    ),
                  ),

                  if (jobsController.selectedJob.value != null)
                    Container(
                      width: 2,
                      height: double.infinity,
                      color: AppColors.secondary.withOpacity(0.5),
                    ),

                  // selected job details (if any job is selected)
                  if (jobsController.selectedJob.value != null)
                    RecruiterJobDetailedViewCard(jobsController: jobsController)
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}
