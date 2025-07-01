import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:joblagbe/app/core/theming/colors/_colors.dart';
import 'package:joblagbe/app/core/widgets/_custom_button.dart';
import 'package:joblagbe/app/modules/recruiter/controllers/_recruiter_profile_controller.dart';
import 'package:joblagbe/app/modules/recruiter/controllers/_recruiter_jobs_controller.dart';
import 'package:joblagbe/app/modules/recruiter/controllers/_recruiter_applications_controller.dart';
import 'package:joblagbe/app/data/models/_job_model.dart';
import 'package:joblagbe/app/data/models/_application_model.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class RecruiterHome extends StatelessWidget {
  const RecruiterHome({super.key});

  @override
  Widget build(BuildContext context) {
    final profileController = Get.put(RecruiterProfileController());
    final jobsController = Get.put(RecruiterJobsController());
    final applicationsController = Get.put(RecruiterApplicationController());

    // Fetch jobs and applications on load
    if (jobsController.jobs.isEmpty && !jobsController.isLoading.value) {
      jobsController.fetchJobs(context: context);
    }
    if (applicationsController.applications.isEmpty &&
        !applicationsController.isLoading.value) {
      applicationsController.fetchApplications();
    }

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Obx(() {
          final recruiter = profileController.profileData.value;
          final jobs = jobsController.jobs;
          final applications = applicationsController.applications;
          final isLoading = profileController.isLoading.value ||
              jobsController.isLoading.value ||
              applicationsController.isLoading.value;

          // Stats
          final totalJobs = jobs.length;
          final totalApplications = applications.length;
          // Applications per job
          final Map<String, int> appCountPerJob = {};
          for (final app in applications) {
            if (app.jobId != null) {
              appCountPerJob[app.jobId!] =
                  (appCountPerJob[app.jobId!] ?? 0) + 1;
            }
          }
          // Top 3 jobs with most applications
          final topJobs = jobs
              .where((job) => appCountPerJob.containsKey(job.id))
              .toList()
            ..sort((a, b) => (appCountPerJob[b.id!] ?? 0)
                .compareTo(appCountPerJob[a.id!] ?? 0));
          final top3Jobs = topJobs.take(3).toList();

          // Recent jobs (sorted by createdAt)
          final recentJobs = List<JobModel>.from(jobs)
            ..sort((a, b) => (b.createdAt?.millisecondsSinceEpoch ?? 0)
                .compareTo(a.createdAt?.millisecondsSinceEpoch ?? 0));
          final recentJobsList = recentJobs.take(3).toList();

          // Recent applications (sorted by createdAt)
          final recentApps = List<ApplicationProgressModel>.from(applications)
            ..sort((a, b) => (b.createdAt?.millisecondsSinceEpoch ?? 0)
                .compareTo(a.createdAt?.millisecondsSinceEpoch ?? 0));
          final recentAppsList = recentApps.take(3).toList();

          if (isLoading) {
            return const Center(child: CupertinoActivityIndicator());
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Welcome header
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 32,
                      backgroundImage: recruiter?.profilePictureUrl != null
                          ? NetworkImage(recruiter!.profilePictureUrl!)
                          : null,
                      child: recruiter?.profilePictureUrl == null
                          ? const Icon(Icons.person, size: 32)
                          : null,
                    ),
                    const SizedBox(width: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          recruiter?.name != null
                              ? 'Welcome, ${recruiter!.name}'
                              : 'Welcome, Recruiter',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        if (recruiter?.companyName != null)
                          Text(
                            recruiter!.companyName!,
                            style: const TextStyle(
                              fontSize: 16,
                              color: AppColors.darkBackground,
                            ),
                          ),
                        if (recruiter?.email != null)
                          Text(
                            recruiter!.email,
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.darkBackground,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                // Stats
                Row(
                  children: [
                    _statCard('Total Jobs', totalJobs.toString(), Icons.work),
                    const SizedBox(width: 20),
                    _statCard('Total Applications',
                        totalApplications.toString(), Icons.assignment),
                  ],
                ),
                const SizedBox(height: 32),
                // Top jobs with most applications
                if (top3Jobs.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Top Jobs (by Applications)',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),
                      Row(
                        children: top3Jobs.map((job) {
                          return Expanded(
                            child: _jobCard(job, appCountPerJob[job.id!] ?? 0),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                // Recent jobs
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Recently Posted Jobs',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    TextButton(
                      onPressed: () => context.go('/dashboard/recruiter/jobs'),
                      child: const Text('See all'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Column(
                  children:
                      recentJobsList.map((job) => _recentJobCard(job)).toList(),
                ),
                const SizedBox(height: 32),
                // Recent applications
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Recent Applications',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    TextButton(
                      onPressed: () =>
                          context.go('/dashboard/recruiter/applications'),
                      child: const Text('See all'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Column(
                  children: recentAppsList
                      .map((app) => _recentAppCard(app, jobs))
                      .toList(),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _statCard(String label, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.07),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.primary.withOpacity(0.15)),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primary, size: 32),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value,
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold)),
                Text(label,
                    style: const TextStyle(
                        fontSize: 14, color: AppColors.darkBackground)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _jobCard(JobModel job, int appCount) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withOpacity(0.15)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(job.title,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          Text('Applications: $appCount',
              style: const TextStyle(fontSize: 14, color: AppColors.primary)),
          const SizedBox(height: 8),
          Text('Deadline: ${DateFormat('yyyy-MM-dd').format(job.deadline)}',
              style: const TextStyle(
                  fontSize: 13, color: AppColors.darkBackground)),
        ],
      ),
    );
  }

  Widget _recentJobCard(JobModel job) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withOpacity(0.15)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              job.companyLogoUrl,
              width: 56,
              height: 56,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 56,
                height: 56,
                color: Colors.grey.shade200,
                child: Icon(Icons.image, color: Colors.grey),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(job.title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                Text(job.company,
                    style: const TextStyle(
                        fontSize: 14, color: AppColors.primary)),
                const SizedBox(height: 4),
                Text(
                    'Deadline: ${DateFormat('yyyy-MM-dd').format(job.deadline)}',
                    style: const TextStyle(
                        fontSize: 13, color: AppColors.darkBackground)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _recentAppCard(ApplicationProgressModel app, List<JobModel> jobs) {
    final job = jobs.firstWhereOrNull((j) => j.id == app.jobId);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withOpacity(0.15)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.assignment, color: AppColors.primary, size: 32),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(job?.title ?? '-',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                Text('Status: ${app.status.name}',
                    style: const TextStyle(
                        fontSize: 14, color: AppColors.primary)),
                if (app.createdAt != null)
                  Text(
                      'Applied: ${DateFormat('yyyy-MM-dd').format(app.createdAt!)}',
                      style: const TextStyle(
                          fontSize: 13, color: AppColors.darkBackground)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
