import 'package:go_router/go_router.dart';
import 'package:get/get.dart';
import 'package:joblagbe/app/modules/404/views/_404_notfound.dart';
import 'package:joblagbe/app/modules/dashboard/applicant/wrapper/pages/_applicant_dashboard.dart';
import 'package:joblagbe/app/modules/auth/views/login/_login.dart';
import 'package:joblagbe/app/modules/auth/views/register/views/pages/_register.dart';
import 'package:joblagbe/app/modules/dashboard/applicant/home/pages/_applicant_home.dart';
import 'package:joblagbe/app/modules/dashboard/applicant/jobs/pages/_applicant_jobs.dart';
import 'package:joblagbe/app/modules/dashboard/recruiter/wrapper/pages/_recruiter_dashbord_layout.dart';
import 'package:joblagbe/app/modules/dashboard/recruiter/home/pages/_recruiter_home.dart';
import 'package:joblagbe/app/modules/dashboard/recruiter/jobs/pages/_recruiter_jobs.dart';

import '../../modules/auth/controllers/_login_controller.dart';
import '../../modules/landing/views/_landing_layout.dart';
import '../../modules/landing/views/_landing_page.dart';
import '../../modules/landing/views/categories/views/_categories.dart';

class AppRouter {
  static GoRouter router = GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      if (!Get.isRegistered<LoginController>()) return '/login';

      final authController = Get.find<LoginController>();

      // Wait for loading
      if (authController.isLoading.value) return null;

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
          return '/'; // Redirect unknown roles to home
      }
    },
    refreshListenable: Get.find<LoginController>().userRoleNotifier,
    routes: [
      // Public Routes
      // Shell Route for Landing Pages
      ShellRoute(
        builder: (context, state, child) {
          return LandingLayout(child: child);
        },
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const LandingPage(),
          ),
          GoRoute(
            path: '/jobs',
            builder: (context, state) => const CategoriesPage(),
          ),
        ],
      ),

      GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
      GoRoute(
          path: '/register', builder: (context, state) => const RegisterPage()),

      // Recruiter Dashboard (Protected)
      ShellRoute(
        builder: (context, state, child) =>
            RecruiterDashboardLayout(child: child),
        redirect: (context, state) => _getRedirect('Recruiter'),
        routes: [
          GoRoute(
            path: '/dashboard/recruiter/home',
            builder: (context, state) => const RecruiterHome(),
            redirect: (context, state) => _getRedirect('Recruiter'),
          ),
          GoRoute(
            path: '/dashboard/recruiter/jobs',
            builder: (context, state) => const RecruiterJobsPage(),
          ),
        ],
      ),

      // Applicant Dashboard (Protected)
      ShellRoute(
        builder: (context, state, child) =>
            ApplicantDashboardLayout(child: child),
        redirect: (context, state) => _getRedirect('Applicant'),
        routes: [
          GoRoute(
            path: '/dashboard/applicant/home',
            builder: (context, state) => const ApplicantHome(),
            redirect: (context, state) => _getRedirect('Applicant'),
          ),
          GoRoute(
            path: '/dashboard/applicant/jobs',
            builder: (context, state) => const ApplicantJobs(),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) {
      return PageNotFound();
    },
  );

  // Role-Based Redirection Helper
  static String? _getRedirect(String requiredRole) {
    final authController = Get.find<LoginController>();

    // Wait for loading
    if (authController.isLoading.value) return null;

    // If user is not logged in, redirect to login
    if (authController.userRole.isEmpty) return '/login';

    // If role doesn't match, redirect to home
    return (authController.userRole.value == requiredRole) ? null : '/';
  }
}
