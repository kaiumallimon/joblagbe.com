import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:joblagbe/app/data/models/_recruiter_profile_model.dart';
import 'dart:html' as html;

class RecruiterProfileService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;

  /// 🔥 Function to fetch recruiter profile data from Firestore
  Future<RecruiterProfileModel> fetchRecruiterProfileData(String uid) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> querySnapshot = await firestore
          .collection('db_profile')
          .where('userId', isEqualTo: uid)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final doc = querySnapshot.docs.first;
        // print("Recruiter profile data: ${doc.data()}");
        return RecruiterProfileModel.fromMap(doc.data(), doc.id);
      } else {
        throw Exception('Recruiter profile not found');
      }
    } catch (e) {
      throw Exception('Error fetching recruiter profile: $e');
    }
  }

  /// 🔥 Function to update recruiter profile data in Firestore
  Future<void> updateRecruiterProfile(
      String profileId, Map<String, dynamic> updatedData) async {
    try {
      await firestore
          .collection('db_profile')
          .doc(profileId)
          .update(updatedData);
      print("Profile updated successfully!");
    } catch (e) {
      throw Exception("Error updating recruiter profile: $e");
    }
  }

  /// 🔥 Function to upload user profile picture in firebase storage
  Future<bool> uploadImage(Uint8List imageBytes, String profileId) async {
    try {
      if (kIsWeb) {
        String uid = await FirebaseAuth.instance.currentUser!.uid;

        print('Logged in user ID: $uid');
        final Reference ref = storage
            .ref()
            .child('images/${DateTime.now().millisecondsSinceEpoch}.jpg');

        // Upload the image bytes using `putData`
        final UploadTask uploadTask = ref.putData(imageBytes);

        // Wait for upload completion
        final TaskSnapshot taskSnapshot = await uploadTask;

        // Get download URL
        final String downloadUrl = await taskSnapshot.ref.getDownloadURL();

        // Update Firestore with the new profile picture URL
        await firestore.collection('db_profile').doc(profileId).update({
          'profilePicture': downloadUrl,
        });

        return true;
      } else {
        throw UnsupportedError("Invalid platform: Only supported on web");
      }
    } catch (e) {
      print('Error uploading image: $e');
      return false;
    }
  }

  
  // upload logo
  Future<bool> uploadLogo(Uint8List imageBytes, String profileId) async {
    try {
      if (kIsWeb) {
        String uid = await FirebaseAuth.instance.currentUser!.uid;

        print('Logged in user ID: $uid');
        final Reference ref = storage
            .ref()
            .child('images/${DateTime.now().millisecondsSinceEpoch}.jpg');

        // Upload the image bytes using `putData`
        final UploadTask uploadTask = ref.putData(imageBytes);

        // Wait for upload completion
        final TaskSnapshot taskSnapshot = await uploadTask;

        // Get download URL
        final String downloadUrl = await taskSnapshot.ref.getDownloadURL();

        // Update Firestore with the new profile picture URL
        await firestore.collection('db_profile').doc(profileId).update({
          'companyLogo': downloadUrl,
        });

        return true;
      } else {
        throw UnsupportedError("Invalid platform: Only supported on web");
      }
    } catch (e) {
      print('Error uploading image: $e');
      return false;
    }
  }
}
