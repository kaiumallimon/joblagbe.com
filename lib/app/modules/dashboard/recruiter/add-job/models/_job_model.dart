import 'package:cloud_firestore/cloud_firestore.dart';

class JobModel {
  String? id;
  String title;
  String description;
  List<String> skills;
  String jobType;
  String location;
  String salaryRange;
  String experienceLevel;
  List<String> tags;
  String deadline;
  Timestamp? createdAt;

  JobModel({
    this.id,
    required this.title,
    required this.description,
    required this.skills,
    required this.jobType,
    required this.location,
    required this.salaryRange,
    required this.experienceLevel,
    required this.tags,
    required this.deadline,
    this.createdAt,
  });

  // Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      "title": title,
      "description": description,
      "skills": skills,
      "jobType": jobType,
      "location": location,
      "salaryRange": salaryRange,
      "experienceLevel": experienceLevel,
      "tags": tags,
      "deadline": deadline,
      "createdAt": createdAt ?? FieldValue.serverTimestamp(),
    };
  }

  // Convert Firestore document to Job model
  factory JobModel.fromMap(Map<String, dynamic> map, String docId) {
    return JobModel(
      id: docId,
      title: map["title"] ?? "",
      description: map["description"] ?? "",
      skills: List<String>.from(map["skills"] ?? []),
      jobType: map["jobType"] ?? "",
      location: map["location"] ?? "",
      salaryRange: map["salaryRange"] ?? "",
      experienceLevel: map["experienceLevel"] ?? "",
      tags: List<String>.from(map["tags"] ?? []),
      deadline: map["deadline"] ?? "",
      createdAt: map["createdAt"],
    );
  }
}
