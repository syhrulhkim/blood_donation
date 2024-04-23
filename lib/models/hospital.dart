import 'package:cloud_firestore/cloud_firestore.dart';

class Hospital {
  final String? id;
  final String hospitalID;
  final String criticalBloodId;
  final String hospitalAddress;
  final String hospitalName;
  final String hospitalContact;
  final String hospitalImage;

  const Hospital({
    this.id,
    required this.hospitalID,
    required this.criticalBloodId,
    required this.hospitalAddress,
    required this.hospitalName,
    required this.hospitalContact,
    required this.hospitalImage,
  });

  Hospital copyWith({
    String? id,
    String? hospitalID,
    String? criticalBloodId,
    String? hospitalAddress,
    String? hospitalName,
    String? hospitalContact,
    String? hospitalImage,
  }) {
    return Hospital(
      id: id ?? this.id,
      hospitalID: hospitalID ?? this.hospitalID,
      criticalBloodId: criticalBloodId ?? this.criticalBloodId,
      hospitalAddress: hospitalAddress ?? this.hospitalAddress,
      hospitalName: hospitalName ?? this.hospitalName,
      hospitalContact: hospitalContact ?? this.hospitalContact,
      hospitalImage: hospitalImage ?? this.hospitalImage,
    );
  }

  toJson() {
    return {
      "hospitalID": hospitalID,
      "critical_bloodID": criticalBloodId,
      "hospital_Address": hospitalAddress,
      "hospital_Name": hospitalName,
      "hospital_Image": hospitalImage,
      "hospital_Contact": hospitalContact,
    };
  }

  static Future<List<Hospital>> hospitalList() async {
    final _db = FirebaseFirestore.instance;
    List<Hospital> list = [];
    final snapshot = await _db.collection("hospital").get();
    final data =
        snapshot.docs.map((e) => Hospital.fromSnapshot(e)).toList();
    return list;
  }

  factory Hospital.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return Hospital(
      id: document.id,
      hospitalID: data["hospitalID"],
      criticalBloodId: data["critical_bloodID"],
      hospitalAddress: data["hospital_Address"],
      hospitalName: data["hospital_Name"],
      hospitalContact: data["hospital_Contact"],
      hospitalImage: data["hospital_Image"],
    );
  }
}
