import 'package:blood_donation/models/hospital.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MainAPI {
  final _db = FirebaseFirestore.instance;

  Future<List<Hospital>> allHospital() async {
    final snapshot = await _db.collection("hospital").get();
    final data = snapshot.docs.map((e) async {
      Hospital hospital = Hospital.fromSnapshot(e);
      QuerySnapshot bloodLevelSnapshot = await e.reference.collection("blood_level").get();
      hospital.bloodLevels = bloodLevelSnapshot.docs.map((doc) => BloodLevel.fromSnapshot(doc)).toList();
      return hospital;
    }).toList();

    return Future.wait(data);
  }
}