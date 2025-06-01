import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:joblagbe/app/core/widgets/_custom_loading.dart';
import 'package:joblagbe/app/data/models/_job_model.dart';
import 'package:joblagbe/app/data/models/_mcq_model.dart';
import 'package:joblagbe/app/data/services/_applicant_job_application_service.dart';

class ApplicantJobsApplicationController extends GetxController {
  final JobModel currentJob;
  ApplicantJobsApplicationController({required this.currentJob});

  var isLoading = false.obs;
  var mcqQuestions = <MCQModel>[].obs;
  var selectedAnswers = <int>[].obs;
  var isSubmitting = false.obs;

  final applicantJobApplicationService = ApplicantJobApplicationService();

  @override
  void onInit() {
    super.onInit();
    getMCQs(currentJob.id ?? "");

    // add dummy mcqs
    // applicantJobApplicationService.addDummyMCQs(currentJob.id ?? "");
  }

  Future<void> getMCQs(String jobId) async {
    try {
      isLoading.value = true;
      mcqQuestions.value = await applicantJobApplicationService.getMCQs(jobId);
      // Initialize selected answers with -1 (no selection)
      selectedAnswers.value = List.filled(mcqQuestions.length, -1);
      isLoading.value = false;
      debugPrint("MCQs loaded!");
    } catch (error) {
      isLoading.value = false;
      customDialog('Error', error.toString());
      return;
    }
  }

  void selectAnswer(int questionIndex, int optionIndex) {
    if (questionIndex >= 0 && questionIndex < selectedAnswers.length) {
      selectedAnswers[questionIndex] = optionIndex;
      selectedAnswers.refresh(); // Notify listeners of the change
    }
  }

  Future<void> submitTest() async {
    // Check if all questions are answered
    if (selectedAnswers.contains(-1)) {
      customDialog('Error', 'Please answer all questions before submitting.');
      return;
    }

    try {
      isSubmitting.value = true;

      // Calculate score
      int correctAnswers = 0;
      for (int i = 0; i < mcqQuestions.length; i++) {
        if (selectedAnswers[i] == mcqQuestions[i].correctOption) {
          correctAnswers++;
        }
      }

      // Check if passed
      bool passed =
          (correctAnswers / mcqQuestions.length * 100) >= (getPassMark() ?? 0);

      // Submit application with test results
      // await applicantJobApplicationService.submitApplication(
      //   jobId: currentJob.id ?? "",
      //   testAnswers: selectedAnswers,
      //   score: correctAnswers,
      //   totalQuestions: mcqQuestions.length,
      //   passed: passed,
      // );

      isSubmitting.value = false;

      if (passed) {
        customDialog(
          'Success',
          'Congratulations! You have passed the test. Your application has been submitted.',
        );
      } else {
        customDialog(
          'Test Results',
          'Unfortunately, you did not pass the test. Please try again later.',
        );
      }
    } catch (error) {
      isSubmitting.value = false;
      customDialog('Error', error.toString());
    }
  }

  int? getPassMark() {
    if (mcqQuestions.isEmpty) {
      return null;
    }
    return mcqQuestions[0].passMark;
  }
}
