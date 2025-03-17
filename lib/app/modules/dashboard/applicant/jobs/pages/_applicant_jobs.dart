import 'package:flutter/material.dart';
import 'package:joblagbe/app/core/theming/colors/_colors.dart';

class ApplicantJobs extends StatelessWidget {
  const ApplicantJobs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: const Text('Applicant Jobs'),
      ),
      body: Center(
        child: Text(
          'Welcome to the Applicant Jobs Page!',
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}
