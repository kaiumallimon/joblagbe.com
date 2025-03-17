import 'package:flutter/material.dart';
import 'package:joblagbe/app/core/theming/colors/_colors.dart';

class ApplicantHome extends StatelessWidget {
  const ApplicantHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: const Text('Applicant Home'),
      ),
      body: Center(
        child: Text(
          'Welcome to the Applicant Home Page!',
        ),
      ),
    );
  }
}
