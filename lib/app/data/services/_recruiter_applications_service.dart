import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:joblagbe/app/data/models/_applicant_profile_model.dart';
import 'package:joblagbe/app/data/models/_application_model.dart';
import 'package:joblagbe/app/data/models/_job_model.dart';

class RecruiterApplicationService {
  final jobApplicationCollection =
      FirebaseFirestore.instance.collection('db_job_progress');

  final jobCollection = FirebaseFirestore.instance.collection('db_jobs');

  final applicantProfileCollection =
      FirebaseFirestore.instance.collection('db_applicantProfile');

  Future<List<ApplicationProgressModel>> getApplications() async {
    try {
      final submittedApplications = await jobApplicationCollection
          .where('status', isEqualTo: 'submitted')
          .get();

      return submittedApplications.docs.map((doc) {
        return ApplicationProgressModel.fromJson(doc.data(), doc.id);
      }).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<JobModel> getJobById(String jobId) async {
    try {
      final jobDoc = await jobCollection.doc(jobId).get();
      if (jobDoc.exists) {
        return JobModel.fromMap(jobDoc.data()!, jobDoc.id);
      } else {
        throw Exception('Job not found');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<ApplicantProfileModel> getApplicantProfileModel(
      String applicantId) async {
    try {
      final applicantDoc = await applicantProfileCollection
          .where('userId', isEqualTo: applicantId)
          .get();
      if (applicantDoc.docs.isNotEmpty) {
        return ApplicantProfileModel.fromJson(
            applicantDoc.docs.first.data(), applicantDoc.docs.first.id);
      } else {
        throw Exception('Applicant profile not found');
      }
    } catch (e) {
      rethrow;
    }
  }
}
