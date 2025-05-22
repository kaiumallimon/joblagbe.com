import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:joblagbe/app/data/models/_course_model.dart';
import 'package:joblagbe/app/data/models/_course_lesson_model.dart';

class AdminCourseService {
  final courseCollection = FirebaseFirestore.instance.collection('db_courses');
  final lessonCollection = FirebaseFirestore.instance.collection('db_course_lessons');

  Future<void> createCourse(Course course, List<CourseLesson> lessons) async {
    try {
      // Create the course document
      await courseCollection.doc(course.id).set(course.toJson());

      // Create lesson documents
      for (var lesson in lessons) {
        await lessonCollection.doc(lesson.id).set(lesson.toJson());
      }
    } catch (e) {
      throw Exception('Failed to create course: $e');
    }
  }

  Future<List<Course>> getAllCourses() async {
    try {
      final snapshot = await courseCollection.get();
      return snapshot.docs.map((doc) => Course.fromJson(json: doc.data(), id: doc.id)).toList();
    } catch (e) {
      throw Exception('Failed to get courses: $e');
    }
  }

  Future<List<CourseLesson>> getCourseLessons(String courseId) async {
    try {
      final snapshot = await lessonCollection
          .where('courseId', isEqualTo: courseId)
          .orderBy('orderIndex')
          .get();
      return snapshot.docs.map((doc) => CourseLesson.fromJson(json: doc.data(), id: doc.id)).toList();
    } catch (e) {
      throw Exception('Failed to get course lessons: $e');
    }
  }
}