import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpApi {
  final _db = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;

  Future<void> signUpAPI(String name, String email, String password) async {
    try {
      var createUserAuth = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      var token = createUserAuth.user!.uid;
      submitDonor(name, email, token);
    } catch (e) {
      print("Error signing up: $e");
      throw e; 
    }
  }

  Future<String> getNextuserID() async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot =
          await _db.collection("user").orderBy("donorID", descending: true).limit(1).get();
      if (snapshot.docs.isNotEmpty) {
        String latestID = snapshot.docs.first.data()["donorID"];
        int currentNumber = int.parse(latestID.substring(2)); 
        int nextNumber = currentNumber + 1; 
        String nextID = "DN" + nextNumber.toString().padLeft(3, '0');
        return nextID;
      } else {
        return "DN001";
      }
    } catch (error) {
      print("Error getting next donor ID: $error");
      throw Exception("Failed to get next donor ID");
    }
  }

  Future<void> submitDonor(String name, String email, String token) async {
    try {
      String nextDonorID = await getNextuserID(); // Get the next donor ID
      DocumentReference donorDocRef = FirebaseFirestore.instance.collection('user').doc(nextDonorID);

      // Set the donor data within the document
      await donorDocRef.set({
        'donorID': nextDonorID,
        'donor_Address': "",
        'donor_Contact': "",
        'donor_DOB': "",
        'donor_Eligibility': "",
        'donor_Availability': "available",
        'donor_Email': email,
        'donor_Gender': "",
        'donor_Health': "",
        'donor_Height': "",
        'donor_LatestDonate': "",
        'donor_Name': name,
        'donor_Password': token,
        'donor_Postcode': "",
        'donor_Role': "user",
        'donor_Type': "",
        'donor_Username': email,
        'donor_Weight': "",
      });

      print("Donor data submitted successfully");
    } catch (error) {
      print("Error submitting donor data: $error");
      throw Exception("Failed to submit donor data");
    }
  }
}
