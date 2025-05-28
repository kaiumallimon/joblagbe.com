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
  DateTime deadline;
  Timestamp? createdAt;
  String creatorId;
  String company;
  String companyLogoUrl;
  String? category;

  JobModel(
      {this.id,
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
      this.category,
      required this.creatorId,
      required this.company,
      required this.companyLogoUrl});

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
      "deadline": Timestamp.fromDate(deadline),
      "createdAt": createdAt ?? FieldValue.serverTimestamp(),
      "creatorId": creatorId,
      "company": company,
      "companyLogoUrl": companyLogoUrl,
      "category": category,
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
        deadline: (map['deadline'] as Timestamp?)?.toDate() ?? DateTime.now(),
        createdAt: map["createdAt"],
        creatorId: map["creatorId"],
        company: map['company'],
        category: map['category'],
        companyLogoUrl: map['companyLogoUrl']);
  }
}
