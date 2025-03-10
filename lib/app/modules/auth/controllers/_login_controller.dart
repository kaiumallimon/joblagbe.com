import 'package:get/get.dart';

class LoginController extends GetxController {
  var selectedLoginClient = 0.obs;

  void setSelectedLoginClient(int index) {
    selectedLoginClient.value = index;
  }
}
