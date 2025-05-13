import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:get/get.dart';
import 'package:joblagbe/app/modules/404/views/_404_notfound.dart';
import 'package:joblagbe/app/modules/dashboard/applicant/profile/pages/_profile_page.dart';
import 'package:joblagbe/app/modules/dashboard/applicant/wrapper/pages/_applicant_dashboard.dart';
import 'package:joblagbe/app/modules/auth/views/login/_login.dart';
import 'package:joblagbe/app/modules/auth/views/register/views/pages/_register.dart';
import 'package:joblagbe/app/modules/dashboard/applicant/home/pages/_applicant_home.dart';
import 'package:joblagbe/app/modules/dashboard/applicant/jobs/pages/_applicant_jobs.dart';
import 'package:joblagbe/app/modules/dashboard/recruiter/add-job/pages/_add_job.dart';
import 'package:joblagbe/app/modules/dashboard/recruiter/applications/pages/_applications.dart';
import 'package:joblagbe/app/modules/dashboard/recruiter/jobs/controllers/_job_edit_controller.dart';
import 'package:joblagbe/app/modules/dashboard/recruiter/jobs/pages/_recruiter_jobs_edit.dart';
import 'package:joblagbe/app/modules/dashboard/recruiter/profile/pages/_recruiter_profile.dart';
import 'package:joblagbe/app/modules/dashboard/recruiter/wrapper/pages/_recruiter_dashbord_layout.dart';
import 'package:joblagbe/app/modules/dashboard/recruiter/home/pages/_recruiter_home.dart';
import 'package:joblagbe/app/modules/dashboard/recruiter/jobs/pages/_recruiter_jobs.dart';

import '../../modules/auth/controllers/_login_controller.dart';
import '../../modules/forgot_password/views/pages/_forgot_password.dart';
import '../../modules/landing/views/_landing_layout.dart';
import '../../modules/landing/views/_landing_page.dart';
import '../../modules/landing/views/categories/views/_categories.dart';

class AppRouter {
  static GoRouter router = GoRouter(
      initialLocation: '/',
      refreshListenable: Get.find<LoginController>().userRoleNotifier,
      routes: [
        // ✅ Landing Layout (Public, No Redirect)
        ShellRoute(
          builder: (context, state, child) => LandingLayout(child: child),
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

        // ✅ Auth Routes (Public)
        GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
        GoRoute(
            path: '/register',
            builder: (context, state) => const RegisterPage()),
        GoRoute(
            path: '/forgot-password',
            builder: (context, state) => const ForgotPasswordPage()),

        // ✅ Recruiter Dashboard (Protected)
        ShellRoute(
          builder: (context, state, child) =>
              RecruiterDashboardLayout(child: child),
          routes: [
            GoRoute(
              path: '/dashboard/recruiter/home',
              pageBuilder: (context, state) => _buildFadeTransition(
                state,
                const RecruiterHome(),
              ),
            ),
            GoRoute(
                path: '/dashboard/recruiter/jobs',
                pageBuilder: (context, state) => _buildFadeTransition(
                      state,
                      const RecruiterJobsPage(),
                    ),
                routes: [
                  GoRoute(
                    path: "edit/:jobId",
                    pageBuilder: (context, state) {
                      final jobId = state.pathParameters['jobId']!;
                      // Fetch job data using the jobId
                      Get.put(RecruiterJobEditController(jobId: jobId),tag: jobId);

                      return _buildFadeTransition(
                        state,
                        RecruiterJobEditPage(
                          jobId: jobId,
                        ),
                      );
                    },
                  )
                ]),
            GoRoute(
              path: '/dashboard/recruiter/add-job',
              pageBuilder: (context, state) => _buildFadeTransition(
                state,
                const AddJobPage(),
              ),
            ),
            GoRoute(
              path: '/dashboard/recruiter/applications',
              pageBuilder: (context, state) => _buildFadeTransition(
                state,
                const ApplicationsPage(),
              ),
            ),
            GoRoute(
              path: '/dashboard/recruiter/profile',
              pageBuilder: (context, state) => _buildFadeTransition(
                state,
                const RecruiterProfilePage(),
              ),
            ),
          ],
        ),

        // ✅ Applicant Dashboard (Protected)
        ShellRoute(
          builder: (context, state, child) =>
              ApplicantDashboardLayout(child: child),
          routes: [
            GoRoute(
              path: '/dashboard/applicant/home',
              builder: (context, state) => const ApplicantHome(),
            ),
            GoRoute(
              path: '/dashboard/applicant/jobs',
              builder: (context, state) => const ApplicantJobs(),
            ),

            GoRoute(
              path: '/dashboard/applicant/profile',
              builder: (context, state) => const ApplicantProfilePage(),
            ),
          ],
        ),
      ],
      errorBuilder: (context, state) => PageNotFound(),
      redirect: (context, state) {
        if (!Get.isRegistered<LoginController>()) return '/login';

        final authController = Get.find<LoginController>();

        // Wait for loading
        if (authController.isLoading.value) return null;

        // Allow users to visit the login and register pages freely
        if (state.matchedLocation == '/login' ||
            state.matchedLocation == '/register' ||
            state.matchedLocation == '/forgot-password') {
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
            return '/'; // Redirect unknown roles to home
        }
      });

  // Fade Transition
  static CustomTransitionPage _buildFadeTransition(
      GoRouterState state, Widget child) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }
}
