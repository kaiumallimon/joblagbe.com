import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:joblagbe/app/core/widgets/_custom_loading.dart';
import 'package:joblagbe/app/modules/dashboard/recruiter/add-job/models/_job_model.dart';
import 'package:joblagbe/app/modules/dashboard/recruiter/jobs/services/_recruiter_jobs_service.dart';

class ApplicantJobsController extends GetxController {
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
        time: Duration(milliseconds: 200));
  }

  // Function to filter jobs based on search query and selected chip

  Future<void> filterJobs() async {
    final query = searchQuery.value.trim().toLowerCase();
    if (query.isEmpty) {
      filteredJobs.assignAll(jobs);
      return;
    }

    isLoading(true);
    try {
      String currentUserId = FirebaseAuth.instance.currentUser!.uid;
      String postedBy = 'all';

      // if (selectedChip.value == 1) {
      //   postedBy = 'me';
      // } else if (selectedChip.value == 2) {
      //   postedBy = 'others';
      // }

      // Fetch full jobs list (or increase limit if needed)
      JobFetchingResponse response = await _recruiterJobsService.fetchJobs(
        limit: 1000, // fetch more so you can filter locally
        postedBy: currentUserId,
      );

      if (response.isSuccess && response.jobs != null) {
        List<JobModel> matchedJobs = response.jobs!.where((job) {
          return job.title.toLowerCase().contains(query);
          //  ||
          // job.company.toLowerCase().contains(query) ||
          // job.skills.any((skill) => skill.toLowerCase().contains(query)) ||
          // job.location.toLowerCase().contains(query) ||
          // job.tags.any((tag) => tag.toLowerCase().contains(query));
        }).toList();

        filteredJobs.assignAll(matchedJobs);
      } else {
        filteredJobs.clear();
      }
    } catch (e) {
      print("Error during local partial search: $e");
      filteredJobs.clear();
    } finally {
      isLoading(false);
    }
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
        // print("Last Document: ${_lastDocument?.data()}");
        hasMore(fetchedJobs.jobs?.length == limit);

        // Apply current filter to newly fetched jobs
        filterJobs();
      } else {
        if (!loadMore) {
          customDialog(
            "Error",
            fetchedJobs.message ?? "Failed to fetch jobs",
          );
        }
      }
    } catch (err) {
      print("Error fetching jobs: $err");
      if (!loadMore) {
        customDialog(
          "Error",
          "Failed to fetch jobs. Please try again. ${err.toString()}",
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
