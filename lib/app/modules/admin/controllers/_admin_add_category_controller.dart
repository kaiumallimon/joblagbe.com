import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:joblagbe/app/core/widgets/_custom_loading.dart';
import 'package:joblagbe/app/data/models/_job_category_model.dart';
import 'package:joblagbe/app/data/services/_admin_category_services.dart';

class AdminAddCategoryController extends GetxController {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  // Loading state
  final RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  // Form validation
  final RxString _nameError = ''.obs;
  String get nameError => _nameError.value;

  @override
  void onClose() {
    nameController.dispose();
    descriptionController.dispose();
    super.onClose();
  }

  // Validate form inputs
  bool _validateInputs() {
    _nameError.value = '';

    if (nameController.text.trim().isEmpty) {
      _nameError.value = 'Category title is required';
      return false;
    }

    if (nameController.text.trim().length < 3) {
      _nameError.value = 'Category title must be at least 3 characters';
      return false;
    }

    return true;
  }

  // Add category
  Future<void> addCategory() async {
    if (!_validateInputs()) {
      return;
    }

    try {
      _isLoading.value = true;
      showCustomLoadingDialog();

      final category = JobCategory(
        name: nameController.text.trim(),
        description: descriptionController.text.trim(),
        createdBy: FirebaseAuth.instance.currentUser!.uid,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final categoryResponse =
          await AdminCategoryServices().addCategory(category);

      if (categoryResponse['success']) {
        _resetForm();
        closeCustomLoadingDialog();
        customDialog("Success", "Category added successfully");
      } else {
        closeCustomLoadingDialog();
        customDialog(
            "Error", categoryResponse['message'] ?? 'Failed to add category');
      }
    } catch (error) {
      closeCustomLoadingDialog();
      customDialog(
          "Error",
          error is FirebaseAuthException
              ? error.message ?? 'Authentication error occurred'
              : 'An unexpected error occurred');
    } finally {
      _isLoading.value = false;
      // closeCustomLoadingDialog();
    }
  }

  // Reset form
  void _resetForm() {
    nameController.clear();
    descriptionController.clear();
    _nameError.value = '';
  }
}
