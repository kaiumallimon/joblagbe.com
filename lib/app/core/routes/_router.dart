import 'package:go_router/go_router.dart';

import '../../modules/landing/views/_landing_layout.dart';
import '../../modules/landing/views/_landing_page.dart';

class AppRouter {
  static GoRouter router = GoRouter(
    initialLocation: '/',
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
          // Add more landing pages if needed
        ],
      ),

      // Routes without Header (Login & Dashboard)
      // GoRoute(
      //   path: '/login',
      //   builder: (context, state) => const LoginPage(),
      // ),
      // GoRoute(
      //   path: '/dashboard',
      //   builder: (context, state) => const DashboardPage(),
      // ),
    ],
  );
}