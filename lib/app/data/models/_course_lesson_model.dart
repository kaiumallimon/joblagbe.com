class CourseLesson {
  String? id;
  String courseId;
  String title;
  String description;
  String videoUrl;
  int orderIndex;
  String createdAt;

  // constructor
  CourseLesson({
    this.id,
    required this.courseId,
    required this.title,
    required this.description,
    required this.videoUrl,
    required this.orderIndex,
    required this.createdAt,
  });

  // factory constructor
  factory CourseLesson.fromJson({required Map<String, dynamic> json, String? id}) {
    return CourseLesson(
      id: id,
      courseId: json['courseId'],
      title: json['title'],
      description: json['description'],
      videoUrl: json['videoUrl'],
      orderIndex: json['orderIndex'],
      createdAt: json['createdAt'],
    );
  }

  // toJson method
  Map<String, dynamic> toJson() {
    return {
      'courseId': courseId,
      'title': title,
      'description': description,
      'videoUrl': videoUrl,
      'orderIndex': orderIndex,
      'createdAt': createdAt,
    };
  }
}
