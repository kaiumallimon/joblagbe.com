class JobPost {
  String jobId;
  String title;
  String company;
  String? recruiterId;
  String category;
  String description;
  List<String> requirements;
  String location;
  String salary;
  String? mcqTestId;
  DateTime createdAt;
  DateTime deadline;
  String companyLogoUrl;

  JobPost({
    required this.jobId,
    required this.title,
    required this.company,
    this.recruiterId,
    required this.category,
    required this.description,
    required this.requirements,
    required this.location,
    required this.salary,
    this.mcqTestId,
    required this.createdAt,
    required this.deadline,
    required this.companyLogoUrl,
  });

  // Convert from JSON
  factory JobPost.fromJson(Map<String, dynamic> json,id) {
    return JobPost(
      jobId: id,
      title: json['title'],
      company: json['company'],
      recruiterId: json['recruiterId'],
      category: json['category'],
      description: json['description'],
      requirements: List<String>.from(json['requirements']),
      location: json['location'],
      salary: json['salary'],
      mcqTestId: json['mcqTestId'],
      createdAt: DateTime.parse(json['createdAt']),
      deadline: DateTime.parse(json['deadline']),
      companyLogoUrl:
          json['companyLogo'] ?? '', // Default to empty string if null
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'jobId': jobId,
      'title': title,
      'company': company,
      'recruiterId': recruiterId,
      'category': category,
      'description': description,
      'requirements': requirements,
      'location': location,
      'salary': salary,
      'mcqTestId': mcqTestId,
      'createdAt': createdAt.toIso8601String(),
      'deadline': deadline.toIso8601String(),
      'companyLogo': companyLogoUrl,
    };
  }
}
