import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:joblagbe/app/core/widgets/_custom_loading.dart';
import 'package:joblagbe/app/data/services/_login_services.dart';
import 'package:joblagbe/app/modules/dashboard/applicant/controllers/_applicant_profile_controller.dart';
import 'dart:html' as html;
import '../../dashboard/recruiter/controllers/_recruiter_profile_controller.dart';

class LoginController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final box = GetStorage(); // Local storage
  final userRole = ''.obs;
  final isLoading = false.obs;
  final userRoleNotifier = ValueNotifier<String>('');

  // Form controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    _loadUserRole();
  }

  void _loadUserRole() {
    isLoading.value = true;
    String? storedRole = box.read('user_role');
    if (storedRole != null) {
      setUserRole(storedRole);
    }
    isLoading.value = false;
  }

  bool validateEmail(String email) => email.isNotEmpty;
  bool validatePassword(String password) => password.isNotEmpty;

  void clearFields() {
    emailController.clear();
    passwordController.clear();
  }

  Future<void> login(BuildContext context) async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (!validateEmail(email) || !validatePassword(password)) {
      customDialog(
        "Error",
        "Please fill all fields",
      );
      return;
    }

    showCustomLoadingDialog();
    try {
      isLoading.value = true;
      clearFields();
      final user = await LoginService().loginUser(email, password);

      String role = user['role'] ?? '';
      setUserRole(role);
      box.write('user_role', role);

      Navigator.of(context).pop(); // Close loading dialog

      if (role == 'Recruiter') {
        context.go('/dashboard/recruiter/home');

        // load recruiter profile data
        Get.put(RecruiterProfileController());
      } else if (role == 'Applicant') {
        context.go('/dashboard/applicant/home');
        // load applicant profile data
        Get.put(ApplicantProfileController());
      } else if (role == 'Admin') {
        context.go('/dashboard/admin/home');
      } else {
        customDialog(
          "Error",
          "Invalid user role.",
        );
      }
    } catch (error) {
      Navigator.of(context).pop(); // Close loading dialog
      customDialog(
        "Login Error",
        error.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    setUserRole('');
    box.remove('user_role');
    html.window.location.reload();
  }

  void setUserRole(String role) {
    userRole.value = role;
    userRoleNotifier.value = role;
    print("User role set: $role");
    userRoleNotifier.notifyListeners();
  }

  // Future<String> _getUserRoleFromFirestore(String userId) async {
  //   try {
  //     DocumentSnapshot userDoc = await FirebaseFirestore.instance
  //         .collection('db_userAccounts')
  //         .doc(userId)
  //         .get();

  //     if (userDoc.exists && userDoc.data() != null) {
  //       return userDoc.get('role') ?? '';
  //     }
  //   } catch (e) {
  //     print("Error fetching user role: $e");
  //   }
  //   return '';
  // }
}
