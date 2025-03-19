import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddJobController extends GetxController {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final skillsController = TextEditingController();
  final locationController = TextEditingController();
  final tagsController = TextEditingController();

  var jobTypes = [
    'Full-time',
    'Part-time',
    'Internship',
  ].obs;

  var selectedJobType = 'Full-time'.obs;

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

  var selectedSalaryRange = '30k-40k'.obs;

  var experienceLevels = [
    'Fresher',
    '1-2 years',
    '2-5 years',
    '5+ years',
  ].obs;

  var selectedExperienceLevel = '2-5 years'.obs;

  var applicationDeadline = Rxn<DateTime>();

  var selectedPage = 0.obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    titleController.dispose();
    skillsController.dispose();
    locationController.dispose();
  }
}
