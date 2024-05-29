import 'dart:convert';

import 'package:blood_donation/api/notification_api.dart';
import 'package:blood_donation/api/user_api.dart';
import 'package:blood_donation/models/user.dart';
import 'package:blood_donation/theme/app_theme.dart';
import 'package:blood_donation/theme/custom_theme.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationDetails extends StatefulWidget {
  final UserNotification notification;
  const NotificationDetails(this.notification);

  @override
  State<NotificationDetails> createState() => _NotificationDetailsState();
}

class _NotificationDetailsState extends State<NotificationDetails> {
  late ThemeData theme;
  late CustomTheme customTheme;
  late UserNotification notification;
  late Users userData;
  bool isLoadingUser = true;

  @override
  void initState() {
    super.initState();
    theme = AppTheme.theme;
    customTheme = AppTheme.customTheme;
    notification = widget.notification;
    _getUser();
  }

  _getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userDataJson = prefs.getString('userData');
    if(userDataJson != null) {
      Map<String, dynamic> decodedData = json.decode(userDataJson);
      var userId = decodedData['donorID'];
      var fetchedUserData = await UserAPI().getUserData(userId);

      if(fetchedUserData != null) {
        setState(() {
          isLoadingUser = false;
          userData = Users(
            donorID: fetchedUserData['donorID'],
            donorAddress: fetchedUserData['donor_Address'],
            donorContact: fetchedUserData['donor_Contact'],
            donorDOB: fetchedUserData['donor_DOB'],
            donorEligibility: fetchedUserData['donor_Eligibility'],
            donorAvailability: fetchedUserData['donor_Availability'],
            donorEmail: fetchedUserData['donor_Email'],
            donorGender: fetchedUserData['donor_Gender'],
            donorHealth: fetchedUserData['donor_Health'],
            donorLatestDonate: fetchedUserData['donor_LatestDonate'],
            donorName: fetchedUserData['donor_Name'],
            donorPostcode: fetchedUserData['donor_Postcode'],
            donorRole: fetchedUserData['donor_Role'],
            donorType: fetchedUserData['donor_Type'],
            donorUsername: fetchedUserData['donor_Username'],
            donorWeight: fetchedUserData['donor_Weight'],
            donorFcmToken: fetchedUserData['donor_fcmToken'],
          );
        });
        changeStatus(userData.donorID);
      } else {
        print("User data not found for userId: $userId");
      }
    }
  }

  changeStatus(userId) async{
    NotificationAPI notificationAPI = NotificationAPI();
    await notificationAPI.markNotificationAsRead(userId, notification.campaignId);
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}