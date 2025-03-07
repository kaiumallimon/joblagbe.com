import 'package:go_router/go_router.dart';

import '../modules/landing/views/_landing.dart';

class AppRouter {
  static GoRouter router = GoRouter(initialLocation: '/', routes: [
    GoRoute(
        path: '/',
        builder: (context, state) {
          return const LandingPage();
        }),
  ]);
}
