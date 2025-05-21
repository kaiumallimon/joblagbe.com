import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RoutingEffects{
  static CustomTransitionPage buildFadeTransition(
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