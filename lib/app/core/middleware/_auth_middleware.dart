import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:joblagbe/app/modules/auth/controllers/_login_controller.dart';

class RoleMiddleware extends GetMiddleware {
  final String requiredRole;

  RoleMiddleware({required this.requiredRole});

  @override
  RouteSettings? redirect(String? route) {
    final authController = Get.find<LoginController>();

    // If still loading, return null to wait
    if (authController.isLoading.value) return null;

    // Redirect if role does not match
    if (authController.userRole.value != requiredRole) {
      return const RouteSettings(name: '/');
    }

    return null; // Allow access if role matches
  }
}
