import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:joblagbe/app/data/models/_applicant_profile_model.dart';
import 'package:joblagbe/app/data/models/_course_model.dart';
import 'package:joblagbe/app/data/models/_job_model.dart';

class ApplicantHomeService {
  final profileCollection =
      FirebaseFirestore.instance.collection('db_applicantProfile');

  final jobsCollection = FirebaseFirestore.instance.collection('db_jobs');

  final coursesCollection = FirebaseFirestore.instance.collection('db_courses');

  /// Fetches the applicant profile for the given userId.
  /// Throws an exception if the profile is not found.
  Future<ApplicantProfileModel> getApplicantProfile(String userId) async {
    try {
      final snapshot = await profileCollection
          .where('userId', isEqualTo: userId)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) {
        throw Exception('Profile not found for userId: $userId');
      }

      final doc = snapshot.docs.first;
      return ApplicantProfileModel.fromJson(doc.data(), doc.id);
    } catch (error) {
      rethrow;
    }
  }

  /// Fetches the most recently added 5 jobs.
  /// filters out jobs that passed their deadline.
  Future<List<JobModel>> getRecentlyAddedJobs() async {
    try {
      final snapshot = await jobsCollection
          .where('deadline', isGreaterThan: Timestamp.now())
          .orderBy('createdAt', descending: true)
          .limit(4)
          .get();

      return snapshot.docs.map((doc) {
        return JobModel.fromMap(doc.data(), doc.id);
      }).toList();
    } catch (error) {
      rethrow;
    }
  }

  /// Fetches all available courses, ordered by creation date.
  Future<List<Course>> fetchAvailableCourses() async {
    try {
      final snapshot =
          await coursesCollection.orderBy('createdAt', descending: true).get();

      return snapshot.docs.map((doc) {
        return Course.fromJson(json: doc.data(), id: doc.id);
      }).toList();
    } catch (error) {
      rethrow;
    }
  }
}
