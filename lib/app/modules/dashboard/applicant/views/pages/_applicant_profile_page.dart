import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:joblagbe/app/core/theming/colors/_colors.dart';
import 'package:joblagbe/app/core/widgets/_dashboard_appbar.dart';
import 'package:joblagbe/app/modules/dashboard/applicant/controllers/_applicant_profile_controller.dart';
import 'package:joblagbe/app/modules/dashboard/recruiter/views/widgets/_recruiter_profile_custom_dob_selector.dart';
import 'package:joblagbe/app/modules/dashboard/recruiter/views/widgets/_recruiter_profile_custom_profile_textfield.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:smooth_scroll_multiplatform/smooth_scroll_multiplatform.dart';

class ApplicantProfilePage extends StatelessWidget {
  const ApplicantProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    var profileController = Get.put(ApplicantProfileController());

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: dashboardAppbar('Profile & Settings'),
      body: Obx(() {
        if (profileController.isLoading.value) {
          return Center(
            child: LoadingAnimationWidget.threeRotatingDots(
              color: AppColors.darkPrimary,
              size: 30,
            ),
          );
        }
        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile picture
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () {
                        // profileController.pickImage(context);
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
                          child: profileController.applicantProfileData.value
                                      ?.profilePhotoUrl !=
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
                                      ? LoadingAnimationWidget.twoRotatingArc(
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
                          profileController.applicantProfileData.value?.email ??
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

              SizedBox(height: 20),

              Expanded(child:
                  DynMouseScroll(builder: (context, controller, physics) {
                return SingleChildScrollView(
                  controller: controller,
                  physics: physics,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // personal informations
                      Text(
                        'Personal Information',
                        style: TextStyle(
                          color: AppColors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),

                      SizedBox(height: 10),

                      // Name & email

                      Obx(() {
                        return Row(
                          children: [
                            // Name
                            Expanded(
                                child: CustomProfileTextBox(
                              isEditable: false,
                              hintText: 'Enter your name',
                              label: 'Name',
                              controller: TextEditingController(
                                text: profileController
                                        .applicantProfileData.value?.fullName ??
                                    '-',
                              ),
                            )),

                            SizedBox(width: 20),

                            // email

                            Expanded(
                                child: CustomProfileTextBox(
                              isEditable: false,
                              label: 'Email',
                              hintText: 'Enter your email',
                              controller: TextEditingController(
                                text: profileController
                                        .applicantProfileData.value?.email ??
                                    '-',
                              ),
                            ))
                          ],
                        );
                      }),

                      SizedBox(height: 20),

                      // Phone, Location, dob

                      Obx(() {
                        return Row(
                          children: [
                            // Name
                            Expanded(
                                child: CustomProfileTextBox(
                              isEditable: false,
                              hintText: 'Enter your phone number',
                              label: 'Phone',
                              controller: TextEditingController(
                                  text: profileController
                                          .applicantProfileData.value?.phone ??
                                      'N/A'),
                            )),

                            SizedBox(width: 20),

                            // email

                            Expanded(
                                child: CustomProfileTextBox(
                              isEditable: false,
                              label: 'Location',
                              hintText: 'Enter your address',
                              controller: TextEditingController(
                                text: profileController
                                        .applicantProfileData.value?.location ??
                                    'N/A',
                              ),
                            )),

                            // Expanded(
                            //   child: CustomDobSelector(
                            //     controller: profileController,
                            //       isEditable: false,
                            //       hintText: 'Date of Birth',
                            //       initialDate: profileController
                            //                   .applicantProfileData
                            //                   .value
                            //                   ?.dob !=
                            //               null
                            //           ? (profileController
                            //               .applicantProfileData.value!.dob)
                            //           // Safe conversion
                            //           : null),
                            // ),
                          ],
                        );
                      }),

                      SizedBox(height: 20),

                      // bio
                      Obx(() {
                        return Row(
                          children: [
                            Expanded(
                                child: CustomProfileTextBox(
                              maxLines: 3,
                              height: 150,
                              isEditable: false,
                              hintText: 'Enter your bio',
                              label: 'Bio',
                              controller: TextEditingController(
                                  text: profileController
                                          .applicantProfileData.value?.phone ??
                                      'N/A'),
                            )),
                          ],
                        );
                      }),
                    ],
                  ),
                );
              }))
            ],
          ),
        );
      }),
    );
  }
}
