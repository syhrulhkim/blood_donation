import 'package:blood_donation/models/hospital.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HospitalAPI {
  final _db = FirebaseFirestore.instance;

  Future<String> getNextHospitalID() async {
    try {
      // Query the Firestore collection to get the latest document
      QuerySnapshot<Map<String, dynamic>> snapshot =
          await _db.collection("hospital").orderBy("hospitalID", descending: true).limit(1).get();
      // Extract the ID of the latest document
      if (snapshot.docs.isNotEmpty) {
        String latestID = snapshot.docs.first.data()["hospitalID"];
        int currentNumber = int.parse(latestID.substring(2)); // Extract the numeric part and convert it to an integer
        int nextNumber = currentNumber + 1; // Increment the number
        String nextID = "HP" + nextNumber.toString().padLeft(3, '0'); // Pad the number with zeros and concatenate with prefix
        return nextID;
      } else {
        // If the collection is empty, start with HP001
        return "HP001";
      }
    } catch (error) {
      // Handle error
      print("Error getting next hospital ID: $error");
      throw Exception("Failed to get next hospital ID");
    }
  }

  Future<void> submitHospital(Hospital hospital) async {
    try {
      String nextHospitalID = await getNextHospitalID();
      hospital = hospital.copyWith(hospitalID: nextHospitalID);
      Map<String, dynamic> hospitalData = hospital.toJson();
      await _db.collection("hospital").doc(nextHospitalID).set(hospitalData);

      for (var i = 0; i < hospital.bloodLevels.length; i++) {
        var eachBlood = hospital.bloodLevels[i];
        await addBloodLevel(nextHospitalID, eachBlood);
      }

      print("Hospital data submitted successfully");
    } catch (error) {
      print("Error submitting hospital data: $error");
      throw Exception("Failed to submit hospital data");
    }
  }

  Future<void> addBloodLevel(String hospitalID, BloodLevel bloodLevel) async {
    try {
      await _db.collection('hospital').doc(hospitalID).collection('blood_level').doc(bloodLevel.bloodType).set(bloodLevel.toJson());
      print("Blood level added successfully");
    } catch (error) {
      print("Error adding blood level: $error");
      throw Exception("Failed to add blood level");
    }
  }

  Future<void> updateHospital(Hospital hospital) async {
    try {
      Map<String, dynamic> hospitalData = hospital.toJson();
      await _db.collection("hospital").doc(hospital.hospitalID).update(hospitalData);
      
      for (var i = 0; i < hospital.bloodLevels.length; i++) {
        var bloodLevel = hospital.bloodLevels[i];
        await updateBloodLevel(hospital.hospitalID, bloodLevel);
      }
      print("Hospital data updated successfully");
    } catch (error) {
      print("Error updating hospital data: $error");
      throw Exception("Failed to update hospital data");
    }
  }

  Future<void> updateBloodLevel(String hospitalID, BloodLevel bloodLevel) async {
    try {
      await _db.collection('hospital').doc(hospitalID).collection('blood_level').doc(bloodLevel.bloodType).update(bloodLevel.toJson());
      print("Blood level updated successfully");
    } catch (error) {
      print("Error updating blood level: $error");
      throw Exception("Failed to update blood level");
    }
  }

  Future<void> deleteHospital(String hospitalID) async {
    try {
      await _db.collection("hospital").doc(hospitalID).delete();
      print("Hospital deleted successfully");
    } catch (error) {
      print("Error deleting hospital: $error");
      throw Exception("Failed to delete hospital");
    }
  }
}