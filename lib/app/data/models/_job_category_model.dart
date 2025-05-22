class JobCategory {
  final String? id;
  final String name;
  final String? description;
  final String createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  JobCategory(
      {this.id,
      required this.name,
      this.description,
      required this.createdBy,
      required this.createdAt,
      required this.updatedAt});

  factory JobCategory.fromJson(
      {required Map<String, dynamic> json, String? id}) {
    return JobCategory(
      id: id,
      name: json['name'],
      description: json['description'],
      createdBy: json['createdBy'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'createdBy': createdBy,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
