// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:get_storage/get_storage.dart'; // For local storage
// import 'package:cloud_firestore/cloud_firestore.dart';

// class AuthState extends GetxController {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final box = GetStorage(); // Initialize GetStorage
//   var userRole = ''.obs;
//   var isLoading = true.obs; // Prevent redirection before loading
//   final userRoleNotifier =
//       ValueNotifier<String>(''); // ✅ Correctly initialize ValueNotifier

//   @override
//   void onInit() {
//     super.onInit();
//     _loadUserRole();
//   }

//   void _loadUserRole() async {
//     isLoading.value = true;

//     String? storedRole = box.read('user_role');
//     if (storedRole != null) {
//       setUserRole(storedRole);
//     }

//     isLoading.value = false;
//     print("User role loaded: $userRole");
//   }

//   Future<void> login(String email, String password) async {
//     try {
//       isLoading.value = true;
//       final userCredential = await _auth.signInWithEmailAndPassword(
//           email: email, password: password);

//       // 🔹 Fetch role from Firestore
//       String role = await getUserRoleFromFirestore(userCredential.user!.uid);

      
//     } catch (e) {
//       print("Login failed: $e");
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   Future<void> logout() async {
//     await _auth.signOut();
//     setUserRole('');
//     box.remove('user_role'); // ✅ Remove role from local storage
//   }

//   void setUserRole(String role) {
//     userRole.value = role;
//     userRoleNotifier.value = role;
//     userRoleNotifier.notifyListeners(); // ✅ Explicitly notify listeners
//   }
// }

// // 🔹 Fetch User Role from Firestore
// Future<String> getUserRoleFromFirestore(String userId) async {
//   try {
//     DocumentSnapshot userDoc = await FirebaseFirestore.instance
//         .collection('db_userAccounts')
//         .doc(userId)
//         .get();

//     if (userDoc.exists && userDoc.data() != null) {
//       return userDoc.get('role') ??
//           ''; // Assuming 'role' field exists in Firestore
//     }
//   } catch (e) {
//     print("Error fetching user role: $e");
//   }
//   return ''; // Return empty string if role not found
// }
