import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:joblagbe/app/core/widgets/_custom_loading.dart';
import 'package:joblagbe/app/data/models/_applicant_profile_model.dart';
import 'package:joblagbe/app/data/models/_course_model.dart';
import 'package:joblagbe/app/data/models/_job_model.dart';
import 'package:joblagbe/app/data/services/_applicant_home_service.dart';

class ApplicantHomeController extends GetxController {
  final service = ApplicantHomeService();

  var isLoading = false.obs;
  var profile = Rxn<ApplicantProfileModel>();

  /* * Fetches the applicant profile data from the database.
   * If the user is not logged in, it shows an error dialog.
   * If the profile is successfully fetched, it updates the profile observable.
   * If there's an error during fetching, it shows an error dialog.
   */
  void fetchProfileData() {
    try {
      isLoading.value = true;
      final userId = FirebaseAuth.instance.currentUser?.uid;

      if (userId == null) {
        customDialog("Error", "User not logged in");
        return;
      }
      service.getApplicantProfile(userId).then((value) {
        profile.value = value;
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

  Rxn<List<Course>> availableCourses = Rxn<List<Course>>();

  void fetchAvailableCourses() {
    isLoading.value = true;
    try {
      service.fetchAvailableCourses().then((courses) {
        availableCourses.value = courses;
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
    fetchProfileData();
    fetchRecentlyAddedJobs();
    fetchAvailableCourses();
  }
}
