import 'package:flutter/material.dart';
import 'package:joblagbe/app/core/widgets/_custom_loading.dart';
import 'package:joblagbe/app/data/models/_course_model.dart';
import 'package:joblagbe/app/data/services/_admin_course_service.dart';
import 'package:joblagbe/app/routes/_routing_imports.dart';

class AdminCoursesController extends GetxController {
  final courseService = AdminCourseService();

  var courses = <Course>[].obs;
  var filteredCourses = <Course>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCourses();
  }

  Future<void> fetchCourses() async {
    isLoading.value = true;
    try {
      final courses = await courseService.getAllCourses();
      if (courses == null) {
        isLoading.value = false;
        return;
      }
      debugPrint(courses.length.toString());
      this.courses.value = courses;
      this.filteredCourses.value = courses;
      isLoading.value = false;
    } catch (e) {
      debugPrint(e.toString());
      customDialog("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void filterCourses(String query) {
    if (query.isEmpty) {
      filteredCourses.value = courses;
    } else {
      filteredCourses.value = courses.where((course) {
        return course.title.toLowerCase().contains(query.toLowerCase()) ||
            course.description.toLowerCase().contains(query.toLowerCase()) ||
            course.category.toLowerCase().contains(query.toLowerCase()) ||
            course.tags.any((tag) => tag.toLowerCase().contains(query.toLowerCase()));
      }).toList();
    }
  }
}
