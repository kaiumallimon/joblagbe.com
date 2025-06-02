import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:joblagbe/app/core/widgets/_custom_loading.dart';
import 'package:joblagbe/app/data/models/_application_model.dart';
import 'package:joblagbe/app/data/models/_job_model.dart';
import 'package:joblagbe/app/data/models/_mcq_model.dart';
import 'package:joblagbe/app/data/models/_course_model.dart';
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

    // Check course completion status if needed
    if (chancesLeft.value == 1 &&
        applicationProgress.value?.assignedCourseId != null) {
      checkCourseCompletion();
    }
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

  var isTestCompleted = false.obs;

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

      final marks = correctAnswers * 10;
      final progress = applicationProgress.value;

      if (progress == null) {
        throw Exception('Application progress not found');
      }

      // Check if passed
      bool passed = marks >= getPassMark()!;

      // Update progress based on test result
      await applicantJobApplicationService.updateJobProgress(
        progress.id!,
        testPassed: passed,
        chancesLeft: chancesLeft.value - 1,
        status:
            passed ? ApplicationStatus.submitted : ApplicationStatus.inProgress,
        updatedAt: DateTime.now(),
        usedFirstChance: true,
        usedSecondChance: progress.usedSecondChance,
        testScore: marks,
      );

      // If not passed, fetch relevant courses first
      if (!passed) {
        await getRelevantCourses();
      }

      isTestCompleted.value = true;
      isSubmitting.value = false;

      if (passed) {
        customDialog(
          'Success',
          'Congratulations! You have passed the test. Your application has been submitted.',
        );
      } else {
        // Only show dialog after courses are loaded
        if (relevantCourses.isNotEmpty) {
          customDialog(
            'Test Results',
            'Unfortunately, you did not pass the test. We recommend completing these relevant courses to improve your chances:',
          );
        } else {
          customDialog(
            'Test Results',
            'Unfortunately, you did not pass the test. Please try again later.',
          );
        }
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

  RxInt get chancesLeft {
    final progress = applicationProgress.value;

    if (progress == null) {
      return 2.obs;
    }

    final usedFirst = progress.usedFirstChance ?? false;
    final usedSecond = progress.usedSecondChance ?? false;

    if (!usedFirst && !usedSecond) {
      return 2.obs;
    } else if (usedFirst && !usedSecond) {
      return 1.obs;
    } else {
      return 0.obs;
    }
  }

  // Add relevant courses list
  var relevantCourses = <Course>[].obs;
  var isLoadingCourses = false.obs;

  // Add getter to check if we should show the test
  bool get shouldShowTest {
    if (chancesLeft.value == 1 &&
        applicationProgress.value?.assignedCourseId == null) {
      return false;
    }
    return true;
  }

  // Add method to initialize courses if needed
  void initializeCoursesIfNeeded() {
    if (chancesLeft.value == 1 &&
        applicationProgress.value?.assignedCourseId == null &&
        relevantCourses.isEmpty &&
        !isLoadingCourses.value) {
      getRelevantCourses();
    }
  }

  // Add getter to check if all chances are used
  bool get areAllChancesUsed {
    final progress = applicationProgress.value;
    if (progress == null) return false;
    return (progress.usedFirstChance ?? false) &&
        (progress.usedSecondChance ?? false);
  }

  // Add getter to check if course is completed
  Future<bool> isCourseCompleted() async {
    final progress = applicationProgress.value;
    if (progress == null || progress.assignedCourseId == null) return false;

    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return false;

    try {
      final courseProgress =
          await applicantJobApplicationService.getCourseProgress(
        progress.assignedCourseId!,
        userId,
      );

      return courseProgress?.isCompleted ?? false;
    } catch (error) {
      debugPrint('Error checking course progress: $error');
      return false;
    }
  }

  // Add observable for course completion status
  var courseCompletionStatus = false.obs;

  // Check course completion status
  Future<void> checkCourseCompletion() async {
    courseCompletionStatus.value = await isCourseCompleted();
  }

  // Fetch relevant courses
  Future<void> getRelevantCourses() async {
    debugPrint('Starting to fetch relevant courses...');
    try {
      isLoadingCourses.value = true;
      relevantCourses.clear(); // Clear existing courses before loading

      final courses = await applicantJobApplicationService.getRelevantCourses(
          currentJob.category ?? "", currentJob.tags);

      debugPrint('Courses fetched: ${courses?.length ?? 0}');

      if (courses != null && courses.isNotEmpty) {
        relevantCourses.value = courses;
        debugPrint('Courses set to state: ${relevantCourses.length}');
      } else {
        relevantCourses.clear();
        debugPrint('No courses found, clearing state');
      }
    } catch (error) {
      debugPrint('Error fetching relevant courses: $error');
      relevantCourses.clear();
    } finally {
      debugPrint('Setting isLoadingCourses to false');
      isLoadingCourses.value = false;
    }
  }

  // Enroll in a course
  Future<void> enrollInCourse(String courseId) async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        throw Exception('User not logged in');
      }

      await applicantJobApplicationService.enrollInCourse(courseId, userId);

      // Refresh application progress to get updated assigned course
      await addApplicationProgress();

      customDialog(
        'Success',
        'Successfully enrolled in the course! You can now access it from your dashboard.',
      );
    } catch (error) {
      customDialog('Error', error.toString());
    }
  }
}
