import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:joblagbe/app/modules/auth/views/_login.dart';
import 'package:joblagbe/app/modules/landing/views/categories/views/_categories.dart';

import '../../modules/landing/views/_landing_layout.dart';
import '../../modules/landing/views/_landing_page.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

class AppRouter {
  static GoRouter router = GoRouter(
    initialLocation: '/',
    navigatorKey: _rootNavigatorKey, // Set global navigator key
    routes: [
      // ShellRoute to keep the header for landing pages
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

      // Auth route for login and signup (force root navigation)
      GoRoute(
        path: '/login',
        parentNavigatorKey: _rootNavigatorKey, // Ensures visibility in URL
        builder: (context, state) => const LoginPage(),
      ),
    ],
  );
}
