import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:joblagbe/app/core/widgets/_custom_dialog.dart';
import 'package:joblagbe/app/modules/dashboard/recruiter/jobs/services/_recruiter_jobs_service.dart';

import '../../../../landing/views/categories/model/_jobs_model.dart';

class RecruiterJobsController extends GetxController {
  final RecruiterJobsService _recruiterJobsService = RecruiterJobsService();
  var jobs = Rxn<List<JobPost>>();
  var isLoading = true.obs;

  void fetchJobs(BuildContext context) async {
    try {
      isLoading(true);
      var fetchedJobs = await _recruiterJobsService.fetchJobs(10);
      jobs.value = fetchedJobs.isNotEmpty ? fetchedJobs : [];

      print("Fetched jobs: ${jobs.value}");
    } catch (err) {
      print("Error fetching jobs: $err");
      isLoading(false);
      // Handle error
      showCustomDialog(
        context: context,
        title: "Error",
        content: "Failed to fetch jobs. Please try again. ${err.toString()}",
        buttonText: "Okay",
        buttonColor: Colors.red,
      );
    } finally {
      isLoading(false);
    }
  }
}
