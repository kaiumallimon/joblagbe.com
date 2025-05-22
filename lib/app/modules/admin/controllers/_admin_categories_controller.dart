import 'package:get/get.dart';
import 'package:joblagbe/app/core/widgets/_custom_loading.dart';
import 'package:joblagbe/app/data/models/_job_category_model.dart';
import 'package:joblagbe/app/data/services/_admin_category_services.dart';

class AdminCategoriesController extends GetxController {
  final AdminCategoryServices adminCategoryServices = AdminCategoryServices();

  final RxList<JobCategory> _categories = <JobCategory>[].obs;
  final RxList<JobCategory> _filteredCategories = <JobCategory>[].obs;
  List<JobCategory> get categories => _filteredCategories;

  final RxString searchQuery = ''.obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    ever(searchQuery, (_) => _filterCategories());
  }

  @override
  void onReady() {
    super.onReady();
    fetchCategories();
  }

  void _filterCategories() {
    if (searchQuery.value.isEmpty) {
      _filteredCategories.assignAll(_categories);
    } else {
      final query = searchQuery.value.toLowerCase();
      _filteredCategories.assignAll(
        _categories.where((category) {
          final name = category.name.toLowerCase();
          final description = category.description?.toLowerCase() ?? '';
          return name.contains(query) || description.contains(query);
        }).toList(),
      );
    }
  }

  Future<void> fetchCategories() async {
    try {
      isLoading.value = true;
      final categories = await adminCategoryServices.getAllCategories();
      if (categories == null) {
        _categories.clear();
        _filteredCategories.clear();
        customDialog("Error", "No categories found");
      } else {
        _categories.assignAll(categories);
        _filteredCategories.assignAll(categories);
      }
    } catch (e) {
      _categories.clear();
      _filteredCategories.clear();
      customDialog("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
