import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:joblagbe/app/modules/404/views/_404_notfound.dart';
import 'package:joblagbe/app/modules/auth/views/login/_login.dart';
import 'package:joblagbe/app/modules/auth/views/register/views/pages/_register.dart';
import 'package:joblagbe/app/modules/dashboard/recruiter/wrapper/pages/_recruiter_dashbord_layout.dart';
import 'package:joblagbe/app/modules/landing/views/categories/views/_categories.dart';
import 'package:joblagbe/app/modules/landing/views/_landing_layout.dart';
import 'package:joblagbe/app/modules/landing/views/_landing_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../modules/dashboard/applicant/wrapper/pages/_applicant_dashboard.dart';
import '../../modules/dashboard/recruiter/home/pages/_recruiter_home.dart';
import '../../modules/dashboard/recruiter/jobs/pages/_recruiter_jobs.dart';
import '../../modules/dashboard/recruiter/wrapper/pages/_recruiter_dashboard.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

class AppRouter {
  static GoRouter router = GoRouter(
    initialLocation: '/',
    navigatorKey: _rootNavigatorKey,
    routes: [
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

      // Auth Routes
      GoRoute(
        path: '/login',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/register',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const RegisterPage(),
      ),

      // Role-Based Dashboards
      ShellRoute(
        navigatorKey:
            GlobalKey<NavigatorState>(), // Separate navigator for recruiter
        builder: (context, state, child) {
          return RecruiterDashboardLayout(child: child);
        },
        routes: [
          GoRoute(
            path: '/dashboard/recruiter/home',
            builder: (context, state) => const RecruiterHome(),
            redirect: (context, state) => _redirectUser(context, 'Recruiter'),
          ),
          GoRoute(
            path: '/dashboard/recruiter/jobs',
            builder: (context, state) => const RecruiterJobsPage(),
          ),
          // GoRoute(
          //   path: '/dashboard/recruiter/profile',
          //   builder: (context, state) => const RecruiterProfilePage(),
          // ),
        ],
      ),
      GoRoute(
        path: '/dashboard/applicant',
        builder: (context, state) => const ApplicantDashboard(),
        redirect: (context, state) => _redirectUser(context, 'Applicant'),
      ),
      // GoRoute(
      //   path: '/dashboard/admin',
      //   builder: (context, state) => const AdminDashboard(),
      //   redirect: (context, state) => _redirectUser(context, 'Admin'),
      // ),
    ],
    errorBuilder: (context, state) => PageNotFound(),
  );

  // Redirect Function to Ensure Role-Based Access
  static Future<String?> _redirectUser(
      BuildContext context, String requiredRole) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return '/login'; // Redirect to login if not authenticated

    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('db_userAccounts')
          .doc(user.uid)
          .get();

      if (!userDoc.exists) return '/login';

      final userRole = userDoc.data()?['role'] ?? '';

      if (userRole == requiredRole) {
        return null; // Allow navigation
      } else {
        return '/'; // Redirect unauthorized users to home
      }
    } catch (e) {
      return '/login'; // Redirect on error
    }
  }
}
