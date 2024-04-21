import 'package:blood_donation/models/hospital.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MainAPI {
  final _db = FirebaseFirestore.instance;

  Future<List<Hospital>> allHospital() async {
    final snapshot = await _db.collection("hospital").get();
    final data = snapshot.docs.map((e) => Hospital.fromSnapshot(e)).toList();
    print("data : $data");
    return data;
  }
}