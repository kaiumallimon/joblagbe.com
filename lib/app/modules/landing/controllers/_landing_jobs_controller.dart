import 'package:get/get.dart';
import 'package:joblagbe/app/core/widgets/_custom_loading.dart';
import 'package:joblagbe/app/data/models/_job_model.dart';
import 'package:joblagbe/app/data/services/_applicant_home_service.dart';

class LandingJobsController extends GetxController {
  final service = ApplicantHomeService();

  var isLoading = false.obs;
  Rxn<List<JobModel>> recentlyAddedJobs = Rxn<List<JobModel>>();

  void fetchRecentlyAddedJobs() {
    isLoading.value = true;
    try {
      service.getRecentlyAddedJobs().then((jobs) {
        recentlyAddedJobs.value = jobs;
        isLoading.value = false;
      }).catchError((error) {
        isLoading.value = false;
        customDialog("Error", error.toString());
      });
    } catch (error) {
      isLoading.value = false;
      customDialog("Error", error.toString());
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchRecentlyAddedJobs();
  }
}
