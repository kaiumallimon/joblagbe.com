import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:joblagbe/app/core/theming/colors/_colors.dart';
import 'package:joblagbe/app/data/models/_job_category_model.dart';
import 'package:joblagbe/app/data/services/_admin_category_services.dart';
import 'package:joblagbe/app/data/services/_admin_home_services.dart';
import 'package:joblagbe/app/routes/_routing_imports.dart';

class AdminHomeController extends GetxController {
  final homeService = AdminHomeServices();
  final categoryService = AdminCategoryServices();

  var isLoading = false.obs;
  var totalRecruitersCount = 0.obs;
  var totalApplicantsCount = 0.obs;
  var totalJobCategoriesCount = 0.obs;
  var totalJobsCount = 0.obs;
  var totalCoursesCount = 0.obs;

  // Category data for pie chart
  var categories = <JobCategory>[].obs;
  var categoryDistribution = <Map<String, dynamic>>[].obs;
  var selectedCategoryIndex = (-1).obs; // Track selected section index

  @override
  void onInit() {
    super.onInit();
    getTotalRecruitersCount();
    getTotalApplicantsCount();
    getTotalJobCategoriesCount();
    getTotalJobsCount();
    getTotalCoursesCount();
    getCategoriesForChart();
  }

  void getTotalRecruitersCount() {
    homeService.getTotalRecruitersCount().listen((count) {
      totalRecruitersCount.value = count ?? 0;
    });
  }

  void getTotalApplicantsCount() {
    homeService.getTotalApplicantCount().listen((count) {
      totalApplicantsCount.value = count ?? 0;
    });
  }

  void getTotalJobCategoriesCount() {
    homeService.getTotalJobsCategoryCount().listen((count) {
      totalJobCategoriesCount.value = count ?? 0;
    });
  }

  void getTotalJobsCount() {
    homeService.getTotalJobsCount().listen((count) {
      totalJobsCount.value = count ?? 0;
    });
  }

  void getTotalCoursesCount() {
    homeService.getTotalCoursesCount().listen((count) {
      totalCoursesCount.value = count ?? 0;
    });
  }

  Future<void> getCategoriesForChart() async {
    try {
      isLoading.value = true;
      final categoriesList = await categoryService.getAllCategories();
      if (categoriesList != null) {
        categories.value = categoriesList;

        // Calculate distribution for pie chart
        final total = categoriesList.length;
        final distribution = categoriesList.map((category) {
          final percentage = (1 / total * 100).round();
          return {
            'name': category.name,
            'percentage': percentage,
            'color': _getColorForIndex(categoriesList.indexOf(category)),
          };
        }).toList();

        categoryDistribution.value = distribution;
      }
    } catch (e) {
      print('Error fetching categories: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Color _getColorForIndex(int index) {
    final colors = [
      AppColors.primary,
      const Color(0xFF4CAF50), // Green
      const Color(0xFFFFC107), // Amber
      const Color(0xFF2196F3), // Blue
      const Color(0xFF9C27B0), // Purple
      const Color(0xFFFF5722), // Deep Orange
      const Color(0xFF00BCD4), // Cyan
      const Color(0xFF795548), // Brown
      const Color(0xFF607D8B), // Blue Grey
    ];
    return colors[index % colors.length];
  }
}
