import 'dart:convert';

import 'package:blood_donation/api/hospital_api.dart';
import 'package:blood_donation/api/notification_api.dart';
import 'package:blood_donation/api/user_api.dart';
import 'package:blood_donation/extensions/string.dart';
import 'package:blood_donation/models/hospital.dart';
import 'package:blood_donation/models/user.dart';
import 'package:blood_donation/screen/mainpage/hospital/hospital_book.dart';
import 'package:blood_donation/screen/mainpage/hospital/hospital_edit.dart';
import 'package:blood_donation/theme/app_theme.dart';
import 'package:blood_donation/theme/custom_theme.dart';
import 'package:blood_donation/widgets/my_button.dart';
import 'package:blood_donation/widgets/my_container.dart';
import 'package:blood_donation/widgets/my_spacing.dart';
import 'package:blood_donation/widgets/my_text.dart';
import 'package:blood_donation/widgets/my_text_style.dart';
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
  bool isLoadingHospital = true;
  late Hospital hospital;

  @override
  void initState() {
    super.initState();
    theme = AppTheme.theme;
    customTheme = AppTheme.customTheme;
    notification = widget.notification;
    _getUser();
    _getHospital();
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
            donorHeight: fetchedUserData['donor_Height'],
            donorFcmToken: fetchedUserData['donor_fcmToken'],
          );
        });
        changeStatus(userData.donorID);
      } else {
        print("User data not found for userId: $userId");
      }
    }
  }

  _getHospital() async{
    HospitalAPI hospitalAPI = HospitalAPI();
    try {
      Hospital hospitals = await hospitalAPI.getOneHospital(notification.place);
      setState(() {
        isLoadingHospital = false;
        hospital = hospitals;
      });
    } catch (error) {
      print("Error fetching hospital data: $error");
    }
  }

  changeStatus(userId) async{
    NotificationAPI notificationAPI = NotificationAPI();
    await notificationAPI.markNotificationAsRead(userId, notification.campaignId);
  }

  Widget criticalBloodLevel() {
    String extractBloodType(String fullName) {
      List<String> parts = fullName.split('_');
      String bloodType = parts.last;
      bloodType = bloodType.substring(0, 1).toUpperCase() + bloodType.substring(1);    
      return bloodType;
    }

    Color getColorForPercent(String percents) {
      var percent = percents.toInt();
      if (percent >= 0 && percent <= 30) {
        return Colors.red;
      } else if (percent >= 31 && percent <= 70) {
        return const Color.fromARGB(255, 229, 208, 15);
      } else {
        return Colors.green;
      }
    }

    return Container(
      child: Center(
        child: Container(
          width: double.infinity,
          child: Wrap(
            spacing: 5.0, 
            runSpacing: 10.0,
            children: List.generate(
              hospital.bloodLevels.length,
              (index) => Container(
                // width: 75,
                height: 40,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    color: Colors.white,
                    border: Border.all(
                      width: 0.5,
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                    child: SingleChildScrollView( // Wrapping with SingleChildScrollView
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          MyContainer(
                            paddingAll: 4,
                            child: Text("${extractBloodType(hospital.bloodLevels[index].bloodType)}"),
                          ),
                          SizedBox(width: MediaQuery.of(context).size.width * 0.01),
                          MyContainer(
                            color: getColorForPercent(hospital.bloodLevels[index].percent),
                            paddingAll: 4,
                            child: Text(
                              "${hospital.bloodLevels[index].percent}%",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget hospitalInfo() {
    if (!isLoadingHospital && hospital != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              RichText(
                text: TextSpan(children: <TextSpan>[
                  TextSpan(
                      text: hospital!.hospitalName,
                      style: MyTextStyle.bodySmall(
                        color: theme.colorScheme.onBackground,
                        xMuted: true,
                        height: 1.5,
                      )),
                ]),
              ),
              MySpacing.width(5),
              RichText(
                text: TextSpan(children: <TextSpan>[
                  TextSpan(
                      text: "(${hospital!.hospitalPoscode})",
                      style: MyTextStyle.bodySmall(
                        color: theme.colorScheme.onBackground,
                        xMuted: true,
                        height: 1.5,
                      )),
                ]),
              ),
            ],
          ),
          RichText(
            text: TextSpan(children: <TextSpan>[
              TextSpan(
                  text: hospital!.hospitalAddress,
                  style: MyTextStyle.bodySmall(
                    color: theme.colorScheme.onBackground,
                    xMuted: true,
                    height: 1.5,
                  )),
            ]),
          ),
          MySpacing.height(14),
          MyContainer(
            paddingAll: 0,
            borderRadiusAll: 16,
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(16)),
              child: Image(
                fit: BoxFit.cover,
                height: 140,
                width: MediaQuery.of(context).size.width - 96,
                image: NetworkImage(hospital!.hospitalImage),
              ),
            ),
          ),
          MyContainer(
            borderRadiusAll: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: MyText.titleSmall("Critical Blood Level", fontWeight: 700),
                ),
                MySpacing.height(5),
                criticalBloodLevel(),
              ],
            ),
          ),
        ],
      );
    } else {
      return Center(child: CircularProgressIndicator());
    }
  }

  Widget buttonAppointment() {
    if (isLoadingHospital == false) {
      return Column(
        children: [
          MyButton.block(
            elevation: 0,
            borderRadiusAll: 8,
            padding: MySpacing.y(20),
            backgroundColor: AppTheme.customTheme.medicarePrimary,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HospitalBooking(hospital, userData),
                ),
              );
            },
            child: MyText.bodyLarge(
              'Book Appointment',
              color: AppTheme.customTheme.medicareOnPrimary,
              fontWeight: 600,
            ),
          ),
        ],
      );
    } else {
      return Center(child: CircularProgressIndicator());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: MySpacing.fromLTRB(24, 44, 24, 24),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: MyContainer(
                  paddingAll: 4,
                  borderRadiusAll: 8,
                  child: Icon(
                    Icons.chevron_left,
                    color: theme.colorScheme.onBackground.withAlpha(160),
                    size: 24,
                  ),
                ),
              ),
            ],
          ),
          MySpacing.height(32),
          MyContainer(
            paddingAll: 24,
            borderRadiusAll: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyText.bodyLarge(
                  '${notification.campaignTitle}',
                  fontWeight: 600,
                ),
                MySpacing.height(10),
                RichText(
                  text: TextSpan(children: <TextSpan>[
                    TextSpan(
                        text: "${notification.campaignDesc}",
                        style: MyTextStyle.bodySmall(
                          color: theme.colorScheme.onBackground,
                          xMuted: true,
                          height: 1.5,
                        )),
                  ]),
                ),
                MySpacing.height(14),
                MyText.bodyLarge(
                  'Location',
                  fontWeight: 600,
                ),
                MySpacing.height(10),
                hospitalInfo(),
              ],
            ),
          ),
          MySpacing.height(32),
          buttonAppointment(),
        ],
      ),
    );
  }
}