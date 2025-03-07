import 'package:go_router/go_router.dart';
import 'package:joblagbe/app/modules/landing/views/categories/views/_categories.dart';

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

          GoRoute(
            path: '/jobs',
            builder: (context, state) => const CategoriesPage(),
          ),
          // Add more landing pages if needed
        ],
      ),
    ],
  );
}
