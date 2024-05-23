import 'package:cloud_firestore/cloud_firestore.dart';

class Appointment {
  final String? id;
  final String appointmentID;
  final DateTime appointmentDate;
  final String donorID;
  final String place;

  const Appointment({
    this.id,
    required this.appointmentID,
    required this.appointmentDate,
    required this.donorID,
    required this.place,
  });

  Appointment copyWith({
    String? id,
    String? appointmentID,
    DateTime? appointmentDate,
    String? donorID,
    String? place,
  }) {
    return Appointment(
      id: id ?? this.id,
      appointmentID: appointmentID ?? this.appointmentID,
      appointmentDate: appointmentDate ?? this.appointmentDate,
      donorID: donorID ?? this.donorID,
      place: place ?? this.place,
    );
  }

  toJson() {
    return {
      "appointmentID": appointmentID,
      "appointment_Date": appointmentDate,
      "donorID": donorID,
      "place": place,
    };
  }

  static Future<List<Appointment>> hospitalList() async {
    final _db = FirebaseFirestore.instance;
    List<Appointment> list = [];
    final snapshot = await _db.collection("appointment").get();
    final data =
        snapshot.docs.map((e) => Appointment.fromSnapshot(e)).toList();
    return list;
  }

  factory Appointment.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return Appointment(
      id: document.id,
      appointmentID: data["appointmentID"],
      appointmentDate: (data["appointment_Date"] as Timestamp).toDate(),
      donorID: data["donorID"],
      place: data["place"],
    );
  }
}
