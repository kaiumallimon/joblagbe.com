import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:joblagbe/app/modules/dashboard/recruiter/jobs/controllers/_recruiter_jobs_controller.dart';

import '../../../../../../core/theming/colors/_colors.dart';
import '../../../../../../core/utils/_formatter.dart';
import '../../../add-job/models/_job_model.dart';

class JobPostCard extends StatelessWidget {
  const JobPostCard({
    super.key,
    required this.job,
    required this.recruiterJobsController,
    required this.index,
  });

  final JobModel job;
  final RecruiterJobsController recruiterJobsController;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20),
      child: InkWell(
          borderRadius: BorderRadius.circular(15),
          mouseCursor: SystemMouseCursors.click,
          onTap: () => recruiterJobsController.setSelectedJob(job),
          child: Obx(() {
            return AnimatedOpacity(
              duration: Duration(milliseconds: 300),
              opacity: recruiterJobsController.hoveredJobIndex.value == index
                  ? 0.5
                  : 1,
              curve: Curves.easeInOut,
              child: MouseRegion(
                onEnter: (event) =>
                    recruiterJobsController.setHoveredJobIndex(index),
                onExit: (event) =>
                    recruiterJobsController.setHoveredJobIndex(-1),
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  decoration: BoxDecoration(
                    color: recruiterJobsController.selectedJob.value == job
                        ? AppColors.secondary.withOpacity(.1)
                        : AppColors.white,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: AppColors.secondary, width: 2),
                    // boxShadow: [
                    //   BoxShadow(
                    //     color: AppColors.black.withOpacity(0.1),
                    //     blurRadius: 10,
                    //     offset: Offset(0, 5),
                    //   ),
                    // ]
                  ),
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 20,
                    children: [
                      // job posting time and save button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        spacing: 10,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: AppColors.primary.withOpacity(0.2)),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              spacing: 10,
                              children: [
                                Icon(
                                  Icons.access_time,
                                  color: AppColors.primary,
                                ),
                                Text(
                                  DateTimeFormatter().getJobPostedTime(
                                      job.createdAt!.toDate()),
                                  style: TextStyle(
                                    color: AppColors.black,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: AppColors.primary.withOpacity(0.2)),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              spacing: 10,
                              children: [
                                Icon(
                                  Icons.location_on_outlined,
                                  color: AppColors.primary,
                                ),
                                Text(
                                  job.location,
                                  style: TextStyle(
                                    color: AppColors.black,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.red.withOpacity(0.2)),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              spacing: 10,
                              children: [
                                Icon(
                                  Icons.access_time,
                                  color: Colors.red,
                                ),
                                Text(
                                  DateTimeFormatter()
                                      .formatJobDeadline(job.deadline),
                                  style: TextStyle(
                                    color: AppColors.black,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      // company logo, title, company name
                      Row(
                        spacing: 20,
                        children: [
                          CircleAvatar(
                              backgroundColor: AppColors.black,
                              radius: 30,
                              backgroundImage: NetworkImage(
                                job.companyLogoUrl,
                                headers: {
                                  "Access-Control-Allow-Origin":
                                      "*", // Might be ignored by the browser
                                },
                              )),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              spacing: 5,
                              children: [
                                Text(
                                  job.title,
                                  style: TextStyle(
                                    color: AppColors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  job.company,
                                  style: TextStyle(
                                    color: AppColors.black.withOpacity(0.5),
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      // tags (wrapped)
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: job.tags
                            .map((tag) => Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(8),
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
                      )
                    ],
                  ),
                ),
              ),
            );
          })),
    );
  }
}
