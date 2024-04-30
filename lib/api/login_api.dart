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
      // Login successful
      print('Login successful: ${userCredential.user!.uid}');
    } catch (e) {
      // Login failed, handle error
      print('Login failed: $e');
    }
  }
}
