
import 'package:cloud_firestore/cloud_firestore.dart';

class BookingAPI {
  final _db = FirebaseFirestore.instance;

  Future<String> getNextAppointmentID() async {
    try {
      // Query the Firestore collection to get the latest document
      QuerySnapshot<Map<String, dynamic>> snapshot =
          await _db.collection("appointment").orderBy("appointmentID", descending: true).limit(1).get();
      // Extract the ID of the latest document
      if (snapshot.docs.isNotEmpty) {
        String latestID = snapshot.docs.first.data()["appointmentID"];
        int currentNumber = int.parse(latestID.substring(2)); // Extract the numeric part and convert it to an integer
        int nextNumber = currentNumber + 1; // Increment the number
        String nextID = "AP" + nextNumber.toString().padLeft(3, '0'); // Pad the number with zeros and concatenate with prefix
        return nextID;
      } else {
        // If the collection is empty, start with AP001
        return "AP001";
      }
    } catch (error) {
      // Handle error
      print("Error getting next appointment ID: $error");
      throw Exception("Failed to get next appointment ID");
    }
  }

  // TODO
  Future<void> submitAppointment(hospital) async {
    try {
      String nextAppointmentID = await getNextAppointmentID(); 
      hospital = hospital.copyWith(hospitalID: nextAppointmentID); // Update hospital object with the new ID
      Map<String, dynamic> hospitalData = hospital.toJson();
      // Add the hospital data to a document named after the hospitalID within the "hospitals" collection
      await _db.collection("hospital").doc(nextAppointmentID).set(hospitalData);

      print("Hospital data submitted successfully");
    } catch (error) {
      print("Error submitting hospital data: $error");
      throw Exception("Failed to submit hospital data");
    }
  }
}