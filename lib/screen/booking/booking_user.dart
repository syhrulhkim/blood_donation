import 'package:blood_donation/models/doctor.dart';
import 'package:blood_donation/models/schedule.dart';
import 'package:blood_donation/theme/app_theme.dart';
import 'package:blood_donation/widgets/my_container.dart';
import 'package:blood_donation/widgets/my_spacing.dart';
import 'package:blood_donation/widgets/my_star_rating.dart';
import 'package:blood_donation/widgets/my_text.dart';
import 'package:flutter/material.dart';

class BookingUser extends StatefulWidget {
  const BookingUser({super.key});

  @override
  State<BookingUser> createState() => _BookingState();
}

class _BookingState extends State<BookingUser> {
  List<Schedule> upcomingList = [];
  List<Schedule> completedList = [];
  List<Doctor> doctorList = [];
  late ThemeData theme;
  late CustomTheme customTheme;

  @override
  void initState() {
    super.initState();
    upcomingList = Schedule.upComingList();
    completedList = Schedule.completedList();
    theme = AppTheme.theme;
    customTheme = AppTheme.customTheme;
    doctorList = Doctor.doctorList();
  }

  Widget _buildSingleEvent(Schedule schedule, {bool old = false}) {
    return MyContainer.bordered(
      paddingAll: 16,
      borderRadiusAll: 16,
      child: Row(
        children: [
          MyContainer(
            width: 56,
            padding: MySpacing.y(12),
            borderRadiusAll: 4,
            bordered: true,
            border: Border.all(color: customTheme.medicarePrimary),
            color: old
                ? Colors.transparent
                : customTheme.medicarePrimary.withAlpha(60),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  MyText.bodyMedium(
                    schedule.date.toString(),
                    fontWeight: 700,
                    color: customTheme.medicarePrimary,
                  ),
                  MyText.bodySmall(
                    schedule.month,
                    fontWeight: 600,
                    color: customTheme.medicarePrimary,
                  ),
                ],
              ),
            ),
          ),
          MySpacing.width(16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyText.bodySmall(
                  schedule.event,
                  fontWeight: 600,
                ),
                MySpacing.height(4),
                MyText.bodySmall(
                  schedule.time,
                  fontSize: 10,
                ),
                MySpacing.height(4),
                MyText.bodySmall(
                  schedule.doctorName,
                  fontSize: 10,
                ),
              ],
            ),
          ),
          MySpacing.width(16),
          MyContainer.rounded(
            paddingAll: 4,
            color: customTheme.card,
            child: Icon(
              old ? Icons.call_outlined : Icons.videocam_outlined,
              size: 16,
              color: theme.colorScheme.onBackground,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildDoctorList() {
    List<Widget> list = [];

    list.add(MySpacing.width(16));

    for (int i = 0; i < doctorList.length; i++) {
      list.add(_buildSingleDoctor(doctorList[i]));
    }
    return list;
  }

  Widget _buildSingleDoctor(Doctor doctor) {
    return MyContainer(
      onTap: () {
        // Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
        //     builder: (context) => MediCareSingleDoctorScreen(doctor)));
      },
      margin: MySpacing.fromLTRB(0, 0, 0, 16),
      paddingAll: 16,
      borderRadiusAll: 8,
      child: Row(
        children: [
          MyContainer(
            paddingAll: 0,
            borderRadiusAll: 8,
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(16)),
              child: Image(
                width: 72,
                height: 72,
                image: AssetImage(doctor.image),
              ),
            ),
          ),
          MySpacing.width(16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyText.bodyLarge(
                  doctor.name,
                  fontWeight: 600,
                ),
                MySpacing.height(4),
                MyText.bodySmall(
                  doctor.category,
                  xMuted: true,
                ),
                MySpacing.height(12),
                Row(
                  children: [
                    MyStarRating(
                      rating: doctor.ratings,
                      showInactive: true,
                      size: 15,
                      inactiveColor:
                          theme.colorScheme.onBackground.withAlpha(180),
                    ),
                    MySpacing.width(4),
                    MyText.bodySmall(
                      '${doctor.ratings} | ${doctor.reviews} Reviews',
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
  }

  List<Widget> _buildUpcomingList() {
    List<Widget> list = [];

    for (int i = 0; i < upcomingList.length; i++) {
      list.add(_buildSingleEvent(upcomingList[i]));

      if (i + 1 < upcomingList.length) list.add(MySpacing.height(16));
    }
    return list;
  }

  List<Widget> _buildCompletedList() {
    List<Widget> list = [];

    list.add(MySpacing.width(16));

    for (int i = 0; i < completedList.length; i++) {
      list.add(_buildSingleEvent(completedList[i], old: true));

      if (i + 1 < completedList.length) list.add(MySpacing.height(16));
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: MyText.bodyLarge(
          'Appointment',
          fontWeight: 700,
        ),
        elevation: 0,
        backgroundColor: theme.scaffoldBackgroundColor,
        automaticallyImplyLeading: false,
        actions: [
          Icon(
            Icons.more_horiz,
            color: theme.colorScheme.onBackground,
            size: 24,
          ),
          MySpacing.width(24)
        ],
      ),
      body: ListView(
        padding: MySpacing.fromLTRB(24, 8, 24, 24),
        children: [
          MyText.titleMedium(
            'List of appointment',
            letterSpacing: 0.5,
            fontWeight: 700,
          ),
          MySpacing.height(16),
          // Column(
          //   children: _buildDoctorList(),
          // ),
        ],
      ),
    );
  }
}