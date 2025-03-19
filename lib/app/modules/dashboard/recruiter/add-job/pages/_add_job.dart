import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:joblagbe/app/core/widgets/_custom_button.dart';
import 'package:joblagbe/app/core/widgets/_custom_textfield.dart';
import 'package:joblagbe/app/modules/dashboard/recruiter/add-job/controllers/_add_job_controller.dart';

import '../../../../../core/theming/colors/_colors.dart';
import '../../../../../core/widgets/_dashboard_appbar.dart';
import 'parts/_deadline_selector.dart';
import 'parts/_job_experience_selector.dart';
import 'parts/_job_salary_selector.dart';
import 'parts/_job_type_selector.dart';

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
                child: 
                  AddJobTypeSelector(controller: controller)
                
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
            children: [
              CustomButton(
                  text: 'Next Page',
                  onPressed: () {
                    // controller.addJob();
                  }),
            ],
          )
        ],
      )),
    );
  }
}
