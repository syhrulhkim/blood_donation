import 'package:cloud_firestore/cloud_firestore.dart';

class Hospital {
  final String? id;
  final String hospitalID;
  final String criticalBloodId;

  const Hospital ({
    this.id,
    required this.hospitalID,
    required this.criticalBloodId,
  });

  toJson(){
    return {"hospitalID" : hospitalID, "critical_bloodID": criticalBloodId};
  }
  

  static Future<List<Hospital>> hospitalList() async{
    final _db = FirebaseFirestore.instance;
    List<Hospital> list = [];
    final snapshot = await _db.collection("hospital").get();
    final data = snapshot.docs.map((e) => Hospital.fromSnapshot(e)).toList();
    print("data : $data");
    print("hospitalList");
    return list;
  }

  factory Hospital.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document){
    final data = document.data()!; 
    return Hospital(
      id: document.id,
      hospitalID: data["hospitalID"], 
      criticalBloodId: data["critical_bloodID"],
    );
  }
}