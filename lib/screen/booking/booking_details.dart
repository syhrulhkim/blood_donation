import 'package:blood_donation/models/appointment.dart';
import 'package:blood_donation/models/hospital.dart';
import 'package:blood_donation/models/user.dart';
import 'package:blood_donation/theme/app_theme.dart';
import 'package:blood_donation/theme/custom_theme.dart';
import 'package:blood_donation/widgets/my_container.dart';
import 'package:blood_donation/widgets/my_spacing.dart';
import 'package:blood_donation/widgets/my_text.dart';
import 'package:flutter/material.dart';

class AppointmentDetails extends StatefulWidget {
  final Map<String, dynamic> appointment;
  final Map<String, dynamic> hospital;
  final Map<String, dynamic> user;
  const AppointmentDetails(this.appointment, this.hospital, this.user);

  @override
  State<AppointmentDetails> createState() => _AppointmentDetailsState();
}

class _AppointmentDetailsState extends State<AppointmentDetails> {
  late ThemeData theme;
  late CustomTheme customTheme;
  late Map<String, dynamic> appointment;
  late Map<String, dynamic> hospital;
  late Map<String, dynamic> user;
  
  @override
  void initState() {
    super.initState();
    theme = AppTheme.theme;
    customTheme = AppTheme.customTheme;
    hospital = widget.hospital;
    appointment = widget.appointment;
    user = widget.user;
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
          Row(
            children: [
              MyContainer(
                paddingAll: 0,
                borderRadiusAll: 16,
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                  child: Image.network(
                    "${hospital["hospital_Image"]}",
                    height: 160,
                    width: 120,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              MySpacing.width(24),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyText.bodyLarge(
                      "widget.hospital.hospitalName",
                      fontWeight: 700,
                      fontSize: 18,
                    ),
                    MySpacing.height(8),
                    MyText.bodyMedium(
                      "widget.hospital.hospitalAddress",
                      color: theme.colorScheme.onBackground,
                      xMuted: true,
                    ),
                  ],
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
                Container(
                  margin: MySpacing.bottom(8),
                  child: MyText.titleSmall("Critical Blood Level", fontWeight: 700),
                ),
                MySpacing.height(5),
                // criticalBloodLevel(),
              ],
            ),
          ),
          MySpacing.height(32),
          // displayButton(),
        ],
      ),
    );
  }
}