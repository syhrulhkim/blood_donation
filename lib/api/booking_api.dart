
import 'package:blood_donation/models/appointment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BookingAPI {
  final _db = FirebaseFirestore.instance;

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

  // TODO
  // Future<void> submitAppointment(Appointment appointment) async {
  //   try {
  //     String nextAppointmentID = await getNextAppointmentID();
  //     print("nextAppointmentID : ${nextAppointmentID}");
  //     appointment = appointment.copyWith(appointmentID: nextAppointmentID);
  //     Map<String, dynamic> appointmentData = appointment.toJson();

  //     await _db.collection("appointment").doc(nextAppointmentID).set(appointmentData);

  //     print("Hospital data submitted successfully");
  //   } catch (error) {
  //     print("Error submitting hospital data: $error");
  //     throw Exception("Failed to submit hospital data");
  //   }
  // }

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

      // Store the appointment in the "appointments" collection
      await _db.collection("appointment").doc(nextAppointmentID).set(appointmentData);

      // Update user information
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