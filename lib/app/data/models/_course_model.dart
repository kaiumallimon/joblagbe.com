class Course {
  final String? id;
  final String title;
  final String description;
  final String thumbnailUrl;
  final String category;
  final String createdBy;
  final String createdAt;

  // constructor
  Course({
    this.id,
    required this.title,
    required this.description,
    required this.thumbnailUrl,
    required this.category,
    required this.createdBy,
    required this.createdAt,
  });

  // factory constructor
  factory Course.fromJson({required Map<String, dynamic> json, String? id}) {
    return Course(
      id: id,
      title: json['title'],
      description: json['description'],
      thumbnailUrl: json['thumbnailUrl'],
      category: json['category'],
      createdBy: json['createdBy'],
      createdAt: json['createdAt'],
    );
  }

  // toJson method
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'thumbnailUrl': thumbnailUrl,
      'category': category,
      'createdBy': createdBy,
      'createdAt': createdAt,
    };
  }
}
