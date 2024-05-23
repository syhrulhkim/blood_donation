
import 'package:blood_donation/models/appointment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BookingAPI {
  final _db = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> appointmentList() async {
    final _db = FirebaseFirestore.instance;
    final snapshot = await _db.collection("appointment").get();

    List<Map<String, dynamic>> appointments = await Future.wait(snapshot.docs.map((doc) async {
      Map<String, dynamic> appointmentData = doc.data();
      appointmentData['id'] = doc.id;

      // Initialize nested data structures
      Map<String, dynamic> donorData = {};
      Map<String, dynamic> hospitalData = {};

      // Fetching donor data
      if (appointmentData['donorID'] != null && appointmentData['donorID'].isNotEmpty) {
        DocumentSnapshot donorSnapshot = await _db.collection("user").doc(appointmentData['donorID']).get();
        if (donorSnapshot.exists) {
          donorData = donorSnapshot.data() as Map<String, dynamic>;
          // print("donorData: $donorData");
        }
      }

      // Fetching hospital data
      if (appointmentData['place'] != null && appointmentData['place'].isNotEmpty) {
        DocumentSnapshot hospitalSnapshot = await _db.collection("hospital").doc(appointmentData['place']).get();
        if (hospitalSnapshot.exists) {
          hospitalData = hospitalSnapshot.data() as Map<String, dynamic>;
          // print("hospitalData: $hospitalData");
        }
      }

      // Embed donor and hospital data in the appointment data
      appointmentData['user'] = donorData;
      appointmentData['hospital'] = hospitalData;

      return appointmentData;
    }).toList());
    return appointments;
  }

  Future<String> getNextAppointmentID() async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await _db.collection("appointment").orderBy("appointmentID", descending: true).limit(1).get();
      if (snapshot.docs.isNotEmpty) {
        String latestID = snapshot.docs.first.data()["appointmentID"];
        int currentNumber = int.parse(latestID.substring(2));
        int nextNumber = currentNumber + 1;
        String nextID = "AP" + nextNumber.toString().padLeft(3, '0');
        return nextID;
      } else {
        return "AP001";
      }
    } catch (error) {
      print("Error getting next appointment ID: $error");
      throw Exception("Failed to get next appointment ID");
    }
  }

  Future<void> submitAppointment(DateTime appointmentDate, String userId, String hospitalID) async {
    try {
      String nextAppointmentID = await getNextAppointmentID();
      Appointment appointment = Appointment(
        appointmentID: nextAppointmentID,
        appointmentDate: appointmentDate,
        donorID: userId,
        place: hospitalID,
      );
      Map<String, dynamic> appointmentData = appointment.toJson();
      await _db.collection("appointment").doc(nextAppointmentID).set(appointmentData);
      await _db.collection("user").doc(userId).update({
        'donor_LatestDonate': appointmentDate.toIso8601String(),
        'donor_Availability': 'donated',
      });
      print("Appointment submitted successfully");
    } catch (error) {
      print("Error submitting appointment: $error");
      throw Exception("Failed to submit appointment");
    }
  }
}