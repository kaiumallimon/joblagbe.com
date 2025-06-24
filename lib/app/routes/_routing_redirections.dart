import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:joblagbe/app/modules/auth/controllers/_login_controller.dart';

class AppRoutingRedirections {
  static String? appRedirection(BuildContext context, GoRouterState state) {
    if (!Get.isRegistered<LoginController>()) return '/login';

    final authController = Get.find<LoginController>();

    // Wait for loading
    if (authController.isLoading.value) return null;

    // Allow users to visit the login and register pages freely
    if (state.matchedLocation == '/login' ||
        state.matchedLocation == '/register' ||
        state.matchedLocation == '/forgot-password' ||
        state.matchedLocation == '/landing' ||
        state.matchedLocation == '/jobs') {
      return null;
    }

    // If user is not logged in, redirect to login
    if (authController.userRole.value.isEmpty) return '/login';

    // Redirect based on role
    switch (authController.userRole.value) {
      case 'Recruiter':
        return state.matchedLocation.startsWith('/dashboard/recruiter')
            ? null
            : '/dashboard/recruiter/home';
      case 'Applicant':
        return state.matchedLocation.startsWith('/dashboard/applicant')
            ? null
            : '/dashboard/applicant/home';
      case 'Admin':
        return state.matchedLocation.startsWith('/dashboard/admin')
            ? null
            : '/dashboard/admin/home';
      default:
        return '/landing'; // Redirect unknown roles to home
    }
  }
}
