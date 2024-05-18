
import 'package:blood_donation/models/campaign.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CampaignAPI {
  final _db = FirebaseFirestore.instance;

  Future<String> getNextCampaignID() async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot =
          await _db.collection("campaign").orderBy("campaignId", descending: true).limit(1).get();

      if (snapshot.docs.isNotEmpty) {
        String latestID = snapshot.docs.first.data()["campaignId"];
        int currentNumber = int.parse(latestID.substring(2));
        int nextNumber = currentNumber + 1;
        String nextID = "CP" + nextNumber.toString().padLeft(3, '0');
        return nextID;
      } else {
        // If the collection is empty, start with CP001
        return "CP001";
      }
    } catch (error) {
      print("Error getting next campaign ID: $error");
      throw Exception("Failed to get next campaign ID");
    }
  }

  Future<void> submitCampaign(Campaign campaign) async {
    try {
      String nextCampaignID = await getNextCampaignID();
      campaign = campaign.copyWith(campaignId: nextCampaignID);
      Map<String, dynamic> campaignData = campaign.toJson();

      await _db.collection("campaign").doc(nextCampaignID).set(campaignData);
      print("Campaign data submitted successfully");
    } catch (error) {
      print("Error submitting campaign data: $error");
      throw Exception("Failed to submit campaign data");
    }
  }
}