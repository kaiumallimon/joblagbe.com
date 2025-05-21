import 'package:cloud_firestore/cloud_firestore.dart';

class RecruiterProfileModel {
  final String profileId;
  final String userId;
  final String name;
  final String email;
  final String? phoneNumber;
  final String? companyName;
  final String? designation;
  final String? companyLogoUrl;
  final Timestamp? dob;
  final String? gender;
  final String? profilePictureUrl;
  final String? jobDescription;

  RecruiterProfileModel({
    required this.profileId,
    required this.userId,
    required this.name,
    required this.email,
    this.phoneNumber,
    this.companyName,
    this.designation,
    this.companyLogoUrl,
    this.dob,
    this.gender,
    this.profilePictureUrl,
    this.jobDescription,
  });

  /// Factory constructor to create a model from a Firestore document (Map).
  factory RecruiterProfileModel.fromMap(
      Map<String, dynamic> map, String docId) {
    return RecruiterProfileModel(
      profileId: docId,
      userId: map['userId'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phoneNumber: map['phone'],
      companyName: map['companyName'],
      designation: map['designation'],
      companyLogoUrl: map['companyLogo'],
      dob: map['dob'], // Firestore Timestamp
      gender: map['gender'],
      profilePictureUrl: map['profilePicture'],
      jobDescription: map['jobDescription'],
    );
  }

  /// Converts the model into a Map for Firestore.
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'name': name,
      'email': email,
      'phone': phoneNumber,
      'companyName': companyName,
      'designation': designation,
      'companyLogo': companyLogoUrl,
      'dob': dob, // Firestore Timestamp
      'gender': gender,
      'profilePicture': profilePictureUrl,
      'jobDescription': jobDescription,
    };
  }

  /// Creates a copy of the model with modified fields.
  RecruiterProfileModel copyWith({
    String? profileId,
    String? userId,
    String? name,
    String? email,
    String? phoneNumber,
    String? companyName,
    String? designation,
    String? companyLogoUrl,
    Timestamp? dob,
    String? gender,
    String? profilePictureUrl,
    String? jobDescription,
  }) {
    return RecruiterProfileModel(
      profileId: profileId ?? this.profileId,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      companyName: companyName ?? this.companyName,
      designation: designation ?? this.designation,
      companyLogoUrl: companyLogoUrl ?? this.companyLogoUrl,
      dob: dob ?? this.dob,
      gender: gender ?? this.gender,
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
      jobDescription: jobDescription ?? this.jobDescription,
    );
  }

  /// check if any field remains null/empty:
  bool isEmpty() {
    return profileId.isEmpty ||
        userId.isEmpty ||
        name.isEmpty ||
        email.isEmpty ||
        (phoneNumber == null &&
            companyName == null &&
            designation == null &&
            companyLogoUrl == null &&
            dob == null &&
            gender == null &&
            profilePictureUrl == null &&
            jobDescription == null);
  }

  RecruiterProfileModel.basic({
    required this.userId,
    required this.name,
    required this.email,
  })  : profileId = '',
        phoneNumber = null,
        companyName = null,
        designation = null,
        companyLogoUrl = null,
        dob = null,
        gender = null,
        profilePictureUrl = null,
        jobDescription = null;
}
