import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:joblagbe/app/core/widgets/_custom_loading.dart';

import '../../../data/services/_password_reset_service.dart';

class PasswordResetController extends GetxController {
  final PasswordResetService _passwordResetService = PasswordResetService();
  final emailController = TextEditingController();

  void sendResetLink(BuildContext context) async {
    String email = emailController.text.trim();

    if (email.isEmpty) {
      customDialog(
        "Error",
        "Please enter your email address.",
      );
      return;
    }

    if (!GetUtils.isEmail(email)) {
      customDialog(
        "Error",
        "Please enter a valid email address.",
      );
      return;
    }

    showCustomLoadingDialog();

    try {
      await _passwordResetService.sendPasswordResetEmail(email);

      // Close loading dialog first
      closeCustomLoadingDialog();

      customDialog(
        "Success",
        "Password reset link sent to $email.",
      );
    } catch (e) {
      // Close loading dialog first
      closeCustomLoadingDialog();
      customDialog(
        "Error",
        "Failed to send password reset link. Please try again.",
      );
    }
  }



  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}
