import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:joblagbe/app/modules/landing/views/categories/model/_jobs_model.dart';

class JobService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<JobPost>> getJobsByCategory(String category) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('db_jobs')
          .where('category', isEqualTo: category)
          .get();

      List<JobPost> jobPosts = snapshot.docs.map((doc) {
        return JobPost.fromJson(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();

      return jobPosts;
    } catch (e) {
      print("Error fetching jobs: $e");
      rethrow;
    }
  }
}
