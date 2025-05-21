import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:joblagbe/app/data/models/_applicant_profile_model.dart';

class ApplicantProfileService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
      print('Error fetching applicant profile data: $e');
      return null;
    }
  }
}
