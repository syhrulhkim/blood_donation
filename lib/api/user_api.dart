import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserAPI {
  final _db = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;

  Future<Map<String, dynamic>?> getUserData(userId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance.collection('user').doc(userId).get();
      if (snapshot.exists) {
        return snapshot.data();
      } else {
        return null;
      }
    } catch (error) {
      print("Error getting user data: $error");
      throw Exception("Failed to get user data");
    }
  }
}