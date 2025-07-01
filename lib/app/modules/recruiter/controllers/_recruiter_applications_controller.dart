import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:joblagbe/app/data/models/_application_model.dart';
import 'package:joblagbe/app/data/services/_recruiter_applications_service.dart';

class RecruiterApplicationController extends GetxController {
  final services = RecruiterApplicationService();

  final applications = <ApplicationProgressModel>[].obs;
  var errorMessage = ''.obs;
  var isLoading = false.obs;

  void fetchApplications() {
    isLoading.value = true;
    services.getApplications().then((value) {
      applications.value = value;
      isLoading.value = false;
    }).catchError((error) {
      isLoading.value = false;
      errorMessage.value = 'Failed to fetch applications: $error';
      debugPrint(errorMessage.value);
    });
  }

  @override
  void onInit() {
    super.onInit();
    fetchApplications();
  }
}
