import 'package:flutter/material.dart';
import 'package:joblagbe/app/core/theming/colors/_colors.dart';

class GradientBackground extends StatelessWidget {
  const GradientBackground({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment(-0.00, -1.00),
            end: Alignment(0, 1),
            colors: [AppColors.black, AppColors.darkPrimary],
          ),
        ));
  }
}