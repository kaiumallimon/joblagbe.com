import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:joblagbe/app/core/widgets/_custom_button.dart';
import 'package:joblagbe/app/core/widgets/_custom_textfield.dart';
import 'package:joblagbe/app/modules/recruiter/controllers/_recruiter_add_job_controller.dart';
import 'package:joblagbe/app/modules/recruiter/views/pages/_add_job_mcq_page.dart';
import 'package:joblagbe/app/modules/recruiter/views/widgets/_job_category_selector.dart';
import 'package:smooth_scroll_multiplatform/smooth_scroll_multiplatform.dart';

import '../../../../core/theming/colors/_colors.dart';
import '../../../../core/widgets/_dashboard_appbar.dart';
import '../widgets/_recruiter_add_job_deadline_selector.dart';
import '../widgets/_job_experience_selector.dart';
import '../widgets/_job_salary_selector.dart';
import '../widgets/_recruiter_job_type_selector.dart';

class AddJobPage extends StatelessWidget {
  const AddJobPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AddJobController());
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: dashboardAppbar('Post a Job'),
      body: SafeArea(child: Obx(() {
        if (controller.selectedPage.value == 1) {
          return Row(
            spacing: 10,
            children: [
              //form
              AddJobForm(controller: controller),

              //  view as candidate

              ViewJobFormData(controller: controller)
            ],
          );
        } else {
          return AddJobPage2();
        }
      })),
    );
  }
}

class AddJobForm extends StatelessWidget {
  const AddJobForm({
    super.key,
    required this.controller,
  });

  final AddJobController controller;

  @override
  Widget build(BuildContext context) {
    return Expanded(
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
          Text('Job Details',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.black.withOpacity(.9),
              )),
          const SizedBox(
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
          Row(
            spacing: 15,
            children: [
              Expanded(
                child: CustomTextfield(
                    width: double.infinity,
                    height: 50,
                    isPassword: false,
                    hintText: 'Enter Job Skills',
                    prefixIcon: Icons.work,
                    labelText: 'Job Skills',
                    controller: controller.skillsController),
              ),
              Expanded(
                  child: AddJobCategorySelector(
                controller: controller,
              ))
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            spacing: 20,
            children: [
              Expanded(child: AddJobTypeSelector(controller: controller)),
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
                child: AddJobSalarySelector(controller: controller),
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
                child: AddJobExperienceSelector(controller: controller),
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
              AddJobDeadlineSelector(controller: controller)
            ],
          ),
          const SizedBox(
            height: 40,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 20,
            children: [
              CustomButton(
                  text: 'Next Page',
                  onPressed: () {
                    if (controller.validateAllFields(context) &&
                        controller.isProfileComplete(context)) {
                      controller.selectedPage.value = 2;
                    }
                  }),
              CustomButton(
                  text: 'View As Candidate',
                  color: AppColors.darkPrimary,
                  textColor: AppColors.white,
                  onPressed: () {
                    controller.viewAsCandidate(context);
                  }),
            ],
          )
        ],
      ),
    );
  }
}

class ViewJobFormData extends StatelessWidget {
  const ViewJobFormData({
    super.key,
    required this.controller,
  });

  final AddJobController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.toggleView.value) {
        return Expanded(
            child: Container(
          margin: EdgeInsets.only(bottom: 20),
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child: DynMouseScroll(builder: (context, scrollController, physics) {
            return SingleChildScrollView(
              controller: scrollController,
              physics: physics,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    controller.titleController.text,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppColors.black,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    controller.descriptionController.text,
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.black.withOpacity(.8),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Skills required: ${controller.skillsController.text}',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.black.withOpacity(.8),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Location: ${controller.locationController.text}',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.black.withOpacity(.8),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Salary: ${controller.selectedSalaryRange.value}',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.black.withOpacity(.8),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Experience required: ${controller.selectedExperienceLevel.value}',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.black.withOpacity(.8),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Deadline: ${controller.applicationDeadline.value?.toLocal().toString().split(' ')[0]}',
                    style: TextStyle(
                        fontSize: 16,
                        color: AppColors.black.withOpacity(.8),
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    controller.tagsController.text,
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.black.withOpacity(.8),
                    ),
                  ),
                ],
              ),
            );
          }),
        ));
      } else {
        return const SizedBox.shrink();
      }
    });
  }
}
