// import 'package:flutkit/full_apps/other/medicare/models/chat.dart';
// import 'package:flutkit/full_apps/other/medicare/single_chat_screen.dart';
import 'dart:convert';

import 'package:blood_donation/api/notification_api.dart';
import 'package:blood_donation/api/user_api.dart';
import 'package:blood_donation/models/chat.dart';
import 'package:blood_donation/models/user.dart';
import 'package:blood_donation/screen/mainpage/notification/notification_details.dart';
import 'package:blood_donation/theme/app_theme.dart';
import 'package:blood_donation/widgets/my_container.dart';
import 'package:blood_donation/widgets/my_spacing.dart';
import 'package:blood_donation/widgets/my_text.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationList extends StatefulWidget {
  const NotificationList({super.key});

  @override
  State<NotificationList> createState() => _NotificationListState();
}

class _NotificationListState extends State<NotificationList> {
  List<Chat> chatList = [];
  late ThemeData theme;
  late CustomTheme customTheme;
  List<UserNotification> readNotifications = [];
  List<UserNotification> unreadNotifications = [];
  late Users userData;
  bool isLoadingUser = true;


  @override
  void initState() {
    super.initState();
    chatList = Chat.chatList();
    theme = AppTheme.theme;
    customTheme = AppTheme.customTheme;
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
      print("status : ${notification.status == "sent"}");
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

  readAllMessage(userId) async {
    NotificationAPI notificationAPI = NotificationAPI();
    await notificationAPI.markAllNotificationsAsRead(userId);
    // navigate announcement page
    Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
      builder: (context) => NotificationList()));
  }
  
  convertDate(dateTimes) {
    DateTime dateTime = DateTime.parse(dateTimes);
    String formattedDate = DateFormat('d MMMM yyyy').format(dateTime);
    return formattedDate;
  }

  convertTime(dateTimes) {
    DateTime dateTime = DateTime.parse(dateTimes);
    String formattedTime = DateFormat.jm().format(dateTime);
    return formattedTime;
  }

  Widget _buildSingleNotification(UserNotification notification) {
    return MyContainer(
      onTap: () {
        Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
          builder: (context) => NotificationDetails(notification)));
      },
      margin: MySpacing.bottom(16),
      paddingAll: 16,
      borderRadiusAll: 16,
      child: Row(
        children: [
          Icon(
            LucideIcons.info,
            size: 24,
            color: theme.colorScheme.primary,
          ),
          MySpacing.width(16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyText.bodyMedium(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  notification.campaignTitle ?? 'No Title',
                  fontWeight: 600,
                ),
                MySpacing.height(4),
                MyText.bodySmall(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  notification.campaignDesc ?? 'No Description',
                  xMuted: true,
                ),
              ],
            ),
          ),
          MySpacing.width(8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              MyText.bodySmall(
                convertDate(notification.campaignDate.toString()),
                xMuted: true,
              ),
              MySpacing.height(4),
              MyText.bodySmall(
                convertTime(notification.campaignDate.toString()),
                xMuted: true,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget readMessagesTab() {
    return ListView(
      padding: MySpacing.all(24),
      children: readNotifications.map(_buildSingleNotification).toList(),
    );
  }

  Widget unreadMessagesTab() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(16, 0, 0, 0),
          margin: EdgeInsets.fromLTRB(5, 10, 5, 10),
          height: 30.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start, // Aligns the button to the start
            children: [
              TextButton(
                onPressed: () {
                  readAllMessage(userData.donorID);
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.grey, // Background color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: Text(
                  'Mark All Read',
                  style: TextStyle(
                    fontSize: 10.0,
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            padding: EdgeInsets.fromLTRB(24,0,24,24),
            children: unreadNotifications.map(_buildSingleNotification).toList(),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
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
              Expanded(
                child: Center(
                  child: MyText.bodyLarge(
                    'Announcements',
                    fontWeight: 700,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              SizedBox(width: 40), // Ensures title is centered
            ],
          ),
          elevation: 0,
          centerTitle: true,
          backgroundColor: theme.scaffoldBackgroundColor,
          automaticallyImplyLeading: false,
          bottom: TabBar(
            tabs: [
              Tab(text: 'Unread'),
              Tab(text: 'Read'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            unreadMessagesTab(),
            readMessagesTab(),
          ],
        ),
      ),
    );
  }
}