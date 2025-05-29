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
  final List<WorkExperience>? experiences;
  final List<Project>? portfolio;
  final List<Education>? education;
  final List<Certification>? certifications;
  final List<Testimonial>? testimonials;
  final String? resumeUrl;

  ApplicantProfileModel({
    this.id,
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
    this.experiences,
    this.portfolio,
    this.education,
    this.certifications,
    this.testimonials,
    this.resumeUrl,
  });

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
      skills: json['skills'] != null ? List<String>.from(json['skills']) : null,
      experiences: json['experiences'] != null
          ? (json['experiences'] as List)
              .map((e) => WorkExperience.fromJson(e))
              .toList()
          : null,
      portfolio: json['portfolio'] != null
          ? (json['portfolio'] as List).map((e) => Project.fromJson(e)).toList()
          : null,
      education: json['education'] != null
          ? (json['education'] as List)
              .map((e) => Education.fromJson(e))
              .toList()
          : null,
      certifications: json['certifications'] != null
          ? (json['certifications'] as List)
              .map((e) => Certification.fromJson(e))
              .toList()
          : null,
      testimonials: json['testimonials'] != null
          ? (json['testimonials'] as List)
              .map((e) => Testimonial.fromJson(e))
              .toList()
          : null,
      resumeUrl: json['resumeUrl'],
    );
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
        'experiences': experiences?.map((e) => e.toJson()).toList(),
        'portfolio': portfolio?.map((e) => e.toJson()).toList(),
        'education': education?.map((e) => e.toJson()).toList(),
        'certifications': certifications?.map((e) => e.toJson()).toList(),
        'testimonials': testimonials?.map((e) => e.toJson()).toList(),
        'resumeUrl': resumeUrl,
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
        experiences = null,
        portfolio = null,
        education = null,
        certifications = null,
        testimonials = null,
        resumeUrl = null;

  ApplicantProfileModel copyWith({
    String? id,
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
    List<WorkExperience>? experiences,
    List<Project>? portfolio,
    List<Education>? education,
    List<Certification>? certifications,
    List<Testimonial>? testimonials,
    String? resumeUrl,
  }) {
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
      experiences: experiences ?? this.experiences,
      portfolio: portfolio ?? this.portfolio,
      education: education ?? this.education,
      certifications: certifications ?? this.certifications,
      testimonials: testimonials ?? this.testimonials,
      resumeUrl: resumeUrl ?? this.resumeUrl,
    );
  }
}

class WorkExperience {
  final String title;
  final String company;
  final String startDate;
  final String endDate;
  final List<String> responsibilities;

  WorkExperience({
    required this.title,
    required this.company,
    required this.startDate,
    required this.endDate,
    required this.responsibilities,
  });

  factory WorkExperience.fromJson(Map<String, dynamic> json) {
    return WorkExperience(
      title: json['title'],
      company: json['company'],
      startDate: json['startDate'],
      endDate: json['endDate'],
      responsibilities: List<String>.from(json['responsibilities']),
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'company': company,
        'startDate': startDate,
        'endDate': endDate,
        'responsibilities': responsibilities,
      };
}

class Project {
  final String title;
  final String description;
  final String link;
  final List<String> technologies;

  Project({
    required this.title,
    required this.description,
    required this.link,
    required this.technologies,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      title: json['title'],
      description: json['description'],
      link: json['link'],
      technologies: List<String>.from(json['technologies']),
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        'link': link,
        'technologies': technologies,
      };
}

class Education {
  final String degree;
  final String school;
  final String startDate;
  final String endDate;

  Education({
    required this.degree,
    required this.school,
    required this.startDate,
    required this.endDate,
  });

  factory Education.fromJson(Map<String, dynamic> json) {
    return Education(
      degree: json['degree'],
      school: json['school'],
      startDate: json['startDate'],
      endDate: json['endDate'],
    );
  }

  Map<String, dynamic> toJson() => {
        'degree': degree,
        'school': school,
        'startDate': startDate,
        'endDate': endDate,
      };
}

class Certification {
  final String name;
  final String authority;
  final String dateIssued;

  Certification({
    required this.name,
    required this.authority,
    required this.dateIssued,
  });

  factory Certification.fromJson(Map<String, dynamic> json) {
    return Certification(
      name: json['name'],
      authority: json['authority'],
      dateIssued: json['dateIssued'],
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'authority': authority,
        'dateIssued': dateIssued,
      };
}

class Testimonial {
  final String author;
  final String content;
  final String role;

  Testimonial({
    required this.author,
    required this.content,
    required this.role,
  });

  factory Testimonial.fromJson(Map<String, dynamic> json) {
    return Testimonial(
      author: json['author'],
      content: json['content'],
      role: json['role'],
    );
  }

  Map<String, dynamic> toJson() => {
        'author': author,
        'content': content,
        'role': role,
      };
}
