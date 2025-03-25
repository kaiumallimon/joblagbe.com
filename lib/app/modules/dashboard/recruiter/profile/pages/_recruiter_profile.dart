import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:joblagbe/app/core/theming/colors/_colors.dart';
import 'package:joblagbe/app/core/widgets/_custom_button.dart';
import 'package:joblagbe/app/modules/dashboard/recruiter/profile/controllers/_recruiter_profile_controller.dart';
import 'package:joblagbe/app/modules/dashboard/recruiter/profile/pages/parts/_compay_logo_selector.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:smooth_scroll_multiplatform/smooth_scroll_multiplatform.dart';
import 'dart:html' as html;
import '../../../../../core/widgets/_dashboard_appbar.dart';
import 'parts/_custom_dob_selector.dart';
import 'parts/_custom_profile_textfield.dart';
import 'parts/_gender_selector.dart';

class RecruiterProfilePage extends StatelessWidget {
  const RecruiterProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final profileController = Get.put(RecruiterProfileController());

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
          spacing: 20,
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
                            // html.window.location.reload();
                          },
                          child: Obx(() {
                            return Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.darkPrimary,
                              ),
                              child: profileController.profileData.value
                                          ?.profilePictureUrl !=
                                      null
                                  ? ClipOval(
                                      child: Image.network(
                                        profileController.profileData.value!
                                            .profilePictureUrl!,
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
                        spacing: 5,
                        children: [
                          Obx(() {
                            return Text(
                              profileController.profileData.value?.name ?? '-',
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
                              profileController.profileData.value?.email ?? '-',
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
                            spacing: 20,
                            children: [
                              Expanded(
                                child: CustomProfileTextBox(
                                  isEditable:
                                      profileController.isEditingMode.value,
                                  hintText: 'Enter your name',
                                  label: 'Name',
                                  // text: 'Kaium Al Limon',
                                  controller:
                                      profileController.nameController.value,
                                ),
                              ),
                              Expanded(
                                child: CustomProfileTextBox(
                                  isEditable: false,
                                  hintText: 'Enter your email',
                                  label: 'Email',
                                  // text: 'kalimon291@gmail.com',
                                  controller:
                                      profileController.emailController.value,
                                ),
                              ),
                            ],
                          )),
                      SizedBox(height: 20),
                      Obx(() => Row(
                            spacing: 20,
                            children: [
                              Expanded(
                                child: CustomGenderSelector(
                                  isEditable:
                                      profileController.isEditingMode.value,
                                  hintText: 'Gender',
                                ),
                              ),
                              Expanded(
                                child: CustomDobSelector(
                                    isEditable:
                                        profileController.isEditingMode.value,
                                    hintText: 'Date of Birth',
                                    initialDate: profileController
                                                .profileData.value?.dob !=
                                            null
                                        ? (profileController.profileData.value!
                                                .dob as Timestamp)
                                            .toDate() // Safe conversion
                                        : null),
                              ),
                            ],
                          )),
                      SizedBox(height: 20),
                      Obx(() => Row(
                            spacing: 20,
                            children: [
                              Expanded(
                                child: CustomProfileTextBox(
                                  isEditable:
                                      profileController.isEditingMode.value,
                                  hintText: 'Enter your phone number',
                                  label: 'Phone Number',
                                  // text: '+880 1234567890',
                                  controller:
                                      profileController.phoneController.value,
                                ),
                              ),
                              Expanded(
                                child: CustomProfileTextBox(
                                  isEditable:
                                      profileController.isEditingMode.value,
                                  hintText: 'Enter your company name',
                                  label: 'Company Name',
                                  // text: 'Google Inc.',
                                  controller: profileController
                                      .companyNameController.value,
                                ),
                              ),
                            ],
                          )),
                      SizedBox(height: 20),
                      Obx(() => Row(
                            spacing: 20,
                            children: [
                              Expanded(
                                child: CustomProfileTextBox(
                                  isEditable:
                                      profileController.isEditingMode.value,
                                  hintText: 'Enter your designation',
                                  label: 'Designation',
                                  // text: 'Human Resource Manager',
                                  controller: profileController
                                      .designationController.value,
                                ),
                              ),
                              Expanded(
                                child: CustomLogoSelector(
                                  isEditable:
                                      profileController.isEditingMode.value,
                                ),
                              ),
                            ],
                          )),
                      SizedBox(height: 40),
                      Text(
                        'Job Description (Optional)',
                        style: TextStyle(
                          color: AppColors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20),
                      Obx(() => CustomProfileTextBox(
                            isEditable: profileController.isEditingMode.value,
                            hintText: 'Enter your job description',
                            label: 'Job Description',
                            maxLines: null,
                            height: 150,
                            controller: profileController
                                .jobDescriptionController.value,
                            // text:
                            //     'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
                          )),
                      SizedBox(height: 20),
                      Obx(() {
                        if (profileController.isEditingMode.value) {
                          return Row(
                            spacing: 20,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomButton(
                                text: 'Save',
                                onPressed: () {
                                  profileController.updateProfileData(context);
                                  // html.window.location.reload();
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
