import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:joblagbe/app/modules/landing/views/categories/model/_jobs_model.dart';

class RecruiterJobsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference _jobsCollection =
      FirebaseFirestore.instance.collection('db_jobs');

  Future<List<JobPost>> fetchJobs(int limit) async {
    try {
      QuerySnapshot snapshot = await _jobsCollection
          .where('deadline', isGreaterThan: Timestamp.now())
          .orderBy('createdAt', descending: true)
          .limit(limit)
          .get();

      print('snapshot: ${snapshot.docs}');

      List<JobPost> jobs = snapshot.docs.map((doc) {
        return JobPost.fromJson(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();

      print('jobs: ${jobs.length}');

      return jobs;
    } catch (e) {
      rethrow;
    }
  }
}
