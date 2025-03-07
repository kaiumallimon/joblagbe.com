import 'package:flutter/material.dart';
import 'package:joblagbe/app/theming/colors/_colors.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Center(
          child: Text(
            'Landing Page',
            style: TextStyle(
              fontFamily: 'Inter',
              color: AppColors.black,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
