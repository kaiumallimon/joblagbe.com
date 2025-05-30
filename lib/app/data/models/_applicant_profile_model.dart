class ApplicantProfileModel {
  final String? id;
  final String userId;
  final String fullName;
  final String email;
  final DateTime? dob;
  final String? professionalTitle;
  final String? location;
  final String? phone;
  final String? profilePhotoUrl;
  final String? bio;
  final List<String>? skills;
  final String? resumeUrl;
  final String? gender;

  ApplicantProfileModel(
      {this.id,
      required this.userId,
      required this.fullName,
      required this.email,
      this.dob,
      this.professionalTitle,
      this.location,
      this.phone,
      this.profilePhotoUrl,
      this.bio,
      this.skills,
      this.resumeUrl,
      this.gender});

  factory ApplicantProfileModel.fromJson(Map<String, dynamic> json, String id) {
    return ApplicantProfileModel(
        id: id,
        userId: json['userId'],
        fullName: json['fullName'],
        email: json['email'],
        dob: json['dob'] != null ? DateTime.parse(json['dob']) : null,
        professionalTitle: json['professionalTitle'],
        location: json['location'],
        phone: json['phone'],
        profilePhotoUrl: json['profilePhotoUrl'],
        bio: json['bio'],
        skills:
            json['skills'] != null ? List<String>.from(json['skills']) : null,
        resumeUrl: json['resumeUrl'],
        gender: json['gender']);
  }

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'fullName': fullName,
        'email': email,
        'dob': dob?.toIso8601String(),
        'professionalTitle': professionalTitle,
        'location': location,
        'phone': phone,
        'profilePhotoUrl': profilePhotoUrl,
        'bio': bio,
        'skills': skills,
        'resumeUrl': resumeUrl,
        'gender': gender
      };

  // basic
  ApplicantProfileModel.basic({
    required this.userId,
    required this.fullName,
    required this.email,
  })  : professionalTitle = null,
        id = null,
        location = null,
        phone = null,
        dob = null,
        profilePhotoUrl = null,
        bio = null,
        skills = null,
        gender = null,
        resumeUrl = null;

  ApplicantProfileModel copyWith(
      {String? id,
      String? userId,
      String? fullName,
      String? email,
      DateTime? dob,
      String? professionalTitle,
      String? location,
      String? phone,
      String? profilePhotoUrl,
      String? bio,
      List<String>? skills,
      String? resumeUrl,
      String? gender}) {
    return ApplicantProfileModel(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        fullName: fullName ?? this.fullName,
        email: email ?? this.email,
        dob: dob ?? this.dob,
        professionalTitle: professionalTitle ?? this.professionalTitle,
        location: location ?? this.location,
        phone: phone ?? this.phone,
        profilePhotoUrl: profilePhotoUrl ?? this.profilePhotoUrl,
        bio: bio ?? this.bio,
        skills: skills ?? this.skills,
        resumeUrl: resumeUrl ?? this.resumeUrl,
        gender: gender ?? this.gender);
  }
}
