class CourseLesson {
  String? id;
  String courseId;
  String title;
  String description;
  String videoUrl;
  int orderIndex;
  String createdAt;
  int? duration;
  List<String>? resources;

  // constructor
  CourseLesson({
    this.id,
    required this.courseId,
    required this.title,
    required this.description,
    required this.videoUrl,
    required this.orderIndex,
    required this.createdAt,
    this.duration,
    this.resources,
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
      duration: json['duration'],
      resources: json['resources'] != null ? List<String>.from(json['resources']) : null,
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
      'duration': duration,
      'resources': resources,
    };
  }
}
