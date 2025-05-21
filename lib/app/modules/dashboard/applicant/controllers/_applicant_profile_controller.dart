import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:joblagbe/app/data/models/_applicant_profile_model.dart';
import 'package:joblagbe/app/data/services/_applicant_profile_services.dart';

class ApplicantProfileController extends GetxController {
  Rxn<ApplicantProfileModel> applicantProfileData =
      Rxn<ApplicantProfileModel>();
  ApplicantProfileService service = ApplicantProfileService();
  RxBool isUploading = false.obs;
  RxBool isLoading = true.obs;

  void fetchApplicantProfileData() async {
    isLoading.value = true;
    String uid = FirebaseAuth.instance.currentUser!.uid;
    var response = await service.getApplicantProfileData(uid);
    if (response != null) {
      applicantProfileData.value = response;
      update();
      isLoading.value = false;
      print('Applicant profile data fetched successfully');
      print('Name: ${applicantProfileData.value!.fullName}');
    } else {
      isLoading.value = false;
      print('No data found for the given UID');
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchApplicantProfileData();
  }
}
