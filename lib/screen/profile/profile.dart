import 'dart:convert';

import 'package:blood_donation/api/user_api.dart';
import 'package:blood_donation/auth/login.dart';
import 'package:blood_donation/models/user.dart';
import 'package:blood_donation/screen/profile/profile_edit.dart';
import 'package:blood_donation/screen/profile/profile_password.dart';
import 'package:blood_donation/theme/app_theme.dart';
import 'package:blood_donation/widgets/my_button.dart';
import 'package:blood_donation/widgets/my_container.dart';
import 'package:blood_donation/widgets/my_spacing.dart';
import 'package:blood_donation/widgets/my_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late ThemeData theme;
  late CustomTheme customTheme;
  late Users userData;
  bool isLoadingUser = true;

  @override
  void initState() {
    super.initState();
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
            donorHeight: fetchedUserData['donor_Height'],
            donorFcmToken: fetchedUserData['donor_fcmToken'],
          );
        });
      } else {
        print("User data not found for userId: $userId");
      }
    }
  }

  Future<void> removeUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('userData');
  }

  void _logOut() async {
    await removeUserData();
    Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
          builder: (context) => LoginPage()),
    );
  }

  Widget _buildSingleRow({String? title, IconData? icon}) {
    return Row(
      children: [
        MyContainer(
          paddingAll: 8,
          borderRadiusAll: 4,
          color: theme.colorScheme.onBackground.withAlpha(20),
          child: Icon(
            icon,
            color: customTheme.medicarePrimary,
            size: 20,
          ),
        ),
        MySpacing.width(16),
        Expanded(
          child: MyText.bodySmall(
            title!,
          ),
        ),
        MySpacing.width(16),
        Icon(
          Icons.keyboard_arrow_right,
          color: theme.colorScheme.onBackground.withAlpha(160),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoadingUser) {
      return Scaffold(
        body: ListView(
          padding: MySpacing.fromLTRB(24, 52, 24, 24),
          children: [
            CircularProgressIndicator(),
          ],
        ),
      );
    } else {
      return Scaffold(
        body: ListView(
          padding: MySpacing.fromLTRB(24, 52, 24, 24),
          children: [
            Center(
              child: MyContainer(
                paddingAll: 0,
                borderRadiusAll: 24,
                child: ClipRRect(
                  borderRadius: BorderRadius.all(
                    Radius.circular(24),
                  ),
                  child: Image(
                    fit: BoxFit.cover,
                    width: 100,
                    height: 100,
                    image: AssetImage('assets/images/profile/user.png'),
                  ),
                ),
              ),
            ),
            MySpacing.height(24),
            MyText.titleLarge(
              '${userData.donorName}',
              textAlign: TextAlign.center,
              fontWeight: 600,
              letterSpacing: 0.8,
            ),
            MySpacing.height(4),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MyContainer.rounded(
                  color: customTheme.medicarePrimary,
                  height: 6,
                  width: 6,
                  child: Container(),
                ),
                MySpacing.width(6),
                MyText.bodySmall(
                  'Online',
                  color: customTheme.medicarePrimary,
                  muted: true,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            MySpacing.height(24),
            MyText.bodySmall(
              'General',
              color: theme.colorScheme.onBackground,
              xMuted: true,
            ),
            MySpacing.height(24),
            MySpacing.height(8),
            Container(
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context, rootNavigator: true).push(
                    MaterialPageRoute(
                        builder: (context) => ProfileEdit(userData)),
                  );
                },
                child: _buildSingleRow(title: 'Profile settings', icon: LucideIcons.user),
              )
            ),
            MySpacing.height(8),
            Divider(),
            MySpacing.height(8),
            Container(
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context, rootNavigator: true).push(
                    MaterialPageRoute(
                        builder: (context) => ChangePassword()),
                  );
                },
                child: _buildSingleRow(title: 'Password', icon: LucideIcons.lock),
              )
            ),
            // _buildSingleRow(title: 'Password', icon: LucideIcons.lock),
            MySpacing.height(8),
            Divider(),
            MySpacing.height(8),
            Container(
              child: GestureDetector(
                onTap: () {
                  _logOut();
                },
                child: _buildSingleRow(title: 'Logout', icon: LucideIcons.logOut),
              )
            ),
          ],
        ),
      );
    }
    
  }
}