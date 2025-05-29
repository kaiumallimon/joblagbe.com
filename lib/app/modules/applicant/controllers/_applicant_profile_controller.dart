import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:joblagbe/app/core/theming/colors/_colors.dart';
import 'package:joblagbe/app/core/widgets/_custom_loading.dart';
import 'package:joblagbe/app/data/models/_applicant_profile_model.dart';
import 'package:joblagbe/app/data/services/_applicant_profile_services.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

class ApplicantProfileController extends GetxController {
  Rxn<ApplicantProfileModel> applicantProfileData =
      Rxn<ApplicantProfileModel>();
  final ApplicantProfileService service = ApplicantProfileService();
  RxBool isUploading = false.obs;
  RxBool isResumeUploading = false.obs;
  RxBool isLoading = true.obs;
  RxBool isEditingMode = false.obs;

  // Text controllers
  final Rx<TextEditingController> nameController = TextEditingController().obs;
  final Rx<TextEditingController> emailController = TextEditingController().obs;
  final Rx<TextEditingController> phoneController = TextEditingController().obs;
  final Rx<TextEditingController> locationController =
      TextEditingController().obs;
  final Rx<TextEditingController> bioController = TextEditingController().obs;
  final Rx<TextEditingController> professionalTitleController =
      TextEditingController().obs;
  final Rx<TextEditingController> skillsController =
      TextEditingController().obs;

  var selectedDob = Rxn<DateTime>();
  var genders = ["Male", "Female"].obs;
  var selectedGender = "Male".obs;

  void fetchApplicantProfileData() async {
    isLoading.value = true;
    String uid = FirebaseAuth.instance.currentUser!.uid;
    var response = await service.getApplicantProfileData(uid);
    if (response != null) {
      applicantProfileData.value = response;
      // Set controllers
      nameController.value.text = response.fullName;
      emailController.value.text = response.email;
      phoneController.value.text = response.phone ?? '';
      locationController.value.text = response.location ?? '';
      bioController.value.text = response.bio ?? '';
      professionalTitleController.value.text = response.professionalTitle ?? '';
      skillsController.value.text = response.skills?.join(', ') ?? '';
      selectedDob.value = response.dob;
      isLoading.value = false;
    } else {
      isLoading.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchApplicantProfileData();
  }

  void toggleEditingMode() {
    isEditingMode.value = !isEditingMode.value;
  }

  Future<void> updateProfileData(BuildContext context) async {
    if (applicantProfileData.value == null) return;
    try {
      Map<String, dynamic> updatedData = {
        "fullName": nameController.value.text,
        "email": emailController.value.text,
        "phone": phoneController.value.text.isNotEmpty
            ? phoneController.value.text
            : null,
        "location": locationController.value.text.isNotEmpty
            ? locationController.value.text
            : null,
        "bio": bioController.value.text.isNotEmpty
            ? bioController.value.text
            : null,
        "professionalTitle": professionalTitleController.value.text.isNotEmpty
            ? professionalTitleController.value.text
            : null,
        "skills": skillsController.value.text.isNotEmpty
            ? skillsController.value.text
                .split(',')
                .map((e) => e.trim())
                .toList()
            : null,
        "dob": selectedDob.value?.toIso8601String(),
        "gender": selectedGender.value,
      };

      await service.updateApplicantProfile(
          applicantProfileData.value!.id!, updatedData);

      applicantProfileData.value = applicantProfileData.value!.copyWith(
        fullName: nameController.value.text,
        email: emailController.value.text,
        phone: phoneController.value.text.isNotEmpty
            ? phoneController.value.text
            : null,
        location: locationController.value.text.isNotEmpty
            ? locationController.value.text
            : null,
        bio: bioController.value.text.isNotEmpty
            ? bioController.value.text
            : null,
        professionalTitle: professionalTitleController.value.text.isNotEmpty
            ? professionalTitleController.value.text
            : null,
        skills: skillsController.value.text.isNotEmpty
            ? skillsController.value.text
                .split(',')
                .map((e) => e.trim())
                .toList()
            : null,
        dob: selectedDob.value,
      );
      applicantProfileData.refresh();
      customDialog("Success", "Profile updated successfully");
      toggleEditingMode();
      html.window.location.reload();
    } catch (e) {
      customDialog("Error", "Failed to update profile: $e");
    }
  }

  Future<void> pickImage(BuildContext context) async {
    try {
      final html.FileUploadInputElement uploadInput =
          html.FileUploadInputElement();
      uploadInput.accept = 'image/*';
      uploadInput.click();

      uploadInput.onChange.listen((e) async {
        final files = uploadInput.files;
        if (files == null || files.isEmpty) return;

        final file = files.first;
        final reader = html.FileReader();

        reader.readAsArrayBuffer(file);

        reader.onLoadEnd.listen((event) async {
          try {
            Uint8List imageBytes = reader.result as Uint8List;
            isUploading.value = true;
            bool success = await service.uploadProfilePhoto(
                imageBytes, applicantProfileData.value!.id!);
            isUploading.value = false;
            if (success) {
              customDialog("Success", "Image uploaded successfully");
              html.window.location.reload();
            } else {
              customDialog("Error", "Failed to upload image");
            }
          } catch (err) {
            isUploading.value = false;
            customDialog("Error", "Failed to process image: $err");
          }
        });
      });
    } catch (err) {
      customDialog("Error", "Failed to pick image: $err");
    }
  }

  Future<void> pickResume(BuildContext context) async {
    try {
      final html.FileUploadInputElement uploadInput =
          html.FileUploadInputElement();
      uploadInput.accept = '.pdf';
      uploadInput.click();

      uploadInput.onChange.listen((e) async {
        final files = uploadInput.files;
        if (files == null || files.isEmpty) return;

        final file = files.first;
        final reader = html.FileReader();

        reader.readAsArrayBuffer(file);

        reader.onLoadEnd.listen((event) async {
          try {
            Uint8List fileBytes = reader.result as Uint8List;
            isResumeUploading.value = true;
            bool success = await service.uploadResume(
                fileBytes, applicantProfileData.value!.id!);
            isResumeUploading.value = false;
            if (success) {
              customDialog("Success", "Resume uploaded successfully");
              html.window.location.reload();
            } else {
              customDialog("Error", "Failed to upload resume");
            }
          } catch (err) {
            isResumeUploading.value = false;
            customDialog("Error", "Failed to process resume: $err");
          }
        });
      });
    } catch (err) {
      customDialog("Error", "Failed to pick resume: $err");
    }
  }
}
