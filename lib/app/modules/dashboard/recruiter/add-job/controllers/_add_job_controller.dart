import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:joblagbe/app/core/widgets/_custom_dialog.dart';

class AddJobController extends GetxController {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final skillsController = TextEditingController();
  final locationController = TextEditingController();
  final tagsController = TextEditingController();

  var jobTypes = [
    'Full-time',
    'Part-time',
    'Internship',
  ].obs;

  var selectedJobType = 'Full-time'.obs;

  var salaryRange = [
    '0-10k',
    '10k-20k',
    '20k-30k',
    '30k-40k',
    '40k-50k',
    '50k-60k',
    '60k-70k',
    '70k-80k',
    '80k-90k',
    '90k-100k',
    '100k+',
  ].obs;

  var selectedSalaryRange = '30k-40k'.obs;

  var experienceLevels = [
    'Fresher',
    '1-2 years',
    '2-5 years',
    '5+ years',
  ].obs;

  var selectedExperienceLevel = '2-5 years'.obs;

  var applicationDeadline = Rxn<DateTime>();

  var selectedPage = 0.obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    titleController.dispose();
    skillsController.dispose();
    locationController.dispose();
  }

  bool validateAllFields(BuildContext context) {
    if (titleController.text.isEmpty) {
      showCustomDialog(
          context: context,
          title: 'Error',
          content: "Title cannot be empty",
          buttonText: 'Okay',
          onButtonPressed: Navigator.of(context).pop,
          buttonColor: Colors.red);
      return false;
    }
    if (descriptionController.text.isEmpty) {
      showCustomDialog(
          context: context,
          title: 'Error',
          content: "Description cannot be empty",
          buttonText: 'Okay',
          onButtonPressed: Navigator.of(context).pop,
          buttonColor: Colors.red);
      return false;
    }
    if (skillsController.text.isEmpty) {
      showCustomDialog(
          context: context,
          title: 'Error',
          content: "Enter at least one skill",
          buttonText: 'Okay',
          onButtonPressed: Navigator.of(context).pop,
          buttonColor: Colors.red);

      return false;
    }
    if (locationController.text.isEmpty) {
      showCustomDialog(
          context: context,
          title: 'Error',
          content: "Location cannot be empty",
          buttonText: 'Okay',
          onButtonPressed: Navigator.of(context).pop,
          buttonColor: Colors.red);
      return false;
    }
    if (applicationDeadline.value == null) {
      showCustomDialog(
          context: context,
          title: 'Error',
          content: "Please select a deadline for the application",
          buttonText: 'Okay',
          onButtonPressed: Navigator.of(context).pop,
          buttonColor: Colors.red);
      return false;
    }
    return true;
  }

  var toggleView = false.obs;

  void viewAsCandidate(BuildContext context) {
    try {
      if (!validateAllFields(context)) {
        return;
      }
      toggleView.value = true;
    } catch (e) {
      showCustomDialog(
          context: Get.context!,
          title: 'Error',
          content: "Something went wrong",
          buttonText: 'Okay',
          onButtonPressed: Navigator.of(Get.context!).pop,
          buttonColor: Colors.red);
    }
  }
}
