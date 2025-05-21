import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:joblagbe/app/data/models/_mcq_model.dart';
import '../models/_job_model.dart';

class AddJobService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Upload a new job post with MCQs
  Future<String?> uploadJob(JobModel job, List<MCQModel> mcqs) async {
    try {
      // Add Job to Firestore
      DocumentReference jobRef =
          await _firestore.collection("db_jobs").add(job.toMap());
      String jobId = jobRef.id;

      // Add MCQs individually
      for (var mcq in mcqs) {
        await _firestore
            .collection("db_mcqs")
            .add(mcq.copyWith(jobId: jobId).toMap());
      }

      return jobId;
    } catch (e) {
      print("Error uploading job: $e");
      return null;
    }
  }

  /// Fetch all jobs
  Future<List<JobModel>> getAllJobs() async {
    try {
      QuerySnapshot jobsSnapshot = await _firestore.collection("db_jobs").get();
      return jobsSnapshot.docs
          .map((doc) =>
              JobModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      print("Error fetching jobs: $e");
      return [];
    }
  }

  /// Fetch MCQs for a given job
  Future<List<MCQModel>> getMcqsForJob(String jobId) async {
    try {
      QuerySnapshot mcqSnapshot = await _firestore
          .collection("db_mcqs")
          .where("jobId", isEqualTo: jobId)
          .get();
      return mcqSnapshot.docs
          .map((doc) =>
              MCQModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      print("Error fetching MCQs: $e");
      return [];
    }
  }
}
