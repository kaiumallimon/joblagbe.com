import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:joblagbe/app/core/theming/colors/_colors.dart';
import 'package:joblagbe/app/core/utils/_formatter.dart';
import 'package:joblagbe/app/core/widgets/_custom_button.dart';
import 'package:joblagbe/app/core/widgets/_dashboard_appbar.dart';
import 'package:joblagbe/app/modules/dashboard/recruiter/jobs/controllers/_recruiter_jobs_controller.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:smooth_scroll_multiplatform/smooth_scroll_multiplatform.dart';
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search bar
            const SizedBox(height: 20),
            SizedBox(
              height: 60,
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
            Text('Featured Jobs',
                style: TextStyle(
                    color: AppColors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),

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
                      Expanded(
                        child: DynMouseScroll(
                            builder: (context, controller, physics) {
                          return SingleChildScrollView(
                            controller: controller,
                            physics: physics,
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              spacing: 20,
                              children: [
                                // close button
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    IconButton.filled(
                                        onPressed: () {
                                          jobsController.setSelectedJob(null);
                                        },
                                        style: IconButton.styleFrom(
                                            backgroundColor: Colors.red),
                                        icon: Icon(Icons.close)),
                                  ],
                                ),

                                // company logo and job title
                                // and deadline
                                Row(
                                  spacing: 20,
                                  children: [
                                    CircleAvatar(
                                        backgroundColor: AppColors.black,
                                        radius: 30,
                                        backgroundImage: NetworkImage(
                                          jobsController.selectedJob.value!
                                              .companyLogoUrl,
                                          headers: {
                                            "Access-Control-Allow-Origin":
                                                "*", // Might be ignored by the browser
                                          },
                                        )),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        spacing: 5,
                                        children: [
                                          Text(
                                            jobsController
                                                .selectedJob.value!.title,
                                            style: TextStyle(
                                              color: AppColors.black,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            DateTimeFormatter()
                                                .formatJobDeadline(
                                                    jobsController.selectedJob
                                                        .value!.deadline),
                                            style: TextStyle(
                                              color: AppColors.black,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),

                                // job type, location, and salary
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    // job type
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15, vertical: 5),
                                      decoration: BoxDecoration(
                                        color:
                                            AppColors.primary.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        spacing: 10,
                                        children: [
                                          Icon(
                                            Icons.work,
                                            color: AppColors.black,
                                          ),
                                          Text(
                                            jobsController
                                                .selectedJob.value!.jobType,
                                            style: TextStyle(
                                              color: AppColors.black,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    // location
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15, vertical: 5),
                                      decoration: BoxDecoration(
                                        color:
                                            AppColors.primary.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        spacing: 10,
                                        children: [
                                          Icon(
                                            Icons.location_on,
                                            color: AppColors.black,
                                          ),
                                          Text(
                                            jobsController
                                                .selectedJob.value!.location,
                                            style: TextStyle(
                                              color: AppColors.black,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    // salary
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15, vertical: 5),
                                      decoration: BoxDecoration(
                                        color:
                                            AppColors.primary.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        spacing: 10,
                                        children: [
                                          Icon(
                                            Icons.attach_money,
                                            color: AppColors.black,
                                          ),
                                          Text(
                                            "${jobsController.selectedJob.value!.salaryRange} BDT",
                                            style: TextStyle(
                                              color: AppColors.black,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),

                                const SizedBox(height: 20),
                                // job description
                                Text(
                                  'Job Description',
                                  style: TextStyle(
                                    color: AppColors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                Text(
                                  jobsController.selectedJob.value!.description,
                                  style: TextStyle(
                                    color: AppColors.black,
                                    fontSize: 16,
                                  ),
                                ),

                                const SizedBox(height: 20),
                                // Required skills
                                Text('Requirements',
                                    style: TextStyle(
                                      color: AppColors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    )),

                                Text(
                                    'The applicant must be proficient in the following skills:',
                                    style: TextStyle(
                                      color: AppColors.black,
                                      fontSize: 16,
                                    )),

                                ...jobsController.selectedJob.value!.skills.map(
                                  (skill) => Text(
                                    "- $skill",
                                    style: TextStyle(
                                        color: AppColors.black,
                                        fontSize: 14,
                                        height: 1),
                                  ),
                                ),

                                const SizedBox(height: 20),

                                // experience level
                                Text(
                                    'Experience Level: ${jobsController.selectedJob.value!.experienceLevel}',
                                    style: TextStyle(
                                      color: AppColors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    )),

                                // message
                                Text(
                                  'If you meet these requirements, you can apply for the job by clicking the "Apply" button below.',
                                  style: TextStyle(
                                    color: AppColors.black,
                                    fontSize: 16,
                                  ),
                                ),

                                const SizedBox(height: 10),

                                // tags
                                Text('Tags',
                                    style: TextStyle(
                                      color: AppColors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    )),

                                // tags (wrapped)
                                Wrap(
                                  spacing: 10,
                                  runSpacing: 10,
                                  children:
                                      jobsController.selectedJob.value!.tags
                                          .map((tag) => Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 20,
                                                    vertical: 10),
                                                decoration: BoxDecoration(
                                                  color: AppColors.primary
                                                      .withOpacity(0.2),
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                child: Text(
                                                  tag,
                                                  style: TextStyle(
                                                    color: AppColors.black,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ))
                                          .toList(),
                                ),

                                const SizedBox(height: 20),

                                // edit button

                                if (FirebaseAuth.instance.currentUser!.uid ==
                                    jobsController.selectedJob.value!.creatorId)
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      CustomButton(
                                          width: 150,
                                          height: 50,
                                          text: 'Edit Post',
                                          onPressed: () {})
                                    ],
                                  )
                              ],
                            ),
                          );
                        }),
                      )
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
