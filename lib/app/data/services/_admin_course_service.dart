import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:joblagbe/app/data/models/_course_model.dart';
import 'package:joblagbe/app/data/models/_course_lesson_model.dart';

class AdminCourseService {
  final courseCollection = FirebaseFirestore.instance.collection('db_courses');
  final lessonCollection =
      FirebaseFirestore.instance.collection('db_course_lessons');

  Future<String?> createCourse(Course course) async {
    try {
      final docRef = await courseCollection.add(course.toJson());
      return docRef.id;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<Map<String, dynamic>> addLessons(List<CourseLesson> lessons) async {
    try {
      // batch write
      final batch = FirebaseFirestore.instance.batch();
      for (var lesson in lessons) {
        final lessonDocRef = lessonCollection.doc();
        batch.set(lessonDocRef, lesson.toJson());
      }
      await batch.commit();
      return {'success': true, 'message': 'Lessons added successfully'};
    } catch (error) {
      return {'success': false, 'message': error.toString()};
    }
  }
}
