import 'package:blood_donation/api/main_api.dart';
import 'package:blood_donation/auth/nonuser.dart';
import 'package:blood_donation/models/hospital.dart';
import 'package:blood_donation/models/user.dart';
import 'package:blood_donation/screen/mainpage/hospital/hospital_details.dart';
import 'package:blood_donation/screen/mainpage/notification/notification_list.dart';
import 'package:blood_donation/widgets/my_bottom_navigation_bar.dart';
import 'package:blood_donation/widgets/my_bottom_navigation_bar_item.dart';
import 'package:intl/intl.dart';
import 'package:blood_donation/theme/app_theme.dart';
import 'package:blood_donation/widgets/my_container.dart';
import 'package:blood_donation/widgets/my_spacing.dart';
import 'package:blood_donation/widgets/my_text.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class MainGuest extends StatefulWidget {
  const MainGuest({super.key});

  @override
  State<MainGuest> createState() => _MainGuestState();
}

class _MainGuestState extends State<MainGuest> {
  int selectedCategory = 0;
  late ThemeData theme;
  late CustomTheme customTheme;
  List<Hospital> hospitalList = [];
  List<UserNotification> readNotifications = [];
  List<UserNotification> unreadNotifications = [];

  @override
  void initState() {
    super.initState();
    theme = AppTheme.theme;
    customTheme = AppTheme.customTheme;
    _buildHospitalList();
  }

  _buildHospitalList() async {
    MainAPI mainAPI = MainAPI();
    List<Hospital> list = await mainAPI.allHospital();
    setState(() {
      hospitalList = list;
    });
  }

  Widget _buildAllHospital() {
    if (hospitalList.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return Column(
        children: List.generate(hospitalList.length, (index) {
          final hospList = hospitalList[index];
          return Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
            child: MyContainer(
              onTap: () {
                // Handle onTap event if needed
              },
              paddingAll: 16,
              borderRadiusAll: 8,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: SizedBox(
                      width: 72,
                      height: 72,
                      child: hospList.hospitalImage.isNotEmpty
                          ? Image.network(
                              hospList.hospitalImage,
                              fit: BoxFit.cover,
                            )
                          : Container(
                              color: Colors.grey[200],
                              child: Icon(Icons.image, color: Colors.grey),
                            ),
                    ),
                  ),
                  const SizedBox(width: 16),
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
                        MyText.bodySmall(
                          '${hospList.hospitalContact}',
                          xMuted: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
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
                      'assets/images/profile/avatar_3.jpg',
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
                      'Guest',
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
        ],
      ),
    );
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
                          'Malaysia',
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
          MyBottomNavigationBar(
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
            itemList: [
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
            ],
          ),
        ],
      ),
    );
  }
}