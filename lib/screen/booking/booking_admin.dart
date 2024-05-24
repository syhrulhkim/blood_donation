import 'package:blood_donation/api/booking_api.dart';
import 'package:blood_donation/screen/booking/booking_details.dart';
import 'package:blood_donation/theme/app_theme.dart';
import 'package:blood_donation/widgets/my_container.dart';
import 'package:blood_donation/widgets/my_spacing.dart';
import 'package:blood_donation/widgets/my_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BookingAdmin extends StatefulWidget {
  const BookingAdmin({super.key});

  @override
  State<BookingAdmin> createState() => _BookingState();
}

class _BookingState extends State<BookingAdmin> {
  late ThemeData theme;
  late CustomTheme customTheme;
  List<Map<String, dynamic>> bookingList = [];

  @override
  void initState() {
    super.initState();
    theme = AppTheme.theme;
    customTheme = AppTheme.customTheme;
    _buildAppointmentList();
  }

  _buildAppointmentList() async {
    BookingAPI bookingAPI = BookingAPI();
    var bookingData = await bookingAPI.appointmentList();

    setState(() {
      print("bookingData: ${bookingData}");
      bookingList = bookingData;
    });
  }

  String formatDateString(String dateString) {
    DateTime dateTime = DateTime.parse(dateString);
    String formattedDate = DateFormat('d MMM yyyy').format(dateTime);    
    return formattedDate;
  }

  String formatTimeString(String dateTimeString) {
    DateTime dateTime = DateTime.parse(dateTimeString);
    String formattedTime = DateFormat('h:mm a').format(dateTime);    
    return formattedTime;
  }

  Widget appointmentList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MyText.titleMedium(
          'List of appointment',
          letterSpacing: 0.5,
          fontWeight: 700,
        ),
        SizedBox(height: 16),
        Expanded(
          child: ListView.builder(
            itemCount: bookingList.length,
            itemBuilder: (context, index) {
              var appointment = bookingList[index];
              var user = appointment['user'];
              var hospital = appointment['hospital'];
              return MyContainer(
                // onTap: () {
                //   Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
                //       builder: (context) => AppointmentDetails(appointment,hospital,user)));
                // },
                margin: MySpacing.bottom(6),
                paddingAll: 12,
                borderRadiusAll: 16,
                child: Row(
                  children: [
                    MyContainer(
                      color: Colors.white,
                      paddingAll: 0,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image(
                          height: 54,
                          width: 54,
                          image: NetworkImage("${hospital["hospital_Image"]}"),
                        ),
                      ),
                    ),
                    MySpacing.width(16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MyText.bodyMedium(
                            "Booked by : ${user["donor_Name"]}",
                            fontWeight: 900,
                          ),
                          MyText.bodySmall(
                            "${hospital["hospital_Name"]}",
                            fontWeight: 100,
                          ),
                        ],
                      ),
                    ),
                    MySpacing.width(8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        MyText.bodySmall(
                          "${formatDateString((appointment["appointment_Date"]).toString())}",
                          fontSize: 10,
                          color: Theme.of(context).colorScheme.onBackground,
                          xMuted: true,
                        ),
                        MyText.bodySmall(
                          "${formatTimeString((appointment["appointment_Date"]).toString())}",
                          fontSize: 10,
                          color: Theme.of(context).colorScheme.onBackground,
                          xMuted: true,
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
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
          // Icon(
          //   Icons.more_horiz,
          //   color: theme.colorScheme.onBackground,
          //   size: 24,
          // ),
          MySpacing.width(24)
        ],
      ),
      body: Padding(
        padding: MySpacing.fromLTRB(24, 8, 24, 24),
        child: appointmentList(),
      ),
      // appointmentList(),
      // body: Column(
      //   children: [
      //     MyText.titleMedium(
      //       'List of appointment',
      //       letterSpacing: 0.5,
      //       fontWeight: 700,
      //     ),
          
      //   ],
      // ),
    );
  }
}