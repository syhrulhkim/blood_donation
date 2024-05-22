// import 'package:flutkit/full_apps/other/medicare/appointment_screen.dart';
// import 'package:flutkit/full_apps/other/medicare/models/chat.dart';
// import 'package:flutkit/full_apps/other/medicare/models/doctor.dart';
// import 'package:flutkit/full_apps/other/medicare/single_chat_screen.dart';
import 'package:blood_donation/api/hospital_api.dart';
import 'package:blood_donation/extensions/string.dart';
import 'package:blood_donation/models/hospital.dart';
import 'package:blood_donation/models/user.dart';
import 'package:blood_donation/screen/mainpage/hospital/hospital_book.dart';
import 'package:blood_donation/screen/mainpage/hospital/hospital_edit.dart';
import 'package:blood_donation/screen/mainpage/mainpage.dart';
import 'package:blood_donation/theme/app_theme.dart';
import 'package:blood_donation/widgets/my_button.dart';
import 'package:blood_donation/widgets/my_container.dart';
import 'package:blood_donation/widgets/my_spacing.dart';
import 'package:blood_donation/widgets/my_text.dart';
import 'package:blood_donation/widgets/my_text_style.dart';
import 'package:flutter/material.dart';

class HospitalDetails extends StatefulWidget {
  final Hospital hospital;
  final Users user;
  const HospitalDetails(this.hospital, this.user);

  @override
  State<HospitalDetails> createState() => _HospitalDetailsState();
}

class _HospitalDetailsState extends State<HospitalDetails> {
  late Hospital hospital;
  late Users user;
  late var bloodLevel;
  late ThemeData theme;
  late CustomTheme customTheme;
  List<bool> isSelected = [false, true, false];

  @override
  void initState() {
    super.initState();
    theme = AppTheme.theme;
    customTheme = AppTheme.customTheme;
    hospital = widget.hospital;
    bloodLevel = widget.hospital.bloodLevels;
    user = widget.user;
    print("hospital : ${hospital}");
  }

  deleteHospital(hospitalId) async {
    try {
      await HospitalAPI().deleteHospital(hospitalId);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainPage()),
      );
    } catch (error) {
      print("Failed to delete hospital: $error");
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete hospital')),
      );
    }
  }

  displayButton() {
    var userRole = widget.user.donorRole;

    switch (userRole) {
      case "admin":
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
                    builder: (context) => HospitalEdit(widget.hospital),
                  ),
                );
              },
              child: MyText.bodyLarge(
                'Edit',
                color: AppTheme.customTheme.medicareOnPrimary,
                fontWeight: 600,
              ),
            ),
            MySpacing.height(5),
            MyButton.block(
              elevation: 0,
              borderRadiusAll: 8,
              padding: MySpacing.y(20),
              backgroundColor: Colors.red[400],
              onPressed: () async {
                deleteHospital(widget.hospital.hospitalID);
              },
              child: MyText.bodyLarge(
                'Delete',
                color: AppTheme.customTheme.medicareOnPrimary,
                fontWeight: 600,
              ),
            ),
          ],
        );
      case "user":
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
                    builder: (context) => HospitalBooking(widget.hospital, widget.user),
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
      default:
        return SizedBox();
    }
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
              bloodLevel.length,
              (index) => Container(
                width: 75,
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
                            child: Text("${extractBloodType(bloodLevel[index].bloodType)}"),
                          ),
                          SizedBox(width: MediaQuery.of(context).size.width * 0.01),
                          MyContainer(
                            color: getColorForPercent(bloodLevel[index].percent),
                            paddingAll: 4,
                            child: Text(
                              "${bloodLevel[index].percent}%",
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
                    widget.hospital.hospitalImage,
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
                      widget.hospital.hospitalName,
                      fontWeight: 700,
                      fontSize: 18,
                    ),
                    MySpacing.height(8),
                    MyText.bodyMedium(
                      widget.hospital.hospitalAddress,
                      color: theme.colorScheme.onBackground,
                      xMuted: true,
                    ),
                    MySpacing.height(12),
                    Row(
                      children: [
                        MyContainer(
                          paddingAll: 8,
                          child: Icon(
                            Icons.star_rounded,
                            color: AppTheme.customTheme.colorWarning,
                          ),
                        ),
                        MySpacing.width(16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            MyText.bodySmall(
                              'Rating',
                              color: theme.colorScheme.onBackground,
                              xMuted: true,
                            ),
                            MySpacing.height(2),
                            MyText.bodySmall(
                              '4 out of 5',
                              color: theme.colorScheme.onBackground,
                              fontWeight: 700,
                            ),
                          ],
                        ),
                      ],
                    ),
                    MySpacing.height(8),
                    Row(
                      children: [
                        MyContainer(
                          paddingAll: 8,
                          child: Icon(
                            Icons.group,
                            color: CustomTheme.blue,
                          ),
                        ),
                        MySpacing.width(16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            MyText.bodySmall(
                              'Patients',
                              color: theme.colorScheme.onBackground,
                              xMuted: true,
                            ),
                            MySpacing.height(2),
                            MyText.bodySmall(
                              '1000+',
                              color: theme.colorScheme.onBackground,
                              fontWeight: 700,
                            ),
                          ],
                        ),
                      ],
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
                criticalBloodLevel(),
                MySpacing.height(24),
                MyText.bodyLarge(
                  'Location',
                  fontWeight: 600,
                ),
                MySpacing.height(16),
                MyContainer(
                  paddingAll: 0,
                  borderRadiusAll: 16,
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                    child: Image(
                      fit: BoxFit.cover,
                      height: 140,
                      width: MediaQuery.of(context).size.width - 96,
                      image: AssetImage('assets/other/map-md-snap.png'),
                    ),
                  ),
                ),
              ],
            ),
          ),
          MySpacing.height(32),
          displayButton(),
        ],
      ),
    );
  }
}