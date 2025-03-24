import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:joblagbe/app/core/theming/colors/_colors.dart';
import 'package:joblagbe/app/core/widgets/_dashboard_appbar.dart';
import 'package:joblagbe/app/modules/dashboard/recruiter/jobs/controllers/_recruiter_jobs_controller.dart';

class RecruiterJobsPage extends StatelessWidget {
  const RecruiterJobsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final jobsController = Get.put(RecruiterJobsController());

    // Fetch jobs when the page is built
    if (jobsController.jobs.value == null) {
      jobsController.fetchJobs(context);
    }

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: dashboardAppbar('Explore/Manage Jobs'),
      body: Center(
        child: Text(
          'Welcome to the Recruiter Jobs Page!',
        ),
      ),
    );
  }
}
