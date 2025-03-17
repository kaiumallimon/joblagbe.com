import 'package:flutter/material.dart';
import 'package:joblagbe/app/core/theming/colors/_colors.dart';

class RecruiterHome extends StatelessWidget {
  const RecruiterHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: const Text('Recruiter Home'),
      ),
      body: Center(
        child: Text(
          'Welcome to the Recruiter Home!',
        ),
      ),
    );
  }
}
