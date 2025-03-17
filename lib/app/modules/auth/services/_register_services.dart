import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> registerUser(
      String name, String email, String password, String role) async {
    try {
      // Create user in Firebase Auth
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Get the user ID
      String userId = userCredential.user!.uid;

      // Add user to Firestore without storing password
      await firestore.collection('db_userAccounts').doc(userId).set({
        'userId': userId, // Store the user ID for reference
        'name': name,
        'email': email,
        'role': role,
        'createdAt': FieldValue.serverTimestamp(), // Store creation timestamp
      });
    } on FirebaseAuthException catch (e) {
      throw Exception('${e.message}');
    } on FirebaseException catch (e) {
      throw Exception('Firestore error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}
