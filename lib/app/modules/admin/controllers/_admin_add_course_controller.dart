import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:joblagbe/app/core/widgets/_custom_loading.dart';
import 'package:joblagbe/app/data/models/_course_lesson_model.dart';
import 'package:joblagbe/app/data/models/_course_model.dart';
import 'package:joblagbe/app/data/models/_job_category_model.dart';
import 'package:joblagbe/app/data/services/_admin_category_services.dart';
import 'package:joblagbe/app/data/services/_admin_course_service.dart';

class AdminAddCourseController extends GetxController {
  // course controllers
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final thumbnailUrlController = TextEditingController();
  final tagsController = TextEditingController();
  var categories = <JobCategory>[].obs;
  var selectedCategory = Rxn<JobCategory>();
  var isLoading = false.obs;

  // Make lessons list reactive
  final RxList<List<TextEditingController>> lessonControllers =
      <List<TextEditingController>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadCategories();
  }

  Future<void> loadCategories() async {
    isLoading.value = true;
    try {
      final categories = await AdminCategoryServices().getAllCategories();
      // Wait for categories to be loaded
      this.categories.assignAll(categories ?? []);
      // Reset selected category when categories are loaded
      selectedCategory.value = null;
    } catch (e) {
      customDialog("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  bool validateForm() {
    if (titleController.text.trim().isEmpty) {
      customDialog("Error", 'Please enter a course title');
      return false;
    }
    if (descriptionController.text.trim().isEmpty) {
      customDialog("Error", 'Please enter a course description');
      return false;
    }
    if (thumbnailUrlController.text.trim().isEmpty) {
      customDialog('Error', 'Please enter a thumbnail URL');
      return false;
    }
    if (selectedCategory.value == null) {
      customDialog('Error', 'Please select a category');
      return false;
    }
    if (tagsController.text.trim().isEmpty) {
      customDialog('Error', 'Please enter tags');
      return false;
    }
    if (lessonControllers.isEmpty) {
      customDialog('Error', 'Please add at least one lesson');
      return false;
    }
    for (var lesson in lessonControllers) {
      if (lesson[0].text.trim().isEmpty) {
        customDialog('Error', 'Please enter a lesson title');
        return false;
      }
      if (lesson[1].text.trim().isEmpty) {
        customDialog('Error', 'Please enter a lesson description');
        return false;
      }
      if (lesson[2].text.trim().isEmpty) {
        customDialog('Error', 'Please enter a lesson video URL');
        return false;
      }
    }
    return true;
  }

  // dynamically add and remove lesson controllers
  void addLesson() {
    lessonControllers.add([
      TextEditingController(),
      TextEditingController(),
      TextEditingController(),
    ]);
  }

  void removeLesson(int index) {
    if (index >= 0 && index < lessonControllers.length) {
      // Dispose the controllers before removing
      for (var controller in lessonControllers[index]) {
        controller.dispose();
      }
      lessonControllers.removeAt(index);
    }
  }

  var courseService = AdminCourseService();

  var isCreatingCourse = false.obs;

  Future<void> createCourse() async {
    if (!validateForm()) return;
    try {
      isCreatingCourse.value = true;
      final title = titleController.text.trim();
      final description = descriptionController.text.trim();
      final thumbnailUrl = thumbnailUrlController.text.trim();
      final category = selectedCategory.value;
      final createdBy = FirebaseAuth.instance.currentUser?.uid;
      final createdAt = DateTime.now();

      final course = Course(
          title: title,
          description: description,
          thumbnailUrl: thumbnailUrl,
          category: category!.name,
          tags: tagsController.text.trim().split(','),
          createdBy: createdBy!,
          createdAt: createdAt.toIso8601String());

      // create course
      final courseId = await courseService.createCourse(course);

      if (courseId == null) {
        customDialog("Error", "Failed to create course");
        isCreatingCourse.value = false;
        return;
      }

      // prepare lessons object
      final lessons = lessonControllers
          .map((lesson) => CourseLesson(
              title: lesson[0].text.trim(),
              description: lesson[1].text.trim(),
              videoUrl: lesson[2].text.trim(),
              courseId: courseId,
              orderIndex: lessonControllers.indexOf(lesson),
              createdAt: createdAt.toIso8601String()))
          .toList();

      // create lessons
      final lessonResponse = await courseService.addLessons(lessons);

      if (lessonResponse['success']) {
        customDialog("Success", "Course created successfully");
        isCreatingCourse.value = false;
        clearControllers();
      } else {
        isCreatingCourse.value = false;
        customDialog("Error", lessonResponse['message']);
      }
    } catch (error) {
      isCreatingCourse.value = false;
      customDialog("Error", error.toString());
    }
  }

  void clearControllers() {
    titleController.clear();
    descriptionController.clear();
    thumbnailUrlController.clear();
    tagsController.clear();
    lessonControllers.clear();
    selectedCategory.value = null;
  }

  @override
  void onClose() {
    // Clean up controllers
    clearControllers();
    super.onClose();
  }
}
