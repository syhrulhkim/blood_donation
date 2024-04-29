import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpApi {
  final _db = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;

  Future<void> signUpAPI(String email, String password) async {
    try {
      await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      print("Error signing up: $e");
      throw e; 
    }
  }
}
