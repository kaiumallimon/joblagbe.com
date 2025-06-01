import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:joblagbe/app/data/models/_mcq_model.dart';

class ApplicantJobApplicationService {
  final jobMCQCollection = FirebaseFirestore.instance.collection('db_mcqs');
  final jobApplicationsCollection =
      FirebaseFirestore.instance.collection('db_job_applications');

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
}
