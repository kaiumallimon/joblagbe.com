import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:joblagbe/app/core/theming/colors/_colors.dart';
import 'package:joblagbe/app/core/widgets/_custom_loading.dart';
import 'package:joblagbe/app/modules/dashboard/recruiter/profile/models/_recruiter_profile_model.dart';
import 'package:joblagbe/app/modules/dashboard/recruiter/profile/services/_recruiter_profile_service.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

class RecruiterProfileController extends GetxController {
  RxBool isEditingMode = false.obs;
  var genders = ["Male", "Female"].obs;
  var selectedGender = "Male".obs;
  var selectedDob = Rxn<DateTime>();

  var profileData = Rxn<RecruiterProfileModel>();

  final Rx<TextEditingController> nameController = TextEditingController().obs;
  final Rx<TextEditingController> emailController = TextEditingController().obs;
  final Rx<TextEditingController> phoneController = TextEditingController().obs;
  final Rx<TextEditingController> companyNameController =
      TextEditingController().obs;
  final Rx<TextEditingController> companyLogoController =
      TextEditingController().obs;
  final Rx<TextEditingController> jobDescriptionController =
      TextEditingController().obs;
  final Rx<TextEditingController> designationController =
      TextEditingController().obs;

  final RecruiterProfileService profileService = RecruiterProfileService();

  void toggleEditingMode() {
    isEditingMode.value = !isEditingMode.value;
  }

  var isLoading = true.obs;

  /// Fetch profile data
  void fetchProfileData() async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      var response = await profileService.fetchRecruiterProfileData(uid);

      profileData.value = response;
      profileData.refresh();
      isLoading.value = false;

      // Update text controllers with fetched data
      nameController.value.text = response.name;
      emailController.value.text = response.email;
      phoneController.value.text = response.phoneNumber ?? '';
      companyNameController.value.text = response.companyName ?? '';
      companyLogoController.value.text = response.companyLogoUrl ?? '';
      jobDescriptionController.value.text = response.jobDescription ?? '';
      designationController.value.text = response.designation ?? '';

      // print('Profile data fetched successfully: ${profileData.value!.toMap()}');
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch profile data: $e",
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  /// 🔥 Function to update profile data
  Future<void> updateProfileData(BuildContext context) async {
    if (profileData.value == null) return;

    try {
      Map<String, dynamic> updatedData = {
        "name": nameController.value.text,
        "email": emailController.value.text,
        "phone": phoneController.value.text.isNotEmpty
            ? phoneController.value.text
            : null,
        "companyName": companyNameController.value.text.isNotEmpty
            ? companyNameController.value.text
            : null,
        "companyLogo": companyLogoController.value.text.isNotEmpty
            ? companyLogoController.value.text
            : null,
        "jobDescription": jobDescriptionController.value.text.isNotEmpty
            ? jobDescriptionController.value.text
            : null,
        "designation": designationController.value.text.isNotEmpty
            ? designationController.value.text
            : null,
        "gender": selectedGender.value,
        "dob": selectedDob.value != null
            ? Timestamp.fromDate(selectedDob.value!)
            : null,
      };

      await profileService.updateRecruiterProfile(
          profileData.value!.profileId, updatedData);

      // Update the local profile data
      profileData.value = profileData.value!.copyWith(
        name: nameController.value.text,
        email: emailController.value.text,
        phoneNumber: phoneController.value.text.isNotEmpty
            ? phoneController.value.text
            : null,
        companyName: companyNameController.value.text.isNotEmpty
            ? companyNameController.value.text
            : null,
        companyLogoUrl: companyLogoController.value.text.isNotEmpty
            ? companyLogoController.value.text
            : null,
        jobDescription: jobDescriptionController.value.text.isNotEmpty
            ? jobDescriptionController.value.text
            : null,
        designation: designationController.value.text.isNotEmpty
            ? designationController.value.text
            : null,
        gender: selectedGender.value,
        dob: selectedDob.value != null
            ? Timestamp.fromDate(selectedDob.value!)
            : null,
      );
      profileData.refresh();
      customDialog(
        "Success",
        "Profile upated successfully",
      );

      toggleEditingMode();
      html.window.location.reload();
    } catch (e) {
      customDialog(
        "Error",
        "Failed to update profile: $e",
      );
      // Get.snackbar("Error", "Failed to update profile: $e", snackPosition: SnackPosition.BOTTOM);
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchProfileData();
  }


  var isUploading = false.obs;

  Future<void> pickImage(BuildContext context) async {
    try {
      // Create a file input element
      final html.FileUploadInputElement uploadInput =
          html.FileUploadInputElement();
      uploadInput.accept = 'image/*';
      uploadInput.click();

      uploadInput.onChange.listen((e) async {
        final files = uploadInput.files;
        if (files == null || files.isEmpty) return;

        final file = files.first;
        final reader = html.FileReader();

        reader.readAsArrayBuffer(file); // Read file as raw bytes

        reader.onLoadEnd.listen((event) async {
          try {
            Uint8List imageBytes = reader.result as Uint8List;

            isUploading.value = true;

            bool success = await profileService.uploadImage(
                imageBytes, profileData.value!.profileId);

            isUploading.value = false;

            if (success) {
              customDialog(
                "Success",
                "Image uploaded successfully",
              );

              html.window.location
                  .reload(); // Refresh page to reflect new image
            } else {
              customDialog(
                "Error",
                "Failed to upload image",
              );
            }
          } catch (err) {
            isUploading.value = false;
            customDialog(
              "Error",
              "Failed to process image: $err",
            );
          }
        });
      });
    } catch (err) {
      customDialog(
        "Error",
        "Failed to pick image: $err",
      );
    }
  }


  var isLogoUploading = false.obs;


  Future<void> pickLogo(BuildContext context) async {
    try {
      // Create a file input element
      final html.FileUploadInputElement uploadInput =
          html.FileUploadInputElement();
      uploadInput.accept = 'image/*';
      uploadInput.click();

      uploadInput.onChange.listen((e) async {
        final files = uploadInput.files;
        if (files == null || files.isEmpty) return;

        final file = files.first;
        final reader = html.FileReader();

        reader.readAsArrayBuffer(file); // Read file as raw bytes

        reader.onLoadEnd.listen((event) async {
          try {
            Uint8List imageBytes = reader.result as Uint8List;

            isLogoUploading.value = true;

            bool success = await profileService.uploadLogo(
                imageBytes, profileData.value!.profileId);

            isLogoUploading.value = false;

            if (success) {
              customDialog(
                "Success",
                "Logo uploaded successfully",
              );

              html.window.location
                  .reload(); // Refresh page to reflect new image
            } else {
              customDialog(
                "Error",
                "Failed to upload Logo",
              );
            }
          } catch (err) {
            isUploading.value = false;
            customDialog(
              "Error",
              "Failed to process Logo: $err",
            );
          }
        });
      });
    } catch (err) {
      customDialog(
        "Error",
        "Failed to pick Logo: $err",
      );
    }
  }
}
