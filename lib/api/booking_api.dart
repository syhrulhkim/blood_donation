
import 'package:blood_donation/models/appointment.dart';
import 'package:intl/intl.dart';
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
        }
      }

      // Fetching hospital data
      if (appointmentData['place'] != null && appointmentData['place'].isNotEmpty) {
        DocumentSnapshot hospitalSnapshot = await _db.collection("hospital").doc(appointmentData['place']).get();
        if (hospitalSnapshot.exists) {
          hospitalData = hospitalSnapshot.data() as Map<String, dynamic>;
        }
      }

      // Embed donor and hospital data in the appointment data
      appointmentData['user'] = donorData;
      appointmentData['hospital'] = hospitalData;

      // Convert "appointment_Date" to DateTime if it is a Timestamp
      if (appointmentData['appointment_Date'] != null && appointmentData['appointment_Date'] is Timestamp) {
        Timestamp appointmentTimestamp = appointmentData['appointment_Date'];
        appointmentData['appointment_Date'] = appointmentTimestamp.toDate();
      }

      return appointmentData;
    }).toList());

    // Sort appointments by "appointment_Date"
    appointments.sort((a, b) {
      DateTime dateA = a['appointment_Date'];
      DateTime dateB = b['appointment_Date'];
      return dateA.compareTo(dateB);
    });

    return appointments;
  }

  Future<List<Map<String, dynamic>>> appointmentListUser(String userId) async {
    final _db = FirebaseFirestore.instance;
    final snapshot = await _db.collection("appointment").where("donorID", isEqualTo: userId).get();

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
        }
      }

      // Fetching hospital data
      if (appointmentData['place'] != null && appointmentData['place'].isNotEmpty) {
        DocumentSnapshot hospitalSnapshot = await _db.collection("hospital").doc(appointmentData['place']).get();
        if (hospitalSnapshot.exists) {
          hospitalData = hospitalSnapshot.data() as Map<String, dynamic>;
        }
      }

      // Embed donor and hospital data in the appointment data
      appointmentData['user'] = donorData;
      appointmentData['hospital'] = hospitalData;

      // Convert "appointment_Date" to DateTime if it is a Timestamp
      if (appointmentData['appointment_Date'] != null && appointmentData['appointment_Date'] is Timestamp) {
        Timestamp appointmentTimestamp = appointmentData['appointment_Date'];
        appointmentData['appointment_Date'] = appointmentTimestamp.toDate();
      }

      return appointmentData;
    }));

    // Sort appointments by "appointment_Date"
    appointments.sort((a, b) {
      DateTime dateA = a['appointment_Date'];
      DateTime dateB = b['appointment_Date'];
      return dateA.compareTo(dateB);
    });

    return appointments;
  }


  Future<List<Map<String, dynamic>>> appointmentListFuture(String userId) async {
    final _db = FirebaseFirestore.instance;
    final snapshot = await _db.collection("appointment").where('donorID', isEqualTo: userId).get();

    DateTime today = DateTime.now();

    List<Map<String, dynamic>> appointments = await Future.wait(snapshot.docs.map((doc) async {
      Map<String, dynamic> appointmentData = doc.data();
      appointmentData['id'] = doc.id;

      // Fetching user data (only if donorID matches)
      if (appointmentData['donorID'] != null && appointmentData['donorID'] == userId) {
        DocumentSnapshot donorSnapshot = await _db.collection("user").doc(userId).get();
        if (donorSnapshot.exists) {
          Map<String, dynamic> donorData = donorSnapshot.data() as Map<String, dynamic>;
          appointmentData['user'] = donorData['address'] ?? {};
        } else {
          print('User document not found for donor ID: ${appointmentData['donorID']}');
        }
      }

      // Fetching hospital data
      if (appointmentData['place'] != null && appointmentData['place'].isNotEmpty) {
        DocumentSnapshot hospitalSnapshot = await _db.collection("hospital").doc(appointmentData['place']).get();
        if (hospitalSnapshot.exists) {
          appointmentData['hospital'] = hospitalSnapshot.data() as Map<String, dynamic>;
        } else {
          print('Hospital document not found for place: ${appointmentData['place']}');
        }
      }

      // Convert "appointment_Date" to DateTime if it is a Timestamp
      if (appointmentData['appointment_Date'] != null && appointmentData['appointment_Date'] is Timestamp) {
        Timestamp appointmentTimestamp = appointmentData['appointment_Date'];
        DateTime appointmentDateTime = appointmentTimestamp.toDate();
        appointmentData['appointment_Date'] = appointmentDateTime;
      } else {
        print('Invalid or missing appointment date for document ID: ${doc.id}');
      }

      return appointmentData;
    }).toList());

    // Filter and sort appointments by "appointment_Date"
    appointments = appointments.where((appointment) {
      if (appointment['appointment_Date'] == null) {
        print('Filtering out document ID: ${appointment['id']} due to missing appointment date');
        return false;
      }
      DateTime appointmentDate = appointment['appointment_Date'];
      bool isOnward = appointmentDate.isAfter(today) || appointmentDate.isAtSameMomentAs(today);
      print('Appointment ID: ${appointment['id']}, Date: $appointmentDate, Is Onward: $isOnward');
      return isOnward;
    }).toList();

    // Sort appointments by "appointment_Date"
    appointments.sort((a, b) {
      DateTime dateA = a['appointment_Date'];
      DateTime dateB = b['appointment_Date'];
      return dateA.compareTo(dateB);
    });

    print('Filtered and sorted appointments: $appointments');

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