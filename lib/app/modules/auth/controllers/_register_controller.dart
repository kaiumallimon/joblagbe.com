import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:joblagbe/app/core/widgets/_custom_loading.dart';
import 'package:joblagbe/app/data/services/_register_services.dart';

class RegisterController extends GetxController {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  var roles = ['Applicant', 'Recruiter', 'Admin'];
  var selectedRole = 'Applicant'.obs;

  bool validateInputs() {
    return nameController.text.trim().isNotEmpty &&
        emailController.text.trim().isNotEmpty &&
        passwordController.text.trim().isNotEmpty;
  }

  Future<void> register(BuildContext context) async {
    if (!validateInputs()) {
      customDialog(
        "Error",
        "Please fill all fields",
      );
      return;
    }

    showCustomLoadingDialog();

    try {
      await RegisterService().registerUser(
        nameController.text.trim(),
        emailController.text.trim(),
        passwordController.text.trim(),
        selectedRole.value,
      );

      closeCustomLoadingDialog();

      customDialog(
        "Success",
        "Registration successful!",
      );

      // clear the text fields after successful registration
      nameController.clear();
      emailController.clear();
      passwordController.clear();
      selectedRole.value = 'Applicant';
    } catch (error) {
      closeCustomLoadingDialog();
      customDialog(
        "Error",
        error.toString(),
      );
    }
  }
}
