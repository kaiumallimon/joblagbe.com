// ignore_for_file: deprecated_member_use

import 'package:chips_choice/chips_choice.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:joblagbe/app/core/theming/colors/_colors.dart';
import 'package:joblagbe/app/core/widgets/_dashboard_appbar.dart';
import 'package:joblagbe/app/modules/dashboard/recruiter/jobs/controllers/_recruiter_jobs_controller.dart';
import 'package:joblagbe/app/modules/dashboard/recruiter/jobs/pages/parts/_detailed_job_view.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'parts/_job_post_card.dart';

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
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search bar
            Container(
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton.filled(
                    onPressed: () => jobsController.refreshCurrentPage(context),
                    icon: Icon(Icons.refresh, color: AppColors.primary),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: CupertinoSearchTextField(
                        placeholder: 'Search for jobs',
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        onChanged: (value) =>
                            jobsController.searchQuery.value = value,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Obx(
               () {
                return ChipsChoice<int>.single(
                  value: jobsController.selectedChip.value,
                  choiceItems: C2Choice.listFrom<int, String>(
                    source: jobsController.chipData,
                    value: (i, v) => i,
                    label: (i, v) => v,
                  ),
                  onChanged: (value) {
                    jobsController.selectedChip.value = value;
                    jobsController.filterJobByChip();
                  },
                  choiceCheckmark: true,
                  choiceStyle: C2ChipStyle.toned(
                    padding: EdgeInsets.all(8),
                    foregroundStyle: TextStyle(
                      fontFamily: "Inter"
                    ),
                    selectedStyle: C2ChipStyle.toned(
                      foregroundStyle: TextStyle(
                      fontFamily: "Inter",
                      fontWeight: FontWeight.bold
                    ),
                    )
                  ),
                );
              }
            ),
            const SizedBox(height: 20),

            // Text('Featured Jobs',
            //     style: TextStyle(
            //         color: AppColors.black,
            //         fontSize: 20,
            //         fontWeight: FontWeight.bold)),
            // const SizedBox(height: 20),

            // Job posts list with conditional rendering
            Expanded(
              child: Obx(() {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 20,
                  children: [
                    // jobs list
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

                        return NotificationListener<ScrollNotification>(
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
                            itemCount: jobsController.filteredJobs.length +
                                (jobsController.hasMore.value ? 1 : 0),
                            itemBuilder: (context, index) {
                              if (index >= jobsController.filteredJobs.length) {
                                return Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child:
                                        LoadingAnimationWidget.twoRotatingArc(
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
                        );
                      }),
                    ),

                    if (jobsController.selectedJob.value != null)
                      Container(
                        width: 2,
                        height: double.infinity,
                        color: AppColors.secondary.withOpacity(0.5),
                      ),

                    // selected job details (if any job is selected)
                    if (jobsController.selectedJob.value != null)
                      RecruiterJobDetailedViewCard(
                          jobsController: jobsController)
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
