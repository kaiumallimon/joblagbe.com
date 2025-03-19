import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:joblagbe/app/core/widgets/_custom_textfield.dart';
import 'package:joblagbe/app/modules/dashboard/recruiter/add-job/controllers/_add_job_controller.dart';

import '../../../../../core/theming/colors/_colors.dart';
import '../../../../../core/widgets/_dashboard_appbar.dart';

class AddJobPage extends StatelessWidget {
  const AddJobPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AddJobController());
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: dashboardAppbar('Post a Job'),
      body: SafeArea(
          child: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        children: [
          SizedBox(
            width: 300,
            child: Text(
              'To post a job, please provide the required job details below, including title, category, salary, and description.\nAfter completing this step, proceed to the next page to add MCQs relevant to the job.\nThe MCQ test helps assess candidates’ skills before applying.\nEnsure that all required fields are correctly filled before submission.',
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: AppColors.black.withOpacity(.9),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          CustomTextfield(
              width: double.infinity,
              height: 50,
              isPassword: false,
              hintText: 'Enter Job Title',
              prefixIcon: Icons.title,
              labelText: 'Job Title',
              controller: controller.titleController),
          const SizedBox(
            height: 20,
          ),
          CustomDescriptionField(
              hintText: 'Enter Job Description',
              labelText: 'Job Description',
              prefixIcon: Icons.description,
              controller: controller.descriptionController),
          const SizedBox(
            height: 20,
          ),
          CustomTextfield(
              width: double.infinity,
              height: 50,
              isPassword: false,
              hintText: 'Enter Job Skills',
              prefixIcon: Icons.work,
              labelText: 'Job Skills',
              controller: controller.skillsController),
          const SizedBox(
            height: 20,
          ),
          Row(
            spacing: 20,
            children: [
              Expanded(
                child: Obx(() {
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
                              color: AppColors.darkPrimary.withOpacity(.15),
                              width: 2),
                        ),
                        filled: false),
                    value: controller.selectedJobType.value,
                    items: controller.jobTypes.map((String jobType) {
                      return DropdownMenuItem<String>(
                        value: jobType,
                        child: Text(jobType),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      controller.selectedJobType.value = newValue!;
                    },
                  );
                }),
              ),
              Expanded(
                child: CustomTextfield(
                    width: double.infinity,
                    height: 50,
                    isPassword: false,
                    hintText: 'Enter Job Location',
                    prefixIcon: Icons.location_on,
                    labelText: 'Job Location',
                    controller: controller.locationController),
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
                              color: AppColors.darkPrimary.withOpacity(.15),
                              width: 2),
                        ),
                        filled: false),
                    value: controller.selectedSalaryRange.value,
                    items: controller.salaryRange.map((String salaryRange) {
                      return DropdownMenuItem<String>(
                        value: salaryRange,
                        child: Text(salaryRange),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      controller.selectedSalaryRange.value = newValue!;
                    },
                  );
                }),
              )
            ],
          ),
          const SizedBox(
            height: 20,
          ),
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
                              color: AppColors.darkPrimary.withOpacity(.15),
                              width: 2),
                        ),
                        filled: false),
                    value: controller.selectedExperienceLevel.value,
                    items: controller.experienceLevels.map((String expLevel) {
                      return DropdownMenuItem<String>(
                        value: expLevel,
                        child: Text(expLevel),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      controller.selectedExperienceLevel.value = newValue!;
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
                    controller: controller.tagsController),
              ),
              Expanded(
                child: Obx(() {
                  return MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: controller.applicationDeadline.value ??
                              DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2101),
                        );
                        if (pickedDate != null) {
                          controller.applicationDeadline.value = pickedDate;
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10), // Added padding
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: AppColors.darkPrimary.withOpacity(.15),
                              width: 2),
                        ),
                        width: double.infinity,
                        height: 50,
                        child: Center(
                          child: Text(
                            controller.applicationDeadline.value == null
                                ? 'Select Application Deadline'
                                : DateFormat('yyyy-MM-dd').format(
                                    controller.applicationDeadline.value!),
                            style: TextStyle(
                              color: AppColors.black.withOpacity(.9),
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
        ],
      )),
    );
  }
}
