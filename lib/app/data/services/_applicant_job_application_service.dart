import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:joblagbe/app/data/models/_application_model.dart';
import 'package:joblagbe/app/data/models/_mcq_model.dart';
import 'package:joblagbe/app/data/models/_course_model.dart';
import 'package:joblagbe/app/data/services/_admin_course_service.dart';
import 'package:joblagbe/app/data/models/_course_progress_model.dart';
import 'package:joblagbe/app/data/services/_applicant_course_service.dart'; // Assuming you will create this model

class ApplicantJobApplicationService {
  final jobMCQCollection = FirebaseFirestore.instance.collection('db_mcqs');
  final jobApplicationsCollection =
      FirebaseFirestore.instance.collection('db_job_applications');

  final jobProgressCollection =
      FirebaseFirestore.instance.collection('db_job_progress');

  final AdminCourseService _adminCourseService = AdminCourseService();

  // ✅ get MCQs for a job
  Future<List<MCQModel>> getMCQs(String jobId) async {
    try {
      final snapshot =
          await jobMCQCollection.where('jobId', isEqualTo: jobId).get();
      return snapshot.docs
          .map((doc) => MCQModel.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw Exception(e);
    }
  }

  // ✅ Submit job application with test results
  Future<void> submitApplication({
    required String jobId,
    required List<int> testAnswers,
    required int score,
    required int totalQuestions,
    required bool passed,
  }) async {
    try {
      await jobApplicationsCollection.add({
        'jobId': jobId,
        'testAnswers': testAnswers,
        'score': score,
        'totalQuestions': totalQuestions,
        'passed': passed,
        'submittedAt': FieldValue.serverTimestamp(),
        'status': passed ? 'pending' : 'rejected',
      });
    } catch (e) {
      throw Exception('Failed to submit application: $e');
    }
  }

  // ✅ Add dummy MCQs for testing
  Future<void> addDummyMCQs(String jobId) async {
    try {
      final List<MCQModel> dummyMCQs = [
        MCQModel(
          jobId: jobId,
          question: "What is the primary purpose of version control systems?",
          options: [
            "To track changes in code",
            "To store passwords",
            "To manage hardware resources",
            "To create backups"
          ],
          correctOption: 0,
          passMark: 70,
        ),
        MCQModel(
          jobId: jobId,
          question: "Which of the following is NOT a programming paradigm?",
          options: [
            "Object-Oriented Programming",
            "Functional Programming",
            "Procedural Programming",
            "Binary Programming"
          ],
          correctOption: 3,
          passMark: 70,
        ),
        MCQModel(
          jobId: jobId,
          question: "What does API stand for?",
          options: [
            "Application Programming Interface",
            "Advanced Programming Interface",
            "Application Program Integration",
            "Advanced Program Integration"
          ],
          correctOption: 0,
          passMark: 70,
        ),
        MCQModel(
          jobId: jobId,
          question: "Which data structure follows LIFO principle?",
          options: ["Queue", "Stack", "Tree", "Graph"],
          correctOption: 1,
          passMark: 70,
        ),
        MCQModel(
          jobId: jobId,
          question: "What is the time complexity of binary search?",
          options: ["O(n)", "O(log n)", "O(n log n)", "O(n²)"],
          correctOption: 1,
          passMark: 70,
        ),
        MCQModel(
          jobId: jobId,
          question: "Which of these is NOT a valid HTTP method?",
          options: ["GET", "POST", "FETCH", "DELETE"],
          correctOption: 2,
          passMark: 70,
        ),
        MCQModel(
          jobId: jobId,
          question: "What is the main purpose of a database index?",
          options: [
            "To store data",
            "To improve query performance",
            "To backup data",
            "To encrypt data"
          ],
          correctOption: 1,
          passMark: 70,
        ),
        MCQModel(
          jobId: jobId,
          question: "Which of these is a NoSQL database?",
          options: ["MySQL", "PostgreSQL", "MongoDB", "Oracle"],
          correctOption: 2,
          passMark: 70,
        ),
        MCQModel(
          jobId: jobId,
          question: "What is the purpose of a firewall?",
          options: [
            "To store data",
            "To process data",
            "To protect networks",
            "To connect networks"
          ],
          correctOption: 2,
          passMark: 70,
        ),
        MCQModel(
          jobId: jobId,
          question: "Which protocol is used for secure web browsing?",
          options: ["HTTP", "FTP", "HTTPS", "SMTP"],
          correctOption: 2,
          passMark: 70,
        ),
      ];

      // Create a batch
      final batch = FirebaseFirestore.instance.batch();

      // Add all MCQs to the batch
      for (var mcq in dummyMCQs) {
        final docRef =
            jobMCQCollection.doc(); // Create a new document reference
        batch.set(docRef, mcq.toMap());
      }

      // Commit the batch
      await batch.commit();
    } catch (e) {
      throw Exception('Failed to add dummy MCQs: $e');
    }
  }

  Future<ApplicationProgressModel?> addJobProgress(
      ApplicationProgressModel progress) async {
    try {
      // Check if already exists with jobId and applicantId
      final existingProgress = await jobProgressCollection
          .where('jobId', isEqualTo: progress.jobId)
          .where('applicantId', isEqualTo: progress.applicantId)
          .get();

      if (existingProgress.docs.isNotEmpty) {
        debugPrint('Existing progress found');
        // Return existing progress
        return ApplicationProgressModel.fromJson(
          existingProgress.docs.first.data(),
          existingProgress.docs.first.id,
        );
      }

      // If it doesn't exist, add new progress
      final response = await jobProgressCollection.add(progress.toJson());

      // Get the newly created document snapshot
      final snapshot = await response.get();

      debugPrint("Application progress added successfully!");
      debugPrint('${snapshot.data()}');

      return ApplicationProgressModel.fromJson(
        snapshot.data() as Map<String, dynamic>,
        snapshot.id,
      );
    } catch (e) {
      throw Exception('Failed to add job progress: $e');
    }
  }

  // check if a job application progress exists for a user
  Future<bool> doesJobProgressExist(String jobId, String applicantId) async {
    try {
      final snapshot = await jobProgressCollection
          .where('jobId', isEqualTo: jobId)
          .where('applicantId', isEqualTo: applicantId)
          .get();
      return snapshot.docs.isNotEmpty;
    } catch (e) {
      throw Exception('Failed to check job progress existence: $e');
    }
  }

  // ✅ Update job application progress
  Future<void> updateJobProgress(
    String progressId, {
    required bool testPassed,
    required int chancesLeft,
    required ApplicationStatus status,
    required DateTime updatedAt,
    required bool? usedFirstChance,
    required bool? usedSecondChance,
    required int testScore,
  }) async {
    try {
      await jobProgressCollection.doc(progressId).update({
        'testPassed': testPassed,
        'chancesLeft': chancesLeft,
        'status': status.toString().split('.').last,
        'updatedAt': updatedAt.toIso8601String(),
        'usedFirstChance': usedFirstChance,
        'usedSecondChance': usedSecondChance,
        'testScore': testScore,
      });
      debugPrint("Application progress updated successfully!");
    } catch (e) {
      throw Exception('Failed to update job progress: $e');
    }
  }

  // ✅ Get relevant courses based on job category and tags
  Future<List<Course>> getRelevantCourses(
      String? jobCategory, List<String> jobTags) async {
    try {
      final allCourses = await _adminCourseService.getAllCourses();
      if (allCourses == null) return [];

      return allCourses.where((course) {
        // final categoryMatch =
        //     jobCategory != null && course.category == jobCategory;
        final tagMatch =
            course.tags.any((courseTag) => jobTags.contains(courseTag));
        return tagMatch;
      }).toList();
    } catch (e) {
      throw Exception('Failed to get relevant courses: $e');
    }
  }

  // ✅ Get all courses
  Future<List<Course>?> getAllCourses() async {
    try {
      final allCourses = await _adminCourseService.getAllCourses();
      return allCourses;
    } catch (e) {
      throw Exception('Failed to get all courses: $e');
    }
  }

  // ✅ Add course progress for a user
  Future<void> addCourseProgress(CourseProgressModel progress) async {
    try {
      await FirebaseFirestore.instance
          .collection('db_course_progress')
          .add(progress.toJson());
      debugPrint("Course progress added successfully!");
    } catch (e) {
      throw Exception('Failed to add course progress: $e');
    }
  }

  // ✅ Check course progress
  Future<CourseProgressModel?> getCourseProgress(
      String courseId, String userId) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('db_course_progress')
          .where('courseId', isEqualTo: courseId)
          .where('userId', isEqualTo: userId)
          .get();

      if (snapshot.docs.isEmpty) {
        return null;
      }

      return CourseProgressModel.fromJson(
        snapshot.docs.first.data(),
        snapshot.docs.first.id,
      );
    } catch (e) {
      throw Exception('Failed to get course progress: $e');
    }
  }

  // ✅ Enroll in a course
  Future<void> enrollInCourse(String courseId, String userId) async {
    try {
      // create lesson progress map with lesson id as key:
      final lessons =
          await ApplicantCourseService().getAllLessonsForCourse(courseId);
      final lessonProgress = <String, dynamic>{};
      if (lessons != null) {
        for (final lesson in lessons) {
          lessonProgress[lesson.id!] = {
            'completed': false,
            'completedAt': null,
          };
        }
      }
      // Create initial course progress
      final progress = CourseProgressModel(
        courseId: courseId,
        userId: userId,
        startedAt: DateTime.now(),
        progressPercentage: 0.0,
        isCompleted: false,
        lessonProgress: lessonProgress,
      );

      // Add to course progress collection
      await FirebaseFirestore.instance
          .collection('db_course_progress')
          .add(progress.toJson());

      // Update job application progress with assigned course
      final jobProgress = await jobProgressCollection
          .where('applicantId', isEqualTo: userId)
          .where('assignedCourseId', isNull: true)
          .get();

      if (jobProgress.docs.isNotEmpty) {
        await jobProgressCollection.doc(jobProgress.docs.first.id).update({
          'assignedCourseId': courseId,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }

      debugPrint("Successfully enrolled in course!");
    } catch (e) {
      throw Exception('Failed to enroll in course: $e');
    }
  }
}
