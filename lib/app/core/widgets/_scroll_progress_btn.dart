import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:joblagbe/app/core/theming/colors/_colors.dart';

import '../../modules/landing/controllers/_scroll_controller.dart';
import '_scroll_progress_painter.dart';

class CustomScrollPositionIndicatorButton extends StatelessWidget {
  const CustomScrollPositionIndicatorButton({
    super.key,
    required this.controller,
  });

  final ScrollControllerX controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return controller.progress.value == 0.0
          ? SizedBox.shrink()
          : MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {
                  controller.goToTop();
                },
                child: CustomPaint(
                  painter: ProgressCirclePainter(controller.progress.value),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.darkBackground),
                    child: Icon(Icons.arrow_upward,
                        color: AppColors.primary, size: 35),
                  ),
                ),
              ),
            );
    });
  }
}
