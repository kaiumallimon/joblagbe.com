import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:joblagbe/app/core/widgets/_custom_loading.dart';
import 'package:joblagbe/app/modules/auth/services/_login_services.dart';
import '../../../core/widgets/_custom_dialog.dart';
import 'package:go_router/go_router.dart';

class LoginController extends GetxController {
  var selectedLoginClient = 0.obs;

  void setSelectedLoginClient(int index) {
    selectedLoginClient.value = index;
  }

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool validateEmail(String email) => email.isNotEmpty;
  bool validatePassword(String password) => password.isNotEmpty;

  void clearFields() {
    emailController.clear();
    passwordController.clear();
  }

  void login(BuildContext context) async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (!validateEmail(email) || !validatePassword(password)) {
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
      var response = await LoginService().loginUser(email, password);
      Navigator.of(context).pop(); // Close loading dialog

      User? user = response['user'];
      String role = response['role'];

      if (user != null) {
        // Redirect based on user role
        if (role == 'Recruiter') {
          context.go('/dashboard/recruiter');
        } else if (role == 'Applicant') {
          context.go('/dashboard/applicant');
        } else if (role == 'Admin') {
          context.go('/dashboard/admin');
        } else {
          showCustomDialog(
            context: context,
            title: "Error",
            content: "Invalid user role.",
            buttonText: "Okay",
            onButtonPressed: () => Navigator.of(context).pop(),
            buttonColor: Colors.red,
          );
        }
      }
    } catch (error) {
      Navigator.of(context).pop(); // Close loading dialog
      showCustomDialog(
        context: context,
        title: "Login Error",
        content: error.toString(),
        buttonText: "Okay",
        onButtonPressed: () => Navigator.of(context).pop(),
        buttonColor: Colors.red,
      );
    }
  }
}
