import 'package:cloud_firestore/cloud_firestore.dart';

class Hospital {
  final String? id;
  final String hospitalID;
  final String hospitalAddress;
  final String hospitalName;
  final String hospitalContact;
  final String hospitalImage;
  final String hospitalPoscode;
  List<BloodLevel> bloodLevels;

  Hospital({
    this.id,
    required this.hospitalID,
    required this.hospitalAddress,
    required this.hospitalName,
    required this.hospitalContact,
    required this.hospitalImage,
    required this.hospitalPoscode,
    required this.bloodLevels,
  });

  Hospital copyWith({
    String? id,
    String? hospitalID,
    String? hospitalAddress,
    String? hospitalName,
    String? hospitalContact,
    String? hospitalImage,
    String? hospitalPoscode,
    List<BloodLevel>? bloodLevels,
  }) {
    return Hospital(
      id: id ?? this.id,
      hospitalID: hospitalID ?? this.hospitalID,
      hospitalAddress: hospitalAddress ?? this.hospitalAddress,
      hospitalName: hospitalName ?? this.hospitalName,
      hospitalContact: hospitalContact ?? this.hospitalContact,
      hospitalImage: hospitalImage ?? this.hospitalImage,
      hospitalPoscode: hospitalPoscode ?? this.hospitalPoscode,
      bloodLevels: bloodLevels ?? this.bloodLevels,
    );
  }

  toJson() {
    return {
      "hospitalID": hospitalID,
      "hospital_Address": hospitalAddress,
      "hospital_Name": hospitalName,
      "hospital_Image": hospitalImage,
      "hospital_Contact": hospitalContact,
      "hospital_Poscode": hospitalPoscode,
    };
  }

  static Future<List<Hospital>> hospitalList() async {
    final _db = FirebaseFirestore.instance;
    final snapshot = await _db.collection("hospital").get();
    final List<Hospital> hospitals = [];

    for (final doc in snapshot.docs) {
      final hospital = Hospital.fromSnapshot(doc);
      final bloodLevelSnapshot = await doc.reference.collection("blood_level").get();
      hospital.bloodLevels = bloodLevelSnapshot.docs.map((doc) => BloodLevel.fromSnapshot(doc)).toList();
      hospitals.add(hospital);
    }

    return hospitals;
  }

  factory Hospital.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return Hospital(
      id: document.id,
      hospitalID: data["hospitalID"],
      hospitalAddress: data["hospital_Address"],
      hospitalName: data["hospital_Name"],
      hospitalContact: data["hospital_Contact"],
      hospitalImage: data["hospital_Image"],
      hospitalPoscode: data["hospital_Poscode"],
      bloodLevels: [], 
    );
  }
}

class BloodLevel {
  final String bloodType;
  final String percent;

  BloodLevel({
    required this.bloodType,
    required this.percent,
  });

  Map<String, dynamic> toJson() {
    return {
      'bloodType': bloodType,
      'percent': percent,
    };
  }

  factory BloodLevel.fromSnapshot(QueryDocumentSnapshot<Object?> document) {
    final data = document.data() as Map<String, dynamic>;
    return BloodLevel(
      bloodType: data['bloodType'],
      percent: data['percent'],
    );
  }
}
