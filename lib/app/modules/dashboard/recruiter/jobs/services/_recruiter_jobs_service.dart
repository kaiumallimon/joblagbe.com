import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:joblagbe/app/modules/dashboard/recruiter/add-job/models/_job_model.dart';

class RecruiterJobsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference _jobsCollection =
      FirebaseFirestore.instance.collection('db_jobs');

  Future<JobFetchingResponse> fetchJobs({
    required int limit,
    DocumentSnapshot? lastDoc,
    required String postedBy,
  }) async {
    try {
      final now = Timestamp.now();

      // Fetch total job count asynchronously in a separate query
      int totalJobs = await _jobsCollection
          .where('deadline', isGreaterThan: now)
          .where('creatorId', isEqualTo: postedBy)
          .get()
          .then((snapshot) => snapshot.size);

      // Build the main job query
      Query query = _jobsCollection
          .where('deadline', isGreaterThan: now)
          .where('creatorId', isEqualTo: postedBy)
          .orderBy('createdAt', descending: true)
          .limit(limit);

      if (lastDoc != null) {
        query = query.startAfterDocument(lastDoc);
      }

      QuerySnapshot snapshot = await query.get();

      List<JobModel> jobs = snapshot.docs.map((doc) {
        return JobModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();

      return JobFetchingResponse(
        isSuccess: true,
        jobs: jobs,
        totalJobs: totalJobs,
        lastDocument: snapshot.docs.isNotEmpty ? snapshot.docs.last : null,
      );
    } catch (e) {
      print("Error fetching jobs: $e");
      return JobFetchingResponse(
        isSuccess: false,
        message: "Failed to fetch jobs: ${e.toString()}",
        totalJobs: 0,
      );
    }
  }
}

class JobFetchingResponse {
  final String? message;
  final bool isSuccess;
  final List<JobModel>? jobs;
  final int totalJobs;
  final DocumentSnapshot? lastDocument;

  JobFetchingResponse({
    this.message,
    required this.isSuccess,
    this.jobs,
    required this.totalJobs,
    this.lastDocument,
  });

  factory JobFetchingResponse.fromJson(Map<String, dynamic> json) {
    return JobFetchingResponse(
      message: json['message'],
      isSuccess: json['isSuccess'],
      jobs: (json['jobs'] as List<dynamic>?)
          ?.map((job) => JobModel.fromMap(job, job['jobId']))
          .toList(),
      totalJobs: json['totalJobs'] ?? 0,
      lastDocument: null, // Firestore snapshots cannot be serialized
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'isSuccess': isSuccess,
      'jobs': jobs?.map((job) => job.toMap()).toList(),
      'totalJobs': totalJobs,
    };
  }
}
