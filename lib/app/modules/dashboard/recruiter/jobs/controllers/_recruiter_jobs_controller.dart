import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:joblagbe/app/core/widgets/_custom_dialog.dart';
import 'package:joblagbe/app/modules/dashboard/recruiter/add-job/models/_job_model.dart';
import 'package:joblagbe/app/modules/dashboard/recruiter/jobs/services/_recruiter_jobs_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RecruiterJobsController extends GetxController {
  final RecruiterJobsService _recruiterJobsService = RecruiterJobsService();
  var jobs = <JobModel>[].obs; // All jobs
  var filteredJobs = <JobModel>[].obs; // Filtered jobs
  var isLoading = false.obs;
  var hasMore = true.obs;
  final int limit = 10;
  var searchQuery = ''.obs;
  DocumentSnapshot? _lastDocument;

  @override
  void onInit() {
    super.onInit();
    // Update filtered jobs whenever search query changes
    debounce(searchQuery, (_) => filterJobs(),
        time: Duration(milliseconds: 500));
  }

  // Filter jobs based on search query
  void filterJobs() {
    if (searchQuery.value.isEmpty) {
      filteredJobs.assignAll(jobs);
      return;
    }

    final query = searchQuery.value.toLowerCase();
    filteredJobs.assignAll(jobs.where((job) {
      return job.title.toLowerCase().contains(query) ||
          job.company.toLowerCase().contains(query) ||
          job.skills.any((skill) => skill.toLowerCase().contains(query)) ||
          job.location.toLowerCase().contains(query) ||
          job.tags.any((tag) => tag.toLowerCase().contains(query));
    }).toList());
  }

  Future<void> fetchJobs({
    bool loadMore = false,
    required BuildContext context,
    bool forceRefresh = false,
  }) async {
    if (isLoading.value || (loadMore && !hasMore.value)) return;

    try {
      isLoading(true);

      if (!loadMore || forceRefresh) {
        jobs.clear();
        filteredJobs.clear();
        _lastDocument = null;
        hasMore(true);
      }

      String currentUserId = FirebaseAuth.instance.currentUser!.uid;

      JobFetchingResponse fetchedJobs = await _recruiterJobsService.fetchJobs(
        limit: limit,
        lastDoc: _lastDocument,
        postedBy: currentUserId,
      );

      if (fetchedJobs.isSuccess) {
        jobs.addAll(fetchedJobs.jobs ?? []);
        _lastDocument = fetchedJobs.lastDocument;
        hasMore(fetchedJobs.jobs?.length == limit);

        // Apply current filter to newly fetched jobs
        filterJobs();
      } else {
        if (!loadMore) {
          showCustomDialog(
            context: context,
            title: "Error",
            content: fetchedJobs.message ?? "Failed to fetch jobs",
            buttonText: "Okay",
            buttonColor: Colors.red,
          );
        }
      }
    } catch (err) {
      print("Error fetching jobs: $err");
      if (!loadMore) {
        showCustomDialog(
          context: context,
          title: "Error",
          content: "Failed to fetch jobs. Please try again. ${err.toString()}",
          buttonText: "Okay",
          buttonColor: Colors.red,
        );
      }
    } finally {
      isLoading(false);
    }
  }

  void refreshCurrentPage(BuildContext context) {
    fetchJobs(context: context, forceRefresh: true);
  }

  var selectedJob = Rxn<JobModel>();

  void setSelectedJob(JobModel? job) {
    selectedJob.value = job;
  }

  var hoveredJobIndex = (-1).obs;

  void setHoveredJobIndex(int index) {
    hoveredJobIndex.value = index;
  }
}
