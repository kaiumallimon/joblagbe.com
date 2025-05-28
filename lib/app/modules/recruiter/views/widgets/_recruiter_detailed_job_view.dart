import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:joblagbe/app/core/theming/colors/_colors.dart';
import 'package:joblagbe/app/core/utils/_formatter.dart';
import 'package:joblagbe/app/core/widgets/_custom_button.dart';
import 'package:joblagbe/app/modules/recruiter/controllers/_recruiter_jobs_controller.dart';
import 'package:smooth_scroll_multiplatform/smooth_scroll_multiplatform.dart';

class RecruiterJobDetailedViewCard extends StatelessWidget {
  const RecruiterJobDetailedViewCard({
    super.key,
    required this.jobsController,
  });

  final RecruiterJobsController jobsController;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: DynMouseScroll(builder: (context, controller, physics) {
        return SingleChildScrollView(
          controller: controller,
          physics: physics,
          padding: EdgeInsets.all(16),
          child: Container(
            padding: EdgeInsets.all(15),
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
              mainAxisAlignment: MainAxisAlignment.start,
              spacing: 16,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: TextEditingController(
                          text:
                              '${GoRouter.of(context).state.fullPath}/${jobsController.selectedJob.value!.id}',
                        ),
                        readOnly: true,
                        maxLines: 1,
                        style: TextStyle(
                          color: Colors.black.withOpacity(.7),
                          fontWeight: FontWeight.w500,
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                    IconButton.filled(
                      onPressed: () {
                        jobsController.setSelectedJob(null);
                      },
                      style: IconButton.styleFrom(backgroundColor: Colors.red),
                      icon: Icon(Icons.close),
                    ),
                  ],
                ),

                // company logo and job title
                Row(
                  spacing: 16,
                  children: [
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.primary.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                            jobsController.selectedJob.value!.companyLogoUrl,
                            fit: BoxFit.cover,
                            headers: {
                              "Access-Control-Allow-Origin": "*",
                            }),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 4,
                        children: [
                          Text(
                            jobsController.selectedJob.value!.title,
                            style: TextStyle(
                              color: AppColors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            DateTimeFormatter().formatJobDeadline(
                                jobsController.selectedJob.value!.deadline),
                            style: TextStyle(
                              color: AppColors.black.withOpacity(0.7),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),

                // job type, location, and salary
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    // category
                    if (jobsController.selectedJob.value!.category != null)
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: AppColors.primary.withOpacity(0.2),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            spacing: 8,
                            children: [
                              Icon(
                                Icons.attach_money,
                                color: AppColors.black.withOpacity(0.7),
                                size: 16,
                              ),
                              Text(
                                jobsController.selectedJob.value!.category!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: AppColors.black.withOpacity(0.7),
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                    // job type
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppColors.primary.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          spacing: 8,
                          children: [
                            Icon(
                              Icons.work,
                              color: AppColors.black.withOpacity(0.7),
                              size: 16,
                            ),
                            Text(
                              jobsController.selectedJob.value!.jobType,
                              style: TextStyle(
                                color: AppColors.black.withOpacity(0.7),
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // location
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppColors.primary.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          spacing: 8,
                          children: [
                            Icon(
                              Icons.location_on,
                              color: AppColors.black.withOpacity(0.7),
                              size: 16,
                            ),
                            Text(
                              jobsController.selectedJob.value!.location,
                              style: TextStyle(
                                color: AppColors.black.withOpacity(0.7),
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // salary
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppColors.primary.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          spacing: 8,
                          children: [
                            Icon(
                              Icons.attach_money,
                              color: AppColors.black.withOpacity(0.7),
                              size: 16,
                            ),
                            Text(
                              "${jobsController.selectedJob.value!.salaryRange} BDT",
                              style: TextStyle(
                                color: AppColors.black.withOpacity(0.7),
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),

                const SizedBox(height: 16),
                // job description
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 8,
                  children: [
                    Text(
                      'Job Description',
                      style: TextStyle(
                        color: AppColors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      jobsController.selectedJob.value!.description,
                      style: TextStyle(
                        color: AppColors.black.withOpacity(0.7),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),
                // Required skills
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 8,
                  children: [
                    Text('Requirements',
                        style: TextStyle(
                          color: AppColors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        )),
                    Text(
                        'The applicant must be proficient in the following skills:',
                        style: TextStyle(
                          color: AppColors.black.withOpacity(0.7),
                          fontSize: 14,
                        )),
                    ...jobsController.selectedJob.value!.skills.map(
                      (skill) => Text(
                        "- $skill",
                        style: TextStyle(
                            color: AppColors.black.withOpacity(0.7),
                            fontSize: 13,
                            height: 1.5),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // experience level
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 8,
                  children: [
                    Text(
                        'Experience Level: ${jobsController.selectedJob.value!.experienceLevel}',
                        style: TextStyle(
                          color: AppColors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        )),
                    Text(
                      'If you meet these requirements, you can apply for the job by clicking the "Apply" button below.',
                      style: TextStyle(
                        color: AppColors.black.withOpacity(0.7),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // tags
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 8,
                  children: [
                    Text('Tags',
                        style: TextStyle(
                          color: AppColors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        )),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: jobsController.selectedJob.value!.tags
                          .map((tag) => Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.1),
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
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // edit button
                if (FirebaseAuth.instance.currentUser!.uid ==
                    jobsController.selectedJob.value!.creatorId)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CustomButton(
                          width: 150,
                          height: 45,
                          text: 'Edit Post',
                          onPressed: () {
                            debugPrint(
                                "Editing job: ${jobsController.selectedJob.value!.id}");
                            (context).go(
                              '/dashboard/recruiter/jobs/edit/${jobsController.selectedJob.value!.id}',
                            );
                          })
                    ],
                  )
              ],
            ),
          ),
        );
      }),
    );
  }
}
