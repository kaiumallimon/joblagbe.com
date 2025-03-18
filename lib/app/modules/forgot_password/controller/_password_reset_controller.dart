import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:joblagbe/app/core/widgets/_custom_dialog.dart';
import 'package:joblagbe/app/core/widgets/_custom_loading.dart';

import '../services/_password_reset_service.dart';

class PasswordResetController extends GetxController {
  final PasswordResetService _passwordResetService = PasswordResetService();
  final emailController = TextEditingController();

  void sendResetLink(BuildContext context) async {
    String email = emailController.text.trim();

    if (email.isEmpty) {
      _showDialog(
          context, "Error", "Please enter your email address.", Colors.red);
      return;
    }

    if (!GetUtils.isEmail(email)) {
      _showDialog(
          context, "Error", "Please enter a valid email address.", Colors.red);
      return;
    }

    showCustomLoadingDialog(context: context);

    try {
      await _passwordResetService.sendPasswordResetEmail(email);

      // Close loading dialog first
      Navigator.of(context).pop();

      _showDialog(context, "Success", "Password reset link sent to $email.",
          Colors.green,
          clearOnClose: true);
    } catch (e) {
      // Close loading dialog first
      Navigator.of(context).pop();
      _showDialog(context, "Error",
          "Failed to send password reset link. Please try again.", Colors.red);
    }
  }

  void _showDialog(
      BuildContext context, String title, String content, Color buttonColor,
      {bool clearOnClose = false}) {
    showCustomDialog(
      context: context,
      title: title,
      content: content,
      buttonText: "Okay",
      onButtonPressed: () {
        Navigator.of(context).pop();
        if (clearOnClose) {
          emailController.clear();
        }
      },
      buttonColor: buttonColor,
    );
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}
