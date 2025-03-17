import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:joblagbe/app/core/widgets/_custom_dialog.dart';
import 'package:joblagbe/app/core/widgets/_custom_loading.dart';
import 'package:joblagbe/app/modules/auth/services/_register_services.dart';

class RegisterController extends GetxController {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  var roles = ['Applicant', 'Recruiter'];
  var selectedRole = 'Applicant'.obs;

  bool validateInputs() {
    return nameController.text.trim().isNotEmpty &&
        emailController.text.trim().isNotEmpty &&
        passwordController.text.trim().isNotEmpty;
  }

  Future<void> register(BuildContext context) async {
    if (!validateInputs()) {
      showCustomDialog(
        context: context,
        title: "Error",
        content: "Please fill all fields",
        buttonText: "Okay",
        onButtonPressed: () => Navigator.of(context).pop(),
        buttonColor: Colors.red,
      );
      return;
    }

    showCustomLoadingDialog(context: context);

    try {
      await RegisterService().registerUser(
        nameController.text.trim(),
        emailController.text.trim(),
        passwordController.text.trim(),
        selectedRole.value,
      );

      Navigator.of(context).pop(); // Close loading dialog

      showCustomDialog(
        context: context,
        title: "Success",
        content: "Registration successful!",
        buttonText: "Okay",
        onButtonPressed: () => Navigator.of(context).pop(),
        buttonColor: Colors.green,
      );

      // clear the text fields after successful registration
      nameController.clear();
      emailController.clear();
      passwordController.clear();
      selectedRole.value = 'Applicant';
    } catch (error) {
      Navigator.of(context).pop(); // Close loading dialog

      showCustomDialog(
        context: context,
        title: "Error",
        content: error.toString(),
        buttonText: "Okay",
        onButtonPressed: () => Navigator.of(context).pop(),
        buttonColor: Colors.red,
      );
    }
  }
}
