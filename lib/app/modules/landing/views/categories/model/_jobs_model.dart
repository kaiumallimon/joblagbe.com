import 'package:cloud_firestore/cloud_firestore.dart';

class JobPost {
  String jobId;
  String title;
  String company;
  String? recruiterId;
  String description;
  List<String> requirements;
  String location;
  String salary;
  DateTime createdAt;
  DateTime deadline;
  String companyLogoUrl;

  JobPost({
    required this.jobId,
    required this.title,
    required this.company,
    this.recruiterId,
    required this.description,
    required this.requirements,
    required this.location,
    required this.salary,
    required this.createdAt,
    required this.deadline,
    required this.companyLogoUrl,
  });

  // Convert from JSON
  factory JobPost.fromJson(Map<String, dynamic> json, String id) {
    return JobPost(
      jobId: id,
      title: json['title'],
      company: json['company'],
      recruiterId: json['creatorId'],
      description: json['description'],
      requirements: List<String>.from(json['skills'] ?? []),
      location: json['location'],
      salary: json['salaryRange'],
      createdAt: (json['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      deadline: (json['deadline'] as Timestamp?)?.toDate() ?? DateTime.now(),
      companyLogoUrl: json['companyLogoUrl'] ?? '',
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'company': company,
      'creatorId': recruiterId,
      'description': description,
      'skills': requirements,
      'location': location,
      'salaryRange': salary,
      'createdAt': Timestamp.fromDate(createdAt),
      'deadline': Timestamp.fromDate(deadline),
      'companyLogoUrl': companyLogoUrl,
    };
  }
}
