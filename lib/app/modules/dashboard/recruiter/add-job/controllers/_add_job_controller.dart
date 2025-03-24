import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:joblagbe/app/core/widgets/_custom_dialog.dart';
import 'package:joblagbe/app/core/widgets/_custom_loading.dart';
import 'package:joblagbe/app/modules/dashboard/recruiter/add-job/models/_job_model.dart';
import 'package:joblagbe/app/modules/dashboard/recruiter/add-job/services/_add_job_service.dart';
import 'package:joblagbe/app/modules/dashboard/recruiter/profile/controllers/_recruiter_profile_controller.dart';
import '../models/_mcq_model.dart';

class AddJobController extends GetxController {
  // Controllers for text fields
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final skillsController = TextEditingController();
  final locationController = TextEditingController();
  final tagsController = TextEditingController();

  // Observable lists and variables
  var jobTypes = ['Full-time', 'Part-time', 'Internship'].obs;
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

  var experienceLevels = ['Fresher', '1-2 years', '2-5 years', '5+ years'].obs;
  var selectedExperienceLevel = '2-5 years'.obs;

  var applicationDeadline = Rxn<DateTime>();
  var selectedPage = 1.obs;
  var toggleView = false.obs;
  RxList<MCQ> mcqList = <MCQ>[].obs;
  RxInt passMark = 0.obs;
  RxBool isLoading = false.obs;

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    skillsController.dispose();
    locationController.dispose();
    tagsController.dispose();
    super.onClose();
  }

  bool isProfileComplete(BuildContext context) {
    final profileController = Get.find<RecruiterProfileController>();

    if (profileController.profileData.value!.isEmpty()) {
      showCustomDialog(
        context: context,
        title: 'Error',
        content: "Please complete your profile first before posting a job",
        buttonText: 'Okay',
        buttonColor: Colors.red,
      );
      return false;
    } else {
      return true;
    }
  }

  bool validateAllFields(BuildContext context) {
    final fields = {
      'Title': titleController.text,
      'Description': descriptionController.text,
      'Skills': skillsController.text,
      'Location': locationController.text,
    };

    for (var entry in fields.entries) {
      if (entry.value.isEmpty) {
        showCustomDialog(
          context: context,
          title: 'Error',
          content: "${entry.key} cannot be empty",
          buttonText: 'Okay',
          onButtonPressed: Navigator.of(context).pop,
          buttonColor: Colors.red,
        );
        return false;
      }
    }

    if (applicationDeadline.value == null) {
      showCustomDialog(
        context: context,
        title: 'Error',
        content: "Please select a deadline for the application",
        buttonText: 'Okay',
        onButtonPressed: Navigator.of(context).pop,
        buttonColor: Colors.red,
      );
      return false;
    }
    return true;
  }

  void viewAsCandidate(BuildContext context) {
    try {
      if (!validateAllFields(context)) {
        return;
      }
      toggleView.value = !toggleView.value;
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

  void addMCQ() {
    mcqList.add(MCQ());
    updatePassMark();
  }

  void removeMCQ(int index) {
    mcqList[index].dispose();
    mcqList.removeAt(index);
    updatePassMark();
  }

  void clearAllMCQ() {
    for (var mcq in mcqList) {
      mcq.dispose();
    }
    mcqList.clear();
    passMark.value = 0;
  }

  void updatePassMark() {
    if (passMark.value > mcqList.length) {
      passMark.value = mcqList.length;
    }
  }

  bool validateMCQFields(BuildContext context) {
    for (var mcq in mcqList) {
      if (mcq.questionController.text.isEmpty ||
          mcq.optionControllers.any((controller) => controller.text.isEmpty)) {
        showCustomDialog(
          context: context,
          title: 'Error',
          content: "All fields in MCQs must be filled",
          buttonText: 'Okay',
          onButtonPressed: Navigator.of(context).pop,
          buttonColor: Colors.red,
        );
        return false;
      }
    }
    return true;
  }

  void startLoading() {
    isLoading.value = true;
  }

  void stopLoading() {
    isLoading.value = false;
  }

  void postJob(BuildContext context) async {
    if (!validateAllFields(context) || !validateMCQFields(context)) return;

    // Show loading dialog
    startLoading();

    try {
      final job = JobModel(
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
        skills: skillsController.text.trim().split(','),
        jobType: selectedJobType.value,
        location: locationController.text.trim(),
        salaryRange: selectedSalaryRange.value,
        experienceLevel: selectedExperienceLevel.value,
        tags: tagsController.text.trim().split(','),
        deadline: applicationDeadline.value.toString(),
        createdAt: Timestamp.now(),
      );

      List<MCQModel> mcqs = mcqList
          .map((mcq) => MCQModel(
                jobId: "",
                question: mcq.questionController.text.trim(),
                options:
                    mcq.optionControllers.map((c) => c.text.trim()).toList(),
                correctOption: mcq.correctOption.value,
                passMark: passMark.value,
              ))
          .toList();

      String? jobId = await AddJobService().uploadJob(job, mcqs);

      if (jobId == null) {
        // ✅ Ensure the loading dialog is dismissed
        stopLoading();

        showCustomDialog(
          context: context,
          title: 'Error',
          content: "Failed to upload job",
          buttonText: 'Okay',
          onButtonPressed: () {
            if (context.mounted) Navigator.of(context).pop();
          },
          buttonColor: Colors.red,
        );
        return;
      }

      // Ensure Firestore writes complete before continuing
      await Future.delayed(Duration(milliseconds: 300));

      // ✅ Force-close the loading dialog
      stopLoading();

      // ✅ Clear fields after successful upload
      titleController.clear();
      descriptionController.clear();
      skillsController.clear();
      locationController.clear();
      tagsController.clear();
      applicationDeadline.value = null;
      selectedJobType.value = 'Full-time';
      selectedSalaryRange.value = '30k-40k';
      selectedExperienceLevel.value = '2-5 years';
      clearAllMCQ();
      selectedPage.value = 1;
      toggleView.value = false;

      // ✅ Now show the success message safely
      Future.delayed(Duration(milliseconds: 200), () {
        if (context.mounted) {
          showCustomDialog(
            context: context,
            title: 'Success',
            content: "Job posted successfully",
            buttonText: 'Okay',
            buttonColor: Colors.green,
          );
        }
      });
    } catch (error) {
      // ✅ Ensure loading dialog is dismissed in case of an error
      stopLoading();

      showCustomDialog(
        context: context,
        title: 'Error',
        content: "Something went wrong",
        buttonText: 'Okay',
        onButtonPressed: () {
          if (context.mounted) Navigator.of(context).pop();
        },
        buttonColor: Colors.red,
      );
    }
  }
}

class MCQ {
  TextEditingController questionController = TextEditingController();
  List<TextEditingController> optionControllers =
      List.generate(4, (_) => TextEditingController());
  RxInt correctOption = 0.obs;

  void dispose() {
    questionController.dispose();
    for (var controller in optionControllers) {
      controller.dispose();
    }
  }
}
