import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginApi {
  final _db = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;

  Future<void> loginAPI(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      print('Login successful: ${userCredential.user!.uid}');
    } catch (e) {
      print('Login failed: $e');
    }
  }

  Future<Object?> findUserByEmail(String email) async {
    try {
      QuerySnapshot querySnapshot = await _db.collection('user').where('donor_Email', isEqualTo: email).get();
      if (querySnapshot.docs.isNotEmpty) {
        var userData = querySnapshot.docs.first.data();
        print('User found: $userData');
        return userData;
      } else {
        print('User not found');
        return null; // Return null if user is not found
      }
    } catch (e) {
      print('Error finding user: $e');
      return null; // Return null in case of error
    }
  }
}
