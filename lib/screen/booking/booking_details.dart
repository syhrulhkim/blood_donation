import 'package:blood_donation/models/appointment.dart';
import 'package:blood_donation/models/hospital.dart';
import 'package:blood_donation/models/user.dart';
import 'package:blood_donation/theme/app_theme.dart';
import 'package:blood_donation/theme/custom_theme.dart';
import 'package:flutter/material.dart';

class AppointmentDetails extends StatefulWidget {
  final Map<String, dynamic> appointment;
  final Hospital hospital;
  final Users user;
  const AppointmentDetails(this.appointment, this.hospital, this.user);

  @override
  State<AppointmentDetails> createState() => _AppointmentDetailsState();
}

class _AppointmentDetailsState extends State<AppointmentDetails> {
  late ThemeData theme;
  late CustomTheme customTheme;
  late Map<String, dynamic> appointment;
  late Hospital hospital;
  late Users user;
  
  @override
  void initState() {
    super.initState();
    theme = AppTheme.theme;
    customTheme = AppTheme.customTheme;
    hospital = widget.hospital;
    appointment = widget.appointment;
    user = widget.user;
    print("user : ${user}");
    print("hospital : ${hospital}");
    print("appointment : ${appointment}");
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}