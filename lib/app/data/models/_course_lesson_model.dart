class CourseLesson {
  String id;
  String courseId;
  String title;
  String description;
  String videoUrl;
  int orderIndex;
  String createdAt;

  // constructor
  CourseLesson({
    required this.id,
    required this.courseId,
    required this.title,
    required this.description,
    required this.videoUrl,
    required this.orderIndex,
    required this.createdAt,
  });

  // factory constructor
  factory CourseLesson.fromJson(Map<String, dynamic> json) {
    return CourseLesson(
      id: json['id'],
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
      'id': id,
      'courseId': courseId,
      'title': title,
      'description': description,
      'videoUrl': videoUrl,
      'orderIndex': orderIndex,
      'createdAt': createdAt,
    };
  }
}
