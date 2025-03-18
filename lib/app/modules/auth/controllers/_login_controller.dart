import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:joblagbe/app/core/widgets/_custom_loading.dart';
import 'package:joblagbe/app/core/widgets/_custom_dialog.dart';
import 'package:joblagbe/app/modules/auth/services/_login_services.dart';

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
      showCustomDialog(
        context: context,
        title: "Error",
        content: "Please fill all fields",
        buttonText: "Okay",
        onButtonPressed: () => Navigator.of(context).pop(),
        buttonColor: Colors.red,
      );
      return;
    }

    showCustomLoadingDialog(context: context);
    try {
      isLoading.value = true;
      final user = await LoginService().loginUser(email, password);

      String role = user['role'] ?? '';
      setUserRole(role);
      box.write('user_role', role);

      Navigator.of(context).pop(); // Close loading dialog

      if (role == 'Recruiter') {
        context.go('/dashboard/recruiter/home');
      } else if (role == 'Applicant') {
        context.go('/dashboard/applicant/home');
      } else if (role == 'Admin') {
        context.go('/dashboard/admin/home');
      } else {
        showCustomDialog(
          context: context,
          title: "Error",
          content: "Invalid user role.",
          buttonText: "Okay",
          onButtonPressed: () => Navigator.of(context).pop(),
          buttonColor: Colors.red,
        );
      }
    } catch (error) {
      Navigator.of(context).pop(); // Close loading dialog
      showCustomDialog(
        context: context,
        title: "Login Error",
        content: error.toString(),
        buttonText: "Okay",
        onButtonPressed: () => Navigator.of(context).pop(),
        buttonColor: Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    setUserRole('');
    box.remove('user_role');
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
