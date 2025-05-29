import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:joblagbe/app/data/models/_applicant_profile_model.dart';

class ApplicantProfileService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;
  final CollectionReference _applicantProfileCollection =
      FirebaseFirestore.instance.collection('db_applicantProfile');

  // This method is used to fetch the applicant profile data from Firestore
  Future<ApplicantProfileModel?> getApplicantProfileData(String uid) async {
    try {
      QuerySnapshot querySnapshot = await _applicantProfileCollection
          .where('userId', isEqualTo: uid)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final doc = querySnapshot.docs.first;
        return ApplicantProfileModel.fromJson(
            doc.data() as Map<String, dynamic>, doc.id);
      } else {
        return null;
      }
    } catch (e) {
      debugPrint('Error fetching applicant profile data: $e');
      return null;
    }
  }

  // Update applicant profile data
  Future<void> updateApplicantProfile(
      String docId, Map<String, dynamic> data) async {
    try {
      await _applicantProfileCollection.doc(docId).update(data);
      debugPrint("Profile updated successfully!");
    } catch (e) {
      throw Exception("Error updating applicant profile: $e");
    }
  }

  // Upload profile photo (stub, implement Firebase Storage as needed)
  Future<bool> uploadProfilePhoto(
      Uint8List imageBytes, String profileId) async {
    try {
      if (kIsWeb) {
        String uid = FirebaseAuth.instance.currentUser!.uid;
        debugPrint('Logged in user ID: $uid');

        final Reference ref = storage
            .ref()
            .child('images/${DateTime.now().millisecondsSinceEpoch}.jpg');

        final UploadTask uploadTask = ref.putData(imageBytes);
        final TaskSnapshot taskSnapshot = await uploadTask;
        final String downloadUrl = await taskSnapshot.ref.getDownloadURL();

        await _applicantProfileCollection.doc(profileId).update({
          'profilePhotoUrl': downloadUrl,
        });

        return true;
      } else {
        throw UnsupportedError("Invalid platform: Only supported on web");
      }
    } catch (e) {
      debugPrint('Error uploading image: $e');
      return false;
    }
  }

  Future<bool> uploadResume(Uint8List fileBytes, String profileId) async {
    try {
      if (kIsWeb) {
        String uid = FirebaseAuth.instance.currentUser!.uid;
        debugPrint('Logged in user ID: $uid');

        final Reference ref = storage
            .ref()
            .child('resumes/${DateTime.now().millisecondsSinceEpoch}.pdf');

        final UploadTask uploadTask = ref.putData(fileBytes);
        final TaskSnapshot taskSnapshot = await uploadTask;
        final String downloadUrl = await taskSnapshot.ref.getDownloadURL();

        await _applicantProfileCollection.doc(profileId).update({
          'resumeUrl': downloadUrl,
        });

        return true;
      } else {
        throw UnsupportedError("Invalid platform: Only supported on web");
      }
    } catch (e) {
      debugPrint('Error uploading resume: $e');
      return false;
    }
  }

  Future<bool> checkResumeExists(String profileId) async {
    try {
      final doc = await _applicantProfileCollection.doc(profileId).get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        return data['resumeUrl'] != null;
      }
      return false;
    } catch (e) {
      debugPrint('Error checking resume existence: $e');
      return false;
    }
  }
}
