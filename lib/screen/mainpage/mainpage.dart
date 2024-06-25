// import 'package:flutkit/full_apps/other/medicare/chat_screen.dart';
// import 'package:flutkit/full_apps/other/medicare/home_screen.dart';
// import 'package:flutkit/full_apps/other/medicare/profile_screen.dart';
// import 'package:flutkit/full_apps/other/medicare/schedule_screen.dart';
import 'dart:convert';
import 'dart:ffi';

import 'package:blood_donation/auth/nonuser.dart';
import 'package:blood_donation/screen/booking/booking_admin.dart';
import 'package:blood_donation/screen/booking/booking_user.dart';
import 'package:blood_donation/screen/history/history.dart';
import 'package:blood_donation/screen/mainpage/main_admin.dart';
import 'package:blood_donation/screen/mainpage/main_guest.dart';
import 'package:blood_donation/screen/mainpage/main_user.dart';
import 'package:blood_donation/screen/news/news.dart';
import 'package:blood_donation/screen/profile/profile.dart';
import 'package:blood_donation/screen/profile/profile_admin.dart';
import 'package:blood_donation/theme/app_theme.dart';
import 'package:blood_donation/widgets/my_bottom_navigation_bar.dart';
import 'package:blood_donation/widgets/my_bottom_navigation_bar_item.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late ThemeData theme;
  late CustomTheme customTheme;
  Map<String, dynamic>? userData;
  List<MyBottomNavigationBarItem> items = [];
  String role = '';
  var isLoading = true;

  Future<void> _getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userDataJson = prefs.getString('userData');
    print("userDataJson : ${userDataJson}");
    if (userDataJson != null) {
      setState(() {
        userData = json.decode(userDataJson);
        if (userData!.containsKey('donor_Role')) {
          role = userData!['donor_Role'];
        }
      });
      checkingRole(role);
      isLoading = false;
    }
  }

  checkingRole(roles) {
    print("roles :${roles}");
    switch (roles) {
      case "admin":
        items.addAll([
          MyBottomNavigationBarItem(
            page: MainAdmin(),
            activeIconData: LucideIcons.home,
            iconData: LucideIcons.home,
          ),
          MyBottomNavigationBarItem(
            page: BookingAdmin(),
            activeIconData: LucideIcons.calendarDays,
            iconData: LucideIcons.calendarDays,
          ),
          // MyBottomNavigationBarItem(
          //   page: History(),
          //   activeIconData: LucideIcons.history,
          //   iconData: LucideIcons.history,
          // ),
          MyBottomNavigationBarItem(
            page: News(),
            activeIconData: LucideIcons.newspaper,
            iconData: LucideIcons.newspaper,
          ),
          MyBottomNavigationBarItem(
            page: ProfileAdmin(),
            activeIconData: LucideIcons.user,
            iconData: LucideIcons.user,
          ),
        ]);
        break;
      case "user":
        items.addAll([
          MyBottomNavigationBarItem(
            page: MainUser(),
            activeIconData: LucideIcons.home,
            iconData: LucideIcons.home,
          ),
          MyBottomNavigationBarItem(
            page: BookingUser(),
            activeIconData: LucideIcons.calendarDays,
            iconData: LucideIcons.calendarDays,
          ),
          MyBottomNavigationBarItem(
            page: History(),
            activeIconData: LucideIcons.history,
            iconData: LucideIcons.history,
          ),
          MyBottomNavigationBarItem(
            page: Profile(),
            activeIconData: LucideIcons.user,
            iconData: LucideIcons.user,
          ),
        ]);
        break;
      case "":
        items.addAll([
          MyBottomNavigationBarItem(
            page: MainGuest(),
            activeIconData: LucideIcons.home,
            iconData: LucideIcons.home,
          ),
          MyBottomNavigationBarItem(
            page: NonUser(),
            activeIconData: LucideIcons.calendarDays,
            iconData: LucideIcons.calendarDays,
          ),
          MyBottomNavigationBarItem(
            page: NonUser(),
            activeIconData: LucideIcons.history,
            iconData: LucideIcons.history,
          ),
          MyBottomNavigationBarItem(
            page: NonUser(),
            activeIconData: LucideIcons.user,
            iconData: LucideIcons.user,
          ),
        ]);
        break;
      default:
    }
  }

  @override
  void initState() {
    super.initState();
    _getUserData();
    theme = AppTheme.theme;
    customTheme = AppTheme.customTheme;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
        ? Center(
            child: CircularProgressIndicator(), // Show loading indicator
          )
        : MyBottomNavigationBar(
            containerDecoration: BoxDecoration(
              color: customTheme.card,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16)),
            ),
            activeContainerColor:
                customTheme.medicarePrimary.withAlpha(30),
            myBottomNavigationBarType:
                MyBottomNavigationBarType.containered,
            showActiveLabel: false,
            showLabel: false,
            activeIconSize: 24,
            iconSize: 24,
            activeIconColor: customTheme.medicarePrimary,
            iconColor: theme.colorScheme.onBackground.withAlpha(140),
            itemList: items,
          ),
    );
  }
}