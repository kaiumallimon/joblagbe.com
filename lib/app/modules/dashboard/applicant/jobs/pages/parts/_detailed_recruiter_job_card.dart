import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:joblagbe/app/core/theming/colors/_colors.dart';
import 'package:joblagbe/app/core/utils/_formatter.dart';
import 'package:joblagbe/app/core/widgets/_custom_button.dart';
import 'package:joblagbe/app/modules/dashboard/applicant/jobs/controllers/_applicant_jobs_controller.dart';
import 'package:smooth_scroll_multiplatform/smooth_scroll_multiplatform.dart';

class ApplicantJobDetailedViewCard extends StatelessWidget {
  const ApplicantJobDetailedViewCard({
    super.key,
    required this.jobsController,
  });

  final ApplicantJobsController jobsController;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: DynMouseScroll(builder: (context, controller, physics) {
        return SingleChildScrollView(
          controller: controller,
          physics: physics,
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            spacing: 20,
            children: [
              // close button and current route
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // current go route
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
                      icon: Icon(Icons.close)),
                ],
              ),

              // company logo and job title
              // and deadline
              Row(
                spacing: 20,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                          jobsController.selectedJob.value!.companyLogoUrl,
                          fit: BoxFit.cover,
                          headers: {
                            "Access-Control-Allow-Origin":
                                "*", // Might be ignored by the browser
                          }),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 5,
                      children: [
                        Text(
                          jobsController.selectedJob.value!.title,
                          style: TextStyle(
                            color: AppColors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          DateTimeFormatter().formatJobDeadline(
                              jobsController.selectedJob.value!.deadline),
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
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // job type
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
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
                          jobsController.selectedJob.value!.jobType,
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
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
                          jobsController.selectedJob.value!.location,
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
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

              Text('The applicant must be proficient in the following skills:',
                  style: TextStyle(
                    color: AppColors.black,
                    fontSize: 16,
                  )),

              ...jobsController.selectedJob.value!.skills.map(
                (skill) => Text(
                  "- $skill",
                  style: TextStyle(
                      color: AppColors.black, fontSize: 14, height: 1),
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
                children: jobsController.selectedJob.value!.tags
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
              ),

              const SizedBox(height: 20),

              // apply button
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CustomButton(
                      width: 180,
                      height: 50,
                      text: 'Apply Post',
                      onPressed: () {})
                ],
              )
            ],
          ),
        );
      }),
    );
  }
}
