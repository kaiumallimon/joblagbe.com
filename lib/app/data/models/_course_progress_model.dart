/*
-- Which lessons a user has completed
create table course_progress (
  id uuid primary key default uuid_generate_v4(),
  user_id uuid references profiles(id) on delete cascade,
  course_id uuid references courses(id) on delete cascade,
  lesson_id uuid references lessons(id) on delete cascade,
  completed boolean default false,
  completed_at timestamp
);

*/

class CourseProgressModel {
  final String? id;
  final String? courseId;
  final String? userId;
  final DateTime? startedAt;
  final DateTime? completedAt;
  final double progressPercentage;
  final bool isCompleted;
  final Map<String, dynamic> lessonProgress;

  CourseProgressModel({
    this.id,
    this.courseId,
    this.userId,
    this.startedAt,
    this.completedAt,
    this.progressPercentage = 0.0,
    this.isCompleted = false,
    required this.lessonProgress,
  });

  factory CourseProgressModel.fromJson(Map<String, dynamic> json, String? id) {
    DateTime? parseDate(String? dateStr) {
      if (dateStr == null || dateStr.isEmpty) return null;
      try {
        return DateTime.parse(dateStr);
      } catch (e) {
        return null;
      }
    }

    return CourseProgressModel(
      id: id,
      courseId: json['courseId'] as String?,
      userId: json['userId'] as String?,
      startedAt: parseDate(json['startedAt'] as String?),
      completedAt: parseDate(json['completedAt'] as String?),
      progressPercentage:
          (json['progressPercentage'] as num?)?.toDouble() ?? 0.0,
      isCompleted: json['isCompleted'] as bool? ?? false,
      lessonProgress: json['lessonProgress'] as Map<String, dynamic>? ??
          <String, dynamic>{},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'courseId': courseId,
      'userId': userId,
      'startedAt': startedAt?.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'progressPercentage': progressPercentage,
      'isCompleted': isCompleted,
      'lessonProgress': lessonProgress,
    };
  }
}
