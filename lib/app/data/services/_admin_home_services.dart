import 'package:cloud_firestore/cloud_firestore.dart';

class AdminHomeServices {
  final accountCollection =
      FirebaseFirestore.instance.collection('db_userAccounts');
  final jobCategoryCollection =
      FirebaseFirestore.instance.collection('jobCategories');
  final jobCollection = FirebaseFirestore.instance.collection('db_jobs');
  final coursesCollection = FirebaseFirestore.instance.collection('db_courses');

  /// Returns a stream of the total number of recruiters in the system
  Stream<int?> getTotalRecruitersCount() {
    final query =
        accountCollection.where('role', isEqualTo: 'Recruiter').snapshots();

    return query.map((snapshot) => snapshot.docs.length);
  }

  /// Returns a stream of the total number of applicants in the system
  Stream<int?> getTotalApplicantCount() {
    final query =
        accountCollection.where('role', isEqualTo: 'Applicant').snapshots();

    return query.map((snapshot) => snapshot.docs.length);
  }

  /// Returns a stream of the total number of job categories in the system
  Stream<int?> getTotalJobsCategoryCount() {
    final query = jobCategoryCollection.snapshots();

    return query.map((snapshot) => snapshot.docs.length);
  }

  /// Returns a stream of the total number of jobs posted in the system
  Stream<int?> getTotalJobsCount() {
    final query = jobCollection.snapshots();

    return query.map((snapshot) => snapshot.docs.length);
  }

  /// Returns a stream of the total number of courses available in the system
  Stream<int?> getTotalCoursesCount() {
    final query = coursesCollection.snapshots();

    return query.map((snapshot) => snapshot.docs.length);
  }

  // Get total jobs count for a specific category
  Future<int?> getJobsCountByCategory(String categoryId) async {
    try {
      final response = await jobCollection
          .where('categoryId', isEqualTo: categoryId)
          .count()
          .get();
      return response.count;
    } catch (error) {
      return null;
    }
  }
}
