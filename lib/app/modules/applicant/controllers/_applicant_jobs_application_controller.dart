import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:joblagbe/app/core/widgets/_custom_loading.dart';
import 'package:joblagbe/app/data/models/_application_model.dart';
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
    getMCQs(currentJob.id ?? "").then((_) {
      addApplicationProgress();
    });

    // add dummy mcqs
    // applicantJobApplicationService.addDummyMCQs(currentJob.id ?? "");

    // Add application progress to the database
  }

  /*
  * Fetch MCQs for the current job.
  * Updates the mcqQuestions list with the fetched questions.
  * args:
  *   jobId: The ID of the job for which to fetch MCQs.
  * returns: Future<void>
  */

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

  /*
  * Select an answer for a given question.
  * Updates the selectedAnswers list with the index of the selected option.
  * args:
  *   questionIndex: The index of the question in the mcqQuestions list.
  *   optionIndex: The index of the selected option for the question.
  * returns: void
  */
  void selectAnswer(int questionIndex, int optionIndex) {
    if (questionIndex >= 0 && questionIndex < selectedAnswers.length) {
      selectedAnswers[questionIndex] = optionIndex;
      selectedAnswers.refresh(); // Notify listeners of the change
    }
  }

  /*
  * Submit the test answers and calculate the score.
  * If all questions are answered, calculate the score and determine if the applicant passed.
  * If passed, submit the application with the test results.
  * If not passed, show a message indicating the failure.
  * args:
  *   None
  * returns: Future<void>
  */

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

  /*
  * Get the pass mark from the first MCQ question.
  * If there are no MCQ questions, return null.
  * args:
  *   None
  * returns: int?
  */
  int? getPassMark() {
    if (mcqQuestions.isEmpty) {
      return null;
    }
    return mcqQuestions[0].passMark;
  }

  /*
  * Add application progress to the database.
  * Creates an ApplicationProgressModel with the required details
  * and calls the service to add it.
  * args:
  *   None
  * returns: Future<void>
  */

  Rxn<ApplicationProgressModel> applicationProgress =
      Rxn<ApplicationProgressModel>();

  Future<void> addApplicationProgress() async {
    try {
      isLoading.value = true;
      final progress = ApplicationProgressModel(
        jobId: currentJob.id ?? "",
        status: ApplicationStatus.inProgress,
        passMarkForTest: getPassMark() ?? 0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        applicantId: FirebaseAuth.instance.currentUser?.uid,
      );

      final response = await applicantJobApplicationService.addJobProgress(
        progress,
      );

      isLoading.value = false;

      if (response != null) {
        applicationProgress.value = response;
      } else {
        customDialog('Error', 'Failed to add application progress.');
      }
    } catch (error) {
      customDialog('Error', error.toString());
      return;
    }
  }

  int getChancesLeft() {
    final progress = applicationProgress.value;

    if (progress == null) {
      return 2;
    }

    final usedFirst = progress.usedFirstChance ?? false;
    final usedSecond = progress.usedSecondChance ?? false;

    if (!usedFirst && !usedSecond) {
      return 2;
    } else if (usedFirst && !usedSecond) {
      return 1;
    } else {
      return 0;
    }
  }
}
