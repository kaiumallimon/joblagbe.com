import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/theming/colors/_colors.dart';
import '../../../../core/utils/_formatter.dart';
import '../../../../data/models/_job_model.dart';

class JobPostCard extends StatelessWidget {
  const JobPostCard({
    super.key,
    required this.job,
    required this.recruiterJobsController,
    required this.index,
  });

  final JobModel job;
  final dynamic recruiterJobsController;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        mouseCursor: SystemMouseCursors.click,
        onTap: () => recruiterJobsController.setSelectedJob(job),
        child: Obx(() {
          return AnimatedOpacity(
            duration: Duration(milliseconds: 200),
            opacity: recruiterJobsController.hoveredJobIndex.value == index
                ? 0.92
                : 1,
            curve: Curves.easeInOut,
            child: MouseRegion(
              onEnter: (event) =>
                  recruiterJobsController.setHoveredJobIndex(index),
              onExit: (event) => recruiterJobsController.setHoveredJobIndex(-1),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: recruiterJobsController.selectedJob.value == job
                      ? AppColors.secondary.withOpacity(0.1)
                      : AppColors.primary.withOpacity(0.04),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: recruiterJobsController.selectedJob.value == job
                        ? AppColors.secondary
                        : AppColors.primary.withOpacity(0.15),
                    width: 1.5,
                  ),
                  boxShadow:
                      recruiterJobsController.hoveredJobIndex.value == index
                          ? [
                              BoxShadow(
                                color: AppColors.primary.withOpacity(0.08),
                                blurRadius: 12,
                                offset: Offset(0, 4),
                              ),
                            ]
                          : [],
                ),
                padding: EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 14,
                  children: [
                    // job posting time, location, deadline
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      spacing: 8,
                      children: [
                        _JobChip(
                          icon: Icons.access_time,
                          color: AppColors.primary,
                          bgColor: AppColors.primary.withOpacity(0.10),
                          text: DateTimeFormatter()
                              .getJobPostedTime(job.createdAt!.toDate()),
                        ),
                        _JobChip(
                          icon: Icons.location_on_outlined,
                          color: AppColors.primary,
                          bgColor: AppColors.primary.withOpacity(0.10),
                          text: job.location,
                        ),
                        _JobChip(
                          icon: Icons.access_time,
                          color: Colors.red,
                          bgColor: Colors.red.withOpacity(0.10),
                          text: DateTimeFormatter()
                              .formatJobDeadline(job.deadline),
                        ),
                      ],
                    ),
                    // company logo, title, company name
                    Row(
                      spacing: 14,
                      children: [
                        CircleAvatar(
                          backgroundColor: AppColors.primary.withOpacity(0.08),
                          radius: 26,
                          backgroundImage: NetworkImage(
                            job.companyLogoUrl,
                            headers: {
                              "Access-Control-Allow-Origin": "*",
                            },
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 3,
                            children: [
                              Text(
                                job.title,
                                style: TextStyle(
                                  color: AppColors.black,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                job.company,
                                style: TextStyle(
                                  color: AppColors.black.withOpacity(0.6),
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    // tags (wrapped)
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: job.tags
                          .map((tag) => Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.10),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  tag,
                                  style: TextStyle(
                                    color: AppColors.black.withOpacity(0.7),
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
        }),
      ),
    );
  }
}

class _JobChip extends StatelessWidget {
  final IconData icon;
  final Color color;
  final Color bgColor;
  final String text;
  const _JobChip({
    required this.icon,
    required this.color,
    required this.bgColor,
    required this.text,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 6,
        children: [
          Icon(icon, color: color, size: 16),
          Text(
            text,
            style: TextStyle(
              color: AppColors.black.withOpacity(0.8),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
