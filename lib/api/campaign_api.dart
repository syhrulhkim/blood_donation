
import 'package:blood_donation/api/user_api.dart';
import 'package:blood_donation/models/campaign.dart';
import 'package:blood_donation/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CampaignAPI {
  final _db = FirebaseFirestore.instance;

  Future<List<Campaign>> allCampaign() async {
    final snapshot = await _db.collection("campaign").get();
    final data = snapshot.docs.map((e) async {
      Campaign campaign = Campaign.fromSnapshot(e);
      QuerySnapshot campaignSnapshot = await e.reference.collection("campaignSendTo").get();
      campaign.campaignSend = campaignSnapshot.docs.map((doc) => CampaignSendTo.fromSnapshot(doc)).toList();
      return campaign;
    }).toList();

    return Future.wait(data);
  }

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

  Future<void> addCampaignWithUsers(Campaign campaign, List<CampaignSendTo> users) async {
    try {
      String nextCampaignID = await getNextCampaignID();
      print("Generated nextCampaignID: $nextCampaignID"); // Debugging statement
      campaign = campaign.copyWith(campaignId: nextCampaignID);

      CollectionReference campaignRef = _db.collection('campaign');
      DocumentReference campaignDocRef = campaignRef.doc(nextCampaignID);

      WriteBatch batch = _db.batch();
      batch.set(campaignDocRef, campaign.toMap());
      
      for (CampaignSendTo user in users) {
        DocumentReference userDocRef = campaignDocRef.collection('campaignSendTo').doc(user.donorID);
        batch.set(userDocRef, user.toMap());

        UserNotification newNotification = UserNotification(
          campaignId: nextCampaignID,
          campaignTitle: campaign.campaignTitle,
          campaignDesc: campaign.campaignDesc,
          campaignDate: campaign.campaignDate,
          place: campaign.place,
          status: "sent",
        );

        // send to notification each user
        await UserAPI().addNotificationToUsers(user.donorID, nextCampaignID, newNotification);
      }
      // Commit the batch
      await batch.commit();
      print("Campaign and users added successfully"); // Debugging statement

    } catch (e) {
      print("Error adding campaign with users data: $e");
      throw Exception("Failed to add campaign with users data");
    }
  }
}