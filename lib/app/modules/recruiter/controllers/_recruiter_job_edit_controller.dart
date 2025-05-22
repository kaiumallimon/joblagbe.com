import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:joblagbe/app/data/models/_job_model.dart';
import 'package:joblagbe/app/data/models/_mcq_model.dart';
import 'package:joblagbe/app/data/services/_recruiter_jobs_service.dart';

class RecruiterJobEditController extends GetxController {
  RecruiterJobEditController({required this.jobId});

  final String jobId;
  final selectedJob = Rxn<JobModel>();

  final isLoading = true.obs; // <-- Add this

  // Controllers
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final skillsController = TextEditingController();
  final locationController = TextEditingController();
  final tagsController = TextEditingController();

  // Dropdowns
  var jobTypes = ['Full-time', 'Part-time', 'Internship'].obs;
  var selectedJobType = ''.obs;

  var salaryRange = [
    '0-10k',
    '10k-20k',
    '20k-30k',
    '30k-40k',
    '40k-50k',
    '50k-60k',
    '60k-70k',
    '70k-80k',
    '80k-90k',
    '90k-100k',
    '100k+',
  ].obs;
  var selectedSalaryRange = ''.obs;

  var experienceLevels = ['Fresher', '1-2 years', '2-5 years', '5+ years'].obs;
  var selectedExperienceLevel = ''.obs;

  var applicationDeadline = DateTime.now().obs;
  RxList<MCQModel> mcqList = <MCQModel>[].obs;
  RxInt passMark = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchJob();
  }

  @override
  void onClose() {
    // Dispose all controllers
    titleController.dispose();
    descriptionController.dispose();
    skillsController.dispose();
    locationController.dispose();
    tagsController.dispose();

    // Reset state
    selectedJob.value = null;
    selectedJobType.value = '';
    selectedSalaryRange.value = '';
    selectedExperienceLevel.value = '';
    isLoading.close(); // clean up the Rx variable

    super.onClose();
  }

  void fetchJob() async {
    isLoading.value = true; // start loading
    try {
      final job = await RecruiterJobsService().getJobById(jobId);
      // final mcq = await RecruiterJobsService().getMCQListByJobId(jobId);
      if (job != null) {
        selectedJob.value = job;
        titleController.text = job.title;
        descriptionController.text = job.description;
        skillsController.text = job.skills.join(', ');
        locationController.text = job.location;
        tagsController.text = job.tags.join(', ');

        selectedJobType.value = job.jobType;
        selectedSalaryRange.value = job.salaryRange;
        selectedExperienceLevel.value = job.experienceLevel;
        applicationDeadline.value = job.deadline;
        // mcqList.value = mcq;
        // passMark.value = mcq.isNotEmpty ? mcq[0].passMark : 0;
      } else {
        // _showError("Error",'Job not found');
      }
    } catch (e) {
      // _showError("Error",'Failed to fetch job details');
    } finally {
      isLoading.value = false; // stop loading
    }
  }

  void updateJob(BuildContext context) async {
  isLoading.value = true;

  try {
    // create job
    JobModel updatedJob = JobModel(
      id: jobId,
      title: titleController.text.trim(),
      description: descriptionController.text.trim(),
      skills: skillsController.text.trim().split(',').map((e) => e.trim()).toList(),
      location: locationController.text.trim(),
      tags: tagsController.text.trim().split(',').map((e) => e.trim()).toList(),
      jobType: selectedJobType.value,
      salaryRange: selectedSalaryRange.value,
      experienceLevel: selectedExperienceLevel.value,
      deadline: applicationDeadline.value,
      createdAt: selectedJob.value!.createdAt,
      company: selectedJob.value!.company,
      creatorId: selectedJob.value!.creatorId,
      companyLogoUrl: selectedJob.value!.companyLogoUrl,
    );

    await RecruiterJobsService().updateJob(updatedJob);

    if (!context.mounted) return;

    // ✅ Show dialog first
    await AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      animType: AnimType.rightSlide,
      title: 'Success',
      desc: "Job updated successfully!",
      btnOkOnPress: () {},
    ).show();

    // ✅ Then navigate
    if (context.mounted) context.go('/dashboard/recruiter/jobs');

  } catch (e) {
    print("🔥 Error: $e");
    if (context.mounted) {
      await AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        title: "Error",
        desc: "Failed to update job.",
        btnOkOnPress: () {},
      ).show();
    }
  } finally {
    isLoading.value = false;
  }
}

}
