import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:joblagbe/app/core/theming/colors/_colors.dart';
import 'package:joblagbe/app/core/widgets/_custom_button.dart';
import 'package:joblagbe/app/core/widgets/_dashboard_appbar.dart';
import 'package:joblagbe/app/modules/applicant/controllers/_applicant_profile_controller.dart';
import 'package:joblagbe/app/modules/applicant/views/widgets/_applicant_dob_selector.dart';
import 'package:joblagbe/app/modules/applicant/views/widgets/_applicant_gender_selector.dart';
import 'package:joblagbe/app/modules/applicant/views/widgets/_applicant_resume_uploader.dart';
import 'package:joblagbe/app/modules/recruiter/views/widgets/_recruiter_profile_custom_profile_textfield.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:smooth_scroll_multiplatform/smooth_scroll_multiplatform.dart';

class ApplicantProfilePage extends StatelessWidget {
  const ApplicantProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final profileController = Get.put(ApplicantProfileController());

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: dashboardAppbar('Profile & Settings'),
      body: Obx(() {
        if (profileController.isLoading.value) {
          return Center(
            child: LoadingAnimationWidget.twoRotatingArc(
              color: AppColors.primary,
              size: 30,
            ),
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top profile section
            Container(
              height: 120,
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // Profile picture
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () {
                            profileController.pickImage(context);
                          },
                          child: Obx(() {
                            return Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.darkPrimary,
                              ),
                              child: profileController.applicantProfileData
                                          .value?.profilePhotoUrl !=
                                      null
                                  ? ClipOval(
                                      child: Image.network(
                                        profileController.applicantProfileData
                                            .value!.profilePhotoUrl!,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : Center(
                                      child: profileController.isUploading.value
                                          ? LoadingAnimationWidget
                                              .twoRotatingArc(
                                              color: AppColors.white,
                                              size: 30,
                                            )
                                          : Icon(
                                              Icons.camera_alt,
                                              size: 25,
                                              color: AppColors.white,
                                            ),
                                    ),
                            );
                          }),
                        ),
                      ),
                      SizedBox(width: 20),
                      // Name & email
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Obx(() {
                            return Text(
                              profileController
                                      .applicantProfileData.value?.fullName ??
                                  '-',
                              style: TextStyle(
                                color: AppColors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 23,
                                height: 1.2,
                              ),
                            );
                          }),
                          Obx(() {
                            return Text(
                              profileController
                                      .applicantProfileData.value?.email ??
                                  '-',
                              style: TextStyle(
                                color: AppColors.darkBackground,
                                fontSize: 16,
                              ),
                            );
                          }),
                        ],
                      ),
                    ],
                  ),
                  Obx(() {
                    return CustomButton(
                      text: profileController.isEditingMode.value
                          ? "Cancel"
                          : "Edit",
                      onPressed: () {
                        profileController.toggleEditingMode();
                      },
                      color: profileController.isEditingMode.value
                          ? AppColors.darkBackground
                          : AppColors.primary,
                      textColor: profileController.isEditingMode.value
                          ? AppColors.white
                          : AppColors.black,
                    );
                  })
                ],
              ),
            ),

            // Body section
            Expanded(
              child: DynMouseScroll(
                builder: (context, controller, physics) {
                  return ListView(
                    controller: controller,
                    physics: physics,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    children: [
                      Text(
                        'Personal Information (Required)',
                        style: TextStyle(
                          color: AppColors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20),
                      Obx(() => Row(
                            children: [
                              Expanded(
                                child: CustomProfileTextBox(
                                  isEditable:
                                      profileController.isEditingMode.value,
                                  hintText: 'Enter your name',
                                  label: 'Name',
                                  controller:
                                      profileController.nameController.value,
                                ),
                              ),
                              SizedBox(width: 20),
                              Expanded(
                                child: CustomProfileTextBox(
                                  isEditable: false,
                                  hintText: 'Enter your email',
                                  label: 'Email',
                                  controller:
                                      profileController.emailController.value,
                                ),
                              ),
                            ],
                          )),
                      SizedBox(height: 20),
                      Obx(() => Row(
                            spacing: 15,
                            children: [
                              Expanded(
                                child: ApplicantGenderSelector(
                                  isEditable:
                                      profileController.isEditingMode.value,
                                  hintText: 'Gender',
                                ),
                              ),
                              Expanded(
                                child: ApplicantDobSelector(
                                  isEditable:
                                      profileController.isEditingMode.value,
                                  hintText: 'Date of Birth',
                                  initialDate:
                                      profileController.selectedDob.value,
                                ),
                              ),
                            ],
                          )),
                      SizedBox(height: 20),
                      Obx(() => Row(
                            children: [
                              Expanded(
                                child: CustomProfileTextBox(
                                  isEditable:
                                      profileController.isEditingMode.value,
                                  hintText: 'Enter your phone number',
                                  label: 'Phone Number',
                                  controller:
                                      profileController.phoneController.value,
                                ),
                              ),
                              SizedBox(width: 20),
                              Expanded(
                                child: CustomProfileTextBox(
                                  isEditable:
                                      profileController.isEditingMode.value,
                                  hintText: 'Enter your location',
                                  label: 'Location',
                                  controller: profileController
                                      .locationController.value,
                                ),
                              ),
                            ],
                          )),
                      SizedBox(height: 20),
                      Obx(() => Row(
                            children: [
                              Expanded(
                                child: CustomProfileTextBox(
                                  isEditable:
                                      profileController.isEditingMode.value,
                                  hintText: 'Enter your professional title',
                                  label: 'Professional Title',
                                  controller: profileController
                                      .professionalTitleController.value,
                                ),
                              ),
                              SizedBox(width: 20),
                              Expanded(
                                child: CustomProfileTextBox(
                                  isEditable:
                                      profileController.isEditingMode.value,
                                  hintText:
                                      'Enter your skills (comma separated)',
                                  label: 'Skills',
                                  controller:
                                      profileController.skillsController.value,
                                ),
                              ),
                            ],
                          )),
                      SizedBox(height: 20),
                      Obx(() => CustomProfileTextBox(
                            isEditable: profileController.isEditingMode.value,
                            hintText: 'Enter your bio',
                            label: 'Bio',
                            maxLines: 3,
                            height: 100,
                            controller: profileController.bioController.value,
                          )),
                      SizedBox(height: 40),
                      Text(
                        'Resume',
                        style: TextStyle(
                          color: AppColors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20),
                      Obx(() => Row(
                            children: [
                              Expanded(
                                child: ApplicantResumeUploader(
                                  isEditable:
                                      profileController.isEditingMode.value,
                                ),
                              ),
                            ],
                          )),
                      SizedBox(height: 40),
                      Obx(() {
                        if (profileController.isEditingMode.value) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomButton(
                                text: 'Save',
                                onPressed: () {
                                  profileController.updateProfileData(context);
                                },
                              ),
                            ],
                          );
                        } else {
                          return SizedBox.shrink();
                        }
                      }),
                    ],
                  );
                },
              ),
            ),
          ],
        );
      }),
    );
  }
}
