import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:blood_donation/models/user.dart';

class UserAPI {
  final _db = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;

  Future<List<Users>> allUser() async {
    final snapshot = await _db.collection("user").get();
    final data = snapshot.docs.map((e) => Users.fromSnapshot(e)).toList();
    return data;
  }

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