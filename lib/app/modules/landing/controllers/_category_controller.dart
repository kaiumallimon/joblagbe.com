import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:joblagbe/app/modules/landing/views/categories/model/_categories_model.dart';
import 'package:joblagbe/app/modules/landing/views/categories/model/_jobs_model.dart';

import '../views/categories/services/_category_services.dart';
import '../views/categories/services/_jobs_service.dart';

class CategoryController extends GetxController {
  var isCategoryLoading = false.obs;
  var isJobsLoading = false.obs;
  var categories = <CategoryModel>[].obs;
  RxList<JobPost> jobs = <JobPost>[].obs;
  RxString selectedCategory = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  void fetchCategories() async {
    isCategoryLoading.value = true;
    try {
      // Simulate a network call
      await Future.delayed(Duration(seconds: 2));
      // Fetch categories from the service
      categories.value = await CategoryServices().getCategories();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load categories: $e',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isCategoryLoading.value = false;
    }
  }

  void fetchJobsByCategory(String category) async {
    if (category.isEmpty) {
      jobs.clear();
      return;
    }

    isJobsLoading.value = true;
    try {
      // Simulate a network call
      await Future.delayed(Duration(seconds: 2));
      // Fetch jobs from the service
      jobs.value = await JobService().getJobsByCategory(category);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load jobs: $e',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isJobsLoading.value = false;
    }
  }

  void setSelectedCategory(String category) {
    selectedCategory.value = category;
    fetchJobsByCategory(category);
  }

  List<String> getFullPath(BuildContext context) {
    // Get the current route name
    final currentRoute = ModalRoute.of(context)?.settings.name;

    // Check if the current route is null or empty
    if (currentRoute == null || currentRoute.isEmpty) {
      return ['/'];
    }

    // Return the full path
    return currentRoute.split('/').where((path) => path.isNotEmpty).toList();
  }
}
