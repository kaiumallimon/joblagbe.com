import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:joblagbe/app/data/models/_course_model.dart';
import 'package:joblagbe/app/data/models/_course_lesson_model.dart';

class AdminCourseService {
  final courseCollection = FirebaseFirestore.instance.collection('db_courses');
  final lessonCollection =
      FirebaseFirestore.instance.collection('db_course_lessons');

  // create course
  Future<String?> createCourse(Course course) async {
    try {
      final docRef = await courseCollection.add(course.toJson());
      return docRef.id;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // add lessons
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

  // get all courses
  Future<List<Course>?> getAllCourses() async {
    try {
      final snapshot = await courseCollection.get();
      return snapshot.docs
          .map((doc) => Course.fromJson(
                json: doc.data(),
                id: doc.id,
              ))
          .toList();
    } catch (error) {
      throw Exception(error.toString());
    }
  }

  // get all lessons for a course
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
      throw Exception(error.toString());
    }
  }
}
