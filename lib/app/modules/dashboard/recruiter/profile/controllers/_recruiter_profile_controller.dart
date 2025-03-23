import 'package:get/get.dart';

class RecruiterProfileController extends GetxController {
  RxBool isEditingMode = false.obs;

  void toggleEditingMode() {
    isEditingMode.value = !isEditingMode.value;
  }

  var genders = ["Male", "Female"].obs;
  var selectedGender = "Male".obs;

  var selectedDob = DateTime.now().obs;
}
