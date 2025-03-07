import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:joblagbe/app/modules/landing/views/sections/header/_header.dart';
import 'package:joblagbe/app/core/theming/colors/_colors.dart';

import '../controllers/_scroll_controller.dart';

class LandingLayout extends StatelessWidget {
  final Widget child;
  const LandingLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    Get.put(ScrollControllerX());

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Sticky Header
            const Header(),

            // Content Area
            Expanded(
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}
