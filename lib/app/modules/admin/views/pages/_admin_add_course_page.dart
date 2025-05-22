import 'package:flutter/material.dart';
import 'package:joblagbe/app/core/theming/colors/_colors.dart';
import 'package:joblagbe/app/core/widgets/_dashboard_appbar.dart';

class AdminAddCourse extends StatelessWidget {
  const AdminAddCourse({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: dashboardAppbar('Add Course'),
      body: const Center(
        child: Text('Add Course'),
      ),
    );
  }
}
