import 'dart:convert';

import 'package:blood_donation/api/main_api.dart';
import 'package:blood_donation/api/notification_api.dart';
import 'package:blood_donation/api/user_api.dart';
import 'package:blood_donation/models/hospital.dart';
import 'package:blood_donation/models/user.dart';
import 'package:blood_donation/screen/mainpage/hospital/hospital_details.dart';
import 'package:blood_donation/screen/mainpage/notification/notification_list.dart';
import 'package:intl/intl.dart';
import 'package:blood_donation/theme/app_theme.dart';
import 'package:blood_donation/widgets/my_container.dart';
import 'package:blood_donation/widgets/my_spacing.dart';
import 'package:blood_donation/widgets/my_text.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainUser extends StatefulWidget {
  const MainUser({super.key});

  @override
  State<MainUser> createState() => _MainUserState();
}

class _MainUserState extends State<MainUser> {
  int selectedCategory = 0;
  late ThemeData theme;
  late CustomTheme customTheme;
  List<Hospital> hospitalList = [];
  late Users? userData;
  bool isLoadingUser = true;
  List<UserNotification> readNotifications = [];
  List<UserNotification> unreadNotifications = [];

  @override
  void initState() {
    super.initState();
    theme = AppTheme.theme;
    customTheme = AppTheme.customTheme;
    _buildHospitalList();
    _getUser();
  }

  _buildHospitalList() async {
    MainAPI mainAPI = MainAPI();
    List<Hospital> list = await mainAPI.allHospital();
    setState(() {
      hospitalList = list;
    });
  }

  _getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userDataJson = prefs.getString('userData');
    if (userDataJson != null) {
      Map<String, dynamic> decodedData = json.decode(userDataJson);
      var userId = decodedData['donorID'];
      var fetchedUserData = await UserAPI().getUserData(userId);

      if (fetchedUserData != null) {
        String donorLatestDonate = fetchedUserData['donor_LatestDonate'] ?? '';
        DateTime threeMonthsAgo = DateTime.now().subtract(Duration(days: 90));

        if (donorLatestDonate.isEmpty) {
          // Store the user data to shared preferences
          await prefs.setString('userData', json.encode(fetchedUserData));
          print("User data stored to shared preferences because donor_LatestDonate is empty.");
        } else {
          DateTime latestDonateDate = DateTime.parse(donorLatestDonate);
          if (latestDonateDate.isBefore(threeMonthsAgo)) {
            await UserAPI().updateUserAvailability(userId, 'available');
            fetchedUserData['donor_Availability'] = 'available';
          }
        }

        setState(() {
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

        isLoadingUser = false;
        _getNotificationUser(userId);
      } else {
        print("User data not found for userId: $userId");
      }
    }
  }

  _getNotificationUser(String userId) async{
    NotificationAPI notificationAPI = NotificationAPI();
    var getNotification = await notificationAPI.getUserNotifications(userId);    
    List<UserNotification> fetchedReadNotifications = [];
    List<UserNotification> fetchedUnreadNotifications = [];

    for (var notificationData in getNotification) {
      UserNotification notification = UserNotification.fromMap(notificationData);
      if (notification.status == "sent") {
        fetchedUnreadNotifications.add(notification);
      } else {
        fetchedReadNotifications.add(notification);
      }
    }
    // Sort notifications by campaignId in descending order
    fetchedReadNotifications.sort((a, b) => b.campaignId.compareTo(a.campaignId));
    fetchedUnreadNotifications.sort((a, b) => b.campaignId.compareTo(a.campaignId));

    setState(() {
      readNotifications = fetchedReadNotifications;
      unreadNotifications = fetchedUnreadNotifications;
    });
  }

  Widget _buildAllHospital() {
    if (hospitalList.isEmpty) {
      return const Column(
        children: [
          CircularProgressIndicator(),
        ],
      );
    } else {
      return Column(
        children: List.generate(hospitalList.length, (index) {
          final hospList = hospitalList[index];
          return MyContainer(
            onTap: () {
              Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
                  builder: (context) => HospitalDetails(hospList, userData!)));
            },
            margin: MySpacing.fromLTRB(24, 0, 24, 16),
            paddingAll: 16,
            borderRadiusAll: 8,
            child: Row(
              children: [
                MyContainer(
                  paddingAll: 0,
                  borderRadiusAll: 8,
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                    child: Image.network(
                      hospList.hospitalImage,
                      width: 72,
                      height: 72,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                MySpacing.width(16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MyText.bodyLarge(
                        hospList.hospitalName,
                        fontWeight: 600,
                      ),
                      MySpacing.height(4),
                      MyText.bodySmall(
                        hospList.hospitalAddress,
                        maxLines: 1,
                        xMuted: true,
                      ),
                      MySpacing.height(12),
                      Row(
                        children: [
                          MyText.bodySmall(
                            '${hospList.hospitalContact}',
                            xMuted: true,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      );
    }
  }

  String capitalize(String s) {
    if (s.isEmpty) return s;
    return s[0].toUpperCase() + s.substring(1);
  }

  Widget donateAvailability() {
    if (isLoadingUser) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      Users? user = userData;
      if (user?.donorAvailability == "donated") {
        return MyContainer(
          borderRadiusAll: 8,
          margin: MySpacing.horizontal(24),
          color: Colors.red[400],
          child: Column(
            children: [
              Row(
                children: [
                  const MyContainer(
                    paddingAll: 0,
                    borderRadiusAll: 8,
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      child: Image(
                        height: 40,
                        width: 40,
                        image: AssetImage(
                          'assets/images/profile/user.png',
                        ),
                      ),
                    ),
                  ),
                  MySpacing.width(16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MyText.bodySmall(
                          '${capitalize(user!.donorName)}',
                          color: customTheme.medicareOnPrimary,
                          fontWeight: 700,
                        ),
                        MyText.bodySmall(
                          'Donated',
                          fontSize: 10,
                          color: customTheme.medicareOnPrimary.withAlpha(200),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              MySpacing.height(16),
              MyContainer(
                borderRadiusAll: 8,
                color: theme.colorScheme.onBackground.withAlpha(30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _donationDate(user),
                  ],
                ),
              ),
            ],
          ),
        );
      } else {
        return MyContainer(
          borderRadiusAll: 8,
          margin: MySpacing.horizontal(24),
          color: Colors.green[400],
          child: Column(
            children: [
              Row(
                children: [
                  const MyContainer(
                    paddingAll: 0,
                    borderRadiusAll: 8,
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      child: Image(
                        height: 40,
                        width: 40,
                        image: AssetImage(
                          'assets/images/profile/user.png',
                        ),
                      ),
                    ),
                  ),
                  MySpacing.width(16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MyText.bodySmall(
                          '${capitalize(user!.donorName)}',
                          color: customTheme.medicareOnPrimary,
                          fontWeight: 700,
                        ),
                        MyText.bodySmall(
                          'Available to donate',
                          fontSize: 10,
                          color: customTheme.medicareOnPrimary.withAlpha(200),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              MySpacing.height(16),
              MyContainer(
                borderRadiusAll: 8,
                color: theme.colorScheme.onBackground.withAlpha(30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _donationDate(user),
                  ],
                ),
              ),
            ],
          ),
        );
      }
    }
  }

  Widget _donationDate(lastDonate){
    if (lastDonate.donorLatestDonate == '') {
      return Row(
        children: [
          Icon(
            Icons.watch_later,
            color: customTheme.medicareOnPrimary.withAlpha(160),
            size: 20,
          ),
          MySpacing.width(8),
          MyText.bodySmall(
            'Last Donate :',
            color: customTheme.medicareOnPrimary,
          ),
          MySpacing.width(8),
          MyText.bodySmall(
            'Not Donate',
            color: customTheme.medicareOnPrimary,
          ),
        ],
      );
    } else {
      DateTime dateTime = DateTime.parse(lastDonate.donorLatestDonate.toString());
String formattedDate = DateFormat('E, MMM dd, yyyy, hh:mma').format(dateTime);

      return Row(
        children: [
          Icon(
            Icons.watch_later,
            color: customTheme.medicareOnPrimary.withAlpha(160),
            size: 20,
          ),
          MySpacing.width(8),
          MyText.bodySmall(
            'Last Donate :',
            color: customTheme.medicareOnPrimary,
          ),
          MySpacing.width(8),
          MyText.bodySmall(
            '${formattedDate}',
            color: customTheme.medicareOnPrimary,
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: MySpacing.top(48),
        children: [
          Padding(
            padding: MySpacing.horizontal(24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MySpacing.width(8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    MyText.bodySmall(
                      'Current Location',
                      color: theme.colorScheme.onBackground,
                      xMuted: true,
                      fontSize: 10,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: customTheme.medicarePrimary,
                          size: 12,
                        ),
                        MySpacing.width(4),
                        MyText.bodySmall(
                          'Terengganu, Malaysia',
                          color: theme.colorScheme.onBackground,
                          fontWeight: 600,
                        ),
                      ],
                    ),
                  ],
                ),
                MyContainer(
                  onTap: () {
                    Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
                        builder: (context) => NotificationList()));
                  },
                  paddingAll: 4,
                  borderRadiusAll: 4,
                  color: customTheme.card,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: <Widget>[
                      Icon(
                        LucideIcons.bell,
                        size: 20,
                        color: theme.colorScheme.onBackground.withAlpha(200),
                      ),
                      if(unreadNotifications.length > 0)
                      Positioned(
                        right: 2,
                        top: 2,
                        child: MyContainer.rounded(
                          paddingAll: 4,
                          color: customTheme.medicarePrimary,
                          child: Container(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          MySpacing.height(24),
          // Padding(
          //   padding: MySpacing.horizontal(24),
          //   child: TextFormField(
          //     decoration: InputDecoration(
          //       filled: true,
          //       labelText: "Search a hospital",
          //       hintText: "Search a hospital",
          //       labelStyle: MyTextStyle.getStyle(
          //           color: customTheme.medicarePrimary,
          //           fontSize: 12,
          //           fontWeight: 600,
          //           muted: true),
          //       hintStyle: MyTextStyle.getStyle(
          //           color: customTheme.medicarePrimary,
          //           fontSize: 12,
          //           fontWeight: 600,
          //           muted: true),
          //       fillColor: customTheme.card,
          //       enabledBorder: const OutlineInputBorder(
          //           borderRadius: BorderRadius.all(
          //             Radius.circular(8),
          //           ),
          //           borderSide: BorderSide.none),
          //       border: const OutlineInputBorder(
          //           borderRadius: BorderRadius.all(
          //             Radius.circular(8),
          //           ),
          //           borderSide: BorderSide.none),
          //       disabledBorder: const OutlineInputBorder(
          //           borderRadius: BorderRadius.all(
          //             Radius.circular(8),
          //           ),
          //           borderSide: BorderSide.none),
          //       errorBorder: const OutlineInputBorder(
          //           borderRadius: BorderRadius.all(
          //             Radius.circular(8),
          //           ),
          //           borderSide: BorderSide.none),
          //       contentPadding: MySpacing.all(16),
          //       prefixIcon: const Icon(
          //         LucideIcons.search,
          //         size: 20,
          //       ),
          //       prefixIconColor: customTheme.medicarePrimary,
          //       focusColor: customTheme.medicarePrimary,
          //       floatingLabelBehavior: FloatingLabelBehavior.never,
          //     ),
          //     cursorColor: customTheme.medicarePrimary,
          //     autofocus: false,
          //   ),
          // ),
          // MySpacing.height(24),
          Padding(
            padding: MySpacing.horizontal(24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MyText.bodyMedium(
                  'Dashboard',
                  fontWeight: 700,
                ),
              ],
            ),
          ),
          MySpacing.height(16),
          donateAvailability(),
          MySpacing.height(24),
          Padding(
            padding: MySpacing.horizontal(24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MyText.bodyMedium(
                  'Find your nearest hospital',
                  fontWeight: 700,
                ),
              ],
            ),
          ),
          MySpacing.height(16),
          _buildAllHospital(),
        ],
      ),
    );
  }
}