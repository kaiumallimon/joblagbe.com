import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:joblagbe/app/core/theming/colors/_colors.dart';
import 'package:joblagbe/app/core/widgets/_custom_button.dart';
import 'package:joblagbe/app/core/widgets/_custom_textfield.dart';
import 'package:joblagbe/app/core/widgets/_dashboard_appbar.dart';
import 'package:joblagbe/app/modules/dashboard/recruiter/add-job/models/_job_model.dart';
import 'package:joblagbe/app/modules/dashboard/recruiter/add-job/pages/parts/_job_type_selector.dart';
import 'package:joblagbe/app/modules/dashboard/recruiter/jobs/controllers/_job_edit_controller.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:smooth_scroll_multiplatform/smooth_scroll_multiplatform.dart';

class RecruiterJobEditPage extends StatelessWidget {
  const RecruiterJobEditPage({super.key, required this.jobId});

  final String jobId;

  @override
  Widget build(BuildContext context) {
    final jobEditController = Get.find<RecruiterJobEditController>(tag: jobId);

    return Scaffold(
      appBar: dashboardAppbar('Edit Job'),
      backgroundColor: Colors.white,
      body: Obx(() {
        return jobEditController.isLoading.value
            ? Center(
                child: LoadingAnimationWidget.twoRotatingArc(
                  color: Theme.of(context).colorScheme.primary,
                  size: 30,
                ),
              )
            : DynMouseScroll(builder: (context, controller, physics) {
                return SingleChildScrollView(
                  controller: controller,
                  physics: physics,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // company logo, title
                      Row(
                        spacing: 20,
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundImage: NetworkImage(
                              jobEditController
                                  .selectedJob.value!.companyLogoUrl,
                            ),
                          ),
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              spacing: 10,
                              children: [
                                Text(
                                  jobEditController.selectedJob.value!.company,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                CustomTextfield(
                                    width: double.infinity,
                                    height: 50,
                                    isPassword: false,
                                    hintText: 'Enter Job Title',
                                    prefixIcon: Icons.title,
                                    labelText: 'Job Title',
                                    controller:
                                        jobEditController.titleController),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),

                      // description
                      CustomDescriptionField(
                          hintText: 'Enter Job Description',
                          labelText: 'Job Description',
                          height: 200,
                          prefixIcon: Icons.description,
                          controller: jobEditController.descriptionController),

                      const SizedBox(
                        height: 20,
                      ),

                      // skills
                      CustomTextfield(
                          width: double.infinity,
                          height: 50,
                          isPassword: false,
                          hintText: 'Enter Skills (comma separated)',
                          prefixIcon: Icons.code,
                          labelText: 'Skills',
                          controller: jobEditController.skillsController),

                      const SizedBox(
                        height: 20,
                      ),

                      // job type , location, salary range
                      Row(
                        spacing: 20,
                        children: [
                          Expanded(child: Obx(() {
                            return DropdownButtonFormField(
                              decoration: InputDecoration(
                                  labelText: 'Job Type',
                                  prefixIcon: Icon(Icons.work),
                                  focusedBorder: InputBorder.none,
                                  focusColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  fillColor: Colors.transparent,
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                        color: AppColors.darkPrimary
                                            .withOpacity(.15),
                                        width: 2),
                                  ),
                                  filled: false),
                              value: jobEditController.selectedJobType.value,
                              items: jobEditController.jobTypes
                                  .map((String jobType) {
                                return DropdownMenuItem<String>(
                                  value: jobType,
                                  child: Text(jobType),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                jobEditController.selectedJobType.value =
                                    newValue!;
                              },
                            );
                          })),
                          Expanded(
                            child: CustomTextfield(
                                width: double.infinity,
                                height: 50,
                                isPassword: false,
                                hintText: 'Enter Job Location',
                                prefixIcon: Icons.location_on,
                                labelText: 'Job Location',
                                controller:
                                    jobEditController.locationController),
                          ),
                          Expanded(
                            child: Obx(() {
                              return DropdownButtonFormField(
                                decoration: InputDecoration(
                                    labelText: 'Salary Range',
                                    prefixIcon: Icon(Icons.work),
                                    focusedBorder: InputBorder.none,
                                    focusColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    fillColor: Colors.transparent,
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                          color: AppColors.darkPrimary
                                              .withOpacity(.15),
                                          width: 2),
                                    ),
                                    filled: false),
                                value:
                                    jobEditController.selectedSalaryRange.value,
                                items: jobEditController.salaryRange
                                    .map((String salaryRange) {
                                  return DropdownMenuItem<String>(
                                    value: salaryRange,
                                    child: Text(salaryRange),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  jobEditController.selectedSalaryRange.value =
                                      newValue!;
                                },
                              );
                            }),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),

                      // experience level, job tags, application deadline
                      Row(
                        spacing: 20,
                        children: [
                          Expanded(
                            child: Obx(() {
                              return DropdownButtonFormField(
                                decoration: InputDecoration(
                                    labelText: 'Experience Level',
                                    prefixIcon: Icon(Icons.work),
                                    focusedBorder: InputBorder.none,
                                    focusColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    fillColor: Colors.transparent,
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                          color: AppColors.darkPrimary
                                              .withOpacity(.15),
                                          width: 2),
                                    ),
                                    filled: false),
                                value: jobEditController
                                    .selectedExperienceLevel.value,
                                items: jobEditController.experienceLevels
                                    .map((String expLevel) {
                                  return DropdownMenuItem<String>(
                                    value: expLevel,
                                    child: Text(expLevel),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  jobEditController.selectedExperienceLevel
                                      .value = newValue!;
                                },
                              );
                            }),
                          ),
                          Expanded(
                            child: CustomTextfield(
                                width: double.infinity,
                                height: 50,
                                isPassword: false,
                                hintText: 'Enter Job Tags (Comma Separated)',
                                prefixIcon: Icons.tag,
                                labelText: 'Job Tags',
                                controller: jobEditController.tagsController),
                          ),
                          Expanded(
                            child: Obx(() {
                              return MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: GestureDetector(
                                  onTap: () async {
                                    DateTime? pickedDate = await showDatePicker(
                                      context: context,
                                      initialDate: jobEditController
                                              .applicationDeadline.value ??
                                          DateTime.now(),
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime(2101),
                                    );
                                    if (pickedDate != null) {
                                      jobEditController.applicationDeadline
                                          .value = pickedDate;
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10), // Added padding
                                    alignment: Alignment.centerLeft,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          color: AppColors.darkPrimary
                                              .withOpacity(.15),
                                          width: 2),
                                    ),
                                    width: double.infinity,
                                    height: 50,
                                    child: Center(
                                      child: Text(
                                        jobEditController
                                                    .applicationDeadline
                                                    // ignore: unnecessary_null_comparison
                                                    .value ==
                                                null
                                            ? 'Select Application Deadline'
                                            : DateFormat('yyyy-MM-dd').format(
                                                jobEditController
                                                    .applicationDeadline
                                                    .value!),
                                        style: TextStyle(
                                          color:
                                              AppColors.black.withOpacity(.9),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 40,
                      ),

                      // save button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        spacing: 20,
                        children: [
                          Obx(
                             () {
                              return CustomButton(
                                  text: 'Update Job',
                                  isLoading: jobEditController.isLoading.value,
                                  onPressed: () {
                                    jobEditController.updateJob(context);
                                  });
                            }
                          ),
                         
                        ],
                      )
                    ],
                  ),
                );
              });
      }),
    );
  }
}
