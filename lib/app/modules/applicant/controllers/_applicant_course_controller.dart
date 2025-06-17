import 'package:get/get.dart';
import 'package:joblagbe/app/core/widgets/_custom_loading.dart';
import 'package:joblagbe/app/data/models/_course_model.dart';
import 'package:joblagbe/app/data/models/_course_progress_model.dart';
import 'package:joblagbe/app/data/services/_applicant_course_service.dart';

class ApplicantCourseController extends GetxController {
  final ApplicantCourseService _courseService = ApplicantCourseService();

  // Observable variables
  var isLoading = false.obs;
  var allCourses = <Course>[].obs;
  var enrolledCourses = <Course>[].obs;
  var filteredAllCourses = <Course>[].obs;
  var filteredEnrolledCourses = <Course>[].obs;
  var selectedTabIndex = 0.obs;
  var isEnrolling = false.obs;
  var courseProgress = <String, CourseProgressModel>{}.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCourses();
  }

  // Fetch all courses and enrolled courses
  Future<void> fetchCourses() async {
    try {
      isLoading.value = true;

      // Fetch all courses
      final courses = await _courseService.getAllCourses();
      allCourses.value = courses;
      filteredAllCourses.value = courses;

      // Fetch enrolled courses
      final enrolled = await _courseService.getEnrolledCourses();
      enrolledCourses.value = enrolled;
      filteredEnrolledCourses.value = enrolled;

      // Fetch progress for all enrolled courses
      for (final course in enrolled) {
        if (course.id != null) {
          final progress = await _courseService.getCourseProgress(course.id!);
          if (progress != null) {
            courseProgress[course.id!] = progress;
          }
        }
      }

      isLoading.value = false;
    } catch (error) {
      isLoading.value = false;
      customDialog('Error', error.toString());
    }
  }

  // Get progress for a course
  double getCourseProgress(String courseId) {
    return courseProgress[courseId]?.progressPercentage ?? 0.0;
  }

  // Search in all courses
  void searchAllCourses(String query) {
    if (query.isEmpty) {
      filteredAllCourses.value = allCourses;
      return;
    }

    final lowercaseQuery = query.toLowerCase();
    filteredAllCourses.value = allCourses.where((course) {
      return course.title.toLowerCase().contains(lowercaseQuery) ||
          course.description.toLowerCase().contains(lowercaseQuery) ||
          course.category.toLowerCase().contains(lowercaseQuery) ||
          course.tags.any((tag) => tag.toLowerCase().contains(lowercaseQuery));
    }).toList();
  }

  // Search in enrolled courses
  void searchEnrolledCourses(String query) {
    if (query.isEmpty) {
      filteredEnrolledCourses.value = enrolledCourses;
      return;
    }

    final lowercaseQuery = query.toLowerCase();
    filteredEnrolledCourses.value = enrolledCourses.where((course) {
      return course.title.toLowerCase().contains(lowercaseQuery) ||
          course.description.toLowerCase().contains(lowercaseQuery) ||
          course.category.toLowerCase().contains(lowercaseQuery) ||
          course.tags.any((tag) => tag.toLowerCase().contains(lowercaseQuery));
    }).toList();
  }

  // Change selected tab
  void changeTab(int index) {
    selectedTabIndex.value = index;
  }

  // Enroll in a course
  Future<void> enrollInCourse(String courseId) async {
    try {
      isEnrolling.value = true;
      await _courseService.enrollInCourse(courseId);
      await fetchCourses(); // Refresh the course lists
      customDialog('Success', 'Successfully enrolled in the course');
    } catch (error) {
      customDialog('Error', error.toString());
    } finally {
      isEnrolling.value = false;
    }
  }

  // Check if a course is enrolled
  bool isEnrolled(String courseId) {
    return enrolledCourses.any((course) => course.id == courseId);
  }
}
