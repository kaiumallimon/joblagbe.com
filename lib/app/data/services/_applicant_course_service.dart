import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:joblagbe/app/data/models/_course_model.dart';
import 'package:joblagbe/app/data/models/_course_progress_model.dart';
import 'package:joblagbe/app/data/models/_course_lesson_model.dart';

class ApplicantCourseService {
  final coursesCollection = FirebaseFirestore.instance.collection('db_courses');
  final courseProgressCollection =
      FirebaseFirestore.instance.collection('db_course_progress');
  final lessonCollection =
      FirebaseFirestore.instance.collection('db_course_lessons');

  // Get all courses
  Future<List<Course>> getAllCourses() async {
    try {
      final snapshot = await coursesCollection.get();
      return snapshot.docs
          .map((doc) => Course.fromJson(json: doc.data(), id: doc.id))
          .toList();
    } catch (e) {
      throw Exception('Failed to get courses: $e');
    }
  }

  // Get enrolled courses for current user
  Future<List<Course>> getEnrolledCourses() async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) throw Exception('User not logged in');

      // Get course progress for user
      final progressSnapshot = await courseProgressCollection
          .where('userId', isEqualTo: userId)
          .get();

      if (progressSnapshot.docs.isEmpty) return [];

      // Get course IDs from progress
      final courseIds = progressSnapshot.docs
          .map((doc) => doc.data()['courseId'] as String)
          .toList();

      // Get course details
      final coursesSnapshot = await coursesCollection
          .where(FieldPath.documentId, whereIn: courseIds)
          .get();

      return coursesSnapshot.docs
          .map((doc) => Course.fromJson(json: doc.data(), id: doc.id))
          .toList();
    } catch (e) {
      throw Exception('Failed to get enrolled courses: $e');
    }
  }

  // Get course progress for a specific course
  Future<CourseProgressModel?> getCourseProgress(String courseId) async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) throw Exception('User not logged in');

      final snapshot = await courseProgressCollection
          .where('courseId', isEqualTo: courseId)
          .where('userId', isEqualTo: userId)
          .get();

      if (snapshot.docs.isEmpty) return null;

      return CourseProgressModel.fromJson(
        snapshot.docs.first.data(),
        snapshot.docs.first.id,
      );
    } catch (e) {
      throw Exception('Failed to get course progress: $e');
    }
  }

  // Get all lessons for a course
  Future<List<CourseLesson>?> getAllLessonsForCourse(String courseId) async {
    try {
      final snapshot =
          await lessonCollection.where('courseId', isEqualTo: courseId).get();
      return snapshot.docs
          .map((doc) => CourseLesson.fromJson(
                json: doc.data(),
                id: doc.id,
              ))
          .toList();
    } catch (error) {
      throw Exception('Failed to get lessons: $error');
    }
  }

  // Enroll in a course
  Future<void> enrollInCourse(String courseId) async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) throw Exception('User not logged in');

      // Check if already enrolled
      final existingProgress = await getCourseProgress(courseId);
      if (existingProgress != null) {
        throw Exception('Already enrolled in this course');
      }

      // create lesson progress map with lesson id as key:
      final lessons = await getAllLessonsForCourse(courseId);
      final lessonProgress = <String, dynamic>{};
      if (lessons != null) {
        for (final lesson in lessons) {
          lessonProgress[lesson.id!] = {
            'completed': false,
            'completedAt': null,
          };
        }
      }

      // Create new course progress
      final progress = CourseProgressModel(
        courseId: courseId,
        userId: userId,
        startedAt: DateTime.now(),
        progressPercentage: 0.0,
        isCompleted: false,
        lessonProgress: lessonProgress,
      );

      await courseProgressCollection.add(progress.toJson());
    } catch (e) {
      throw Exception('Failed to enroll in course: $e');
    }
  }
}
