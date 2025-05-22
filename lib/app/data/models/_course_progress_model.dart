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

class CourseProgress {
  String id;
  String userId;
  String courseId;
  String lessonId;
  bool completed;
  String completedAt;

  // constructor
  CourseProgress({
    required this.id,
    required this.userId,
    required this.courseId,
    required this.lessonId,
    required this.completed,
    required this.completedAt,
  });

  // factory constructor
  factory CourseProgress.fromJson(Map<String, dynamic> json) {
    return CourseProgress(
      id: json['id'],
      userId: json['userId'],
      courseId: json['courseId'],
      lessonId: json['lessonId'],
      completed: json['completed'],
      completedAt: json['completedAt'],
    );
  }

  // toJson method
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'courseId': courseId,
      'lessonId': lessonId,
      'completed': completed,
      'completedAt': completedAt,
    };
  }
}
