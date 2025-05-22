import 'package:get/get.dart';
import 'package:joblagbe/app/core/widgets/_custom_loading.dart';
import 'package:joblagbe/app/data/models/_job_category_model.dart';
import 'package:joblagbe/app/data/services/_admin_category_services.dart';

class AdminCategoriesController extends GetxController {
  final AdminCategoryServices adminCategoryServices = AdminCategoryServices();

  final RxList<JobCategory> _categories = <JobCategory>[].obs;
  List<JobCategory> get categories => _categories;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  var isLoading = false.obs;

  Future<void> fetchCategories() async {
    try {
      isLoading.value = true;
      final categories = await adminCategoryServices.getAllCategories();
      if (categories == null) {
        isLoading.value = false;
        customDialog("Error", "No categories found");
      } else {
        _categories.assignAll(categories);
        isLoading.value = false;
      }
    } catch (e) {
      isLoading.value = false;
      customDialog("Error", e.toString());
    }
  }
}
