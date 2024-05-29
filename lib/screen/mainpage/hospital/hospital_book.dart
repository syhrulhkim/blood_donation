import 'package:blood_donation/api/booking_api.dart';
import 'package:blood_donation/models/date_time.dart';
import 'package:blood_donation/models/hospital.dart';
import 'package:blood_donation/models/slot.dart';
import 'package:blood_donation/models/user.dart';
import 'package:blood_donation/screen/mainpage/mainpage.dart';
import 'package:blood_donation/theme/app_theme.dart';
import 'package:blood_donation/widgets/my_button.dart';
import 'package:blood_donation/widgets/my_container.dart';
import 'package:blood_donation/widgets/my_spacing.dart';
import 'package:blood_donation/widgets/my_text.dart';
import 'package:flutter/material.dart';

class HospitalBooking extends StatefulWidget {
  final Hospital hospital;
  final Users user;
  const HospitalBooking(this.hospital, this.user);

  @override
  State<HospitalBooking> createState() => _HospitalBookingState();
}

class _HospitalBookingState extends State<HospitalBooking> {
  late Hospital hospital;
  late Users user;
  late ThemeData theme;
  late CustomTheme customTheme;
  late int selectedDate = 0;
  late int selectedSlot = 0;

  late List<MyDateTime> data;
  late List<String> morningSlots;
  late List<String> afternoonSlots;
  late List<String> eveningSlots;
  String selectedTime = '';

  @override
  initState() {
    super.initState();
    theme = AppTheme.theme;
    customTheme = AppTheme.customTheme;
    data = MyDateTime.filteredList();
    morningSlots = Slot.morningList();
    afternoonSlots = Slot.afternoonList();
    eveningSlots = Slot.eveningList();
    hospital = widget.hospital;
    user = widget.user;
  }

  List<Widget> _buildDateList() {
    List<Widget> list = [];
    for (int i = 0; i < data.length; i++) {
      // Convert the String date to a DateTime object
      DateTime dateTime = DateTime.parse(data[i].date);
      list.add(
        _buildSingleDate(date: dateTime, day: data[i].day, index: i)
      );
    }
    return list;
  }

  List<Widget> _buildMorningSlotList() {
    List<Widget> list = [];
    for (int i = 0; i < morningSlots.length; i++) {
      list.add(_buildSingleSlot(time: morningSlots[i], index: i));
    }
    return list;
  }

  List<Widget> _buildAfternoonSlotList() {
    List<Widget> list = [];
    for (int i = 0; i < afternoonSlots.length; i++) {
      list.add(_buildSingleSlot(
          time: afternoonSlots[i], index: i + morningSlots.length));
    }
    return list;
  }

  List<Widget> _buildEveningSlotList() {
    List<Widget> list = [];
    for (int i = 0; i < eveningSlots.length; i++) {
      list.add(_buildSingleSlot(
          time: eveningSlots[i],
          index: i + morningSlots.length + afternoonSlots.length));
    }
    return list;
  }

  Widget _buildSingleSlot({String? time, int? index}) {
    return InkWell(
      onTap: () {
        setState(() {
          selectedSlot = index!;
          selectedTime = time!; // Update selectedTime when slot is tapped
        });
      },
      child: MyContainer(
        color: selectedSlot == index
            ? customTheme.medicarePrimary
            : customTheme.card,
        padding: MySpacing.symmetric(vertical: 8, horizontal: 16),
        borderRadiusAll: 4,
        child: MyText.bodySmall(
          time!,
          color: selectedSlot == index
              ? customTheme.medicareOnPrimary
              : theme.colorScheme.onBackground,
        ),
      ),
    );
  }

  String formatDate(DateTime date) {
    String day = date.day.toString().padLeft(2, '0');
    String month = _getMonthAbbreviation(date.month);
    return '$day $month';
  }

  String _getMonthAbbreviation(int month) {
    switch (month) {
      case 1:
        return 'Jan';
      case 2:
        return 'Feb';
      case 3:
        return 'Mar';
      case 4:
        return 'Apr';
      case 5:
        return 'May';
      case 6:
        return 'Jun';
      case 7:
        return 'Jul';
      case 8:
        return 'Aug';
      case 9:
        return 'Sep';
      case 10:
        return 'Oct';
      case 11:
        return 'Nov';
      case 12:
        return 'Dec';
      default:
        return '';
    }
  }

  Widget _buildSingleDate({DateTime? date, String? day, int? index}) {
    return InkWell(
      onTap: () {
        setState(() {
          selectedDate = index! + 1; // Adjust selectedDate to match the index
        });
      },
      child: MyContainer(
        paddingAll: 12,
        color: selectedDate == index! + 1 // Adjust the comparison
            ? customTheme.medicarePrimary
            : Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            MyText.bodySmall(
              day!,
              color: selectedDate == index! + 1 // Adjust the comparison
                  ? customTheme.medicareOnPrimary
                  : theme.colorScheme.onBackground,
              fontWeight: 800,
            ),
            MySpacing.height(12),
            MyText.bodySmall(
              formatDate(date!), 
              color: selectedDate == index! + 1 // Adjust the comparison
                  ? customTheme.medicareOnPrimary
                  : theme.colorScheme.onBackground,
              fontWeight: 700,
            ),
          ],
        ),
      ),
    );
  }

  
  void bookAppointment(DateTime selectedDate, String selectedTime) async{
    try {
      // Parse the selectedTime to get hours and minutes
      List<String> timeParts = selectedTime.split(':');
      int hours = int.parse(timeParts[0]);
      int minutes = int.parse(timeParts[1].split(' ')[0]); // Extract minutes
      String period = timeParts[1].split(' ')[1]; // Extract AM/PM

      // Convert hours to 24-hour format if needed
      if (period == 'pm' && hours < 12) {
        hours += 12;
      } else if (period == 'am' && hours == 12) {
        hours = 0;
      }

      // Create a new DateTime object with the selected date and time
      DateTime appointmentDateTime = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        hours,
        minutes,
      );
      String userId = widget.user.donorID;
      String hospitalID = widget.hospital.hospitalID;

      await BookingAPI().submitAppointment(appointmentDateTime, userId, hospitalID);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainPage()),
      );
    } catch (e) {
      print("Error booking appointment: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to book appointment'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: customTheme.card,
        centerTitle: true,
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back,
            )),
        elevation: 0,
        title: MyText.bodyLarge('Appointment', fontWeight: 700),
      ),
      body: Container(
        color: customTheme.card,
        child: Column(
          children: [
            Container(
              padding: MySpacing.nRight(16),
              color: customTheme.card,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _buildDateList(),
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: MySpacing.all(24),
                children: [
                  MyText('Morning Slots', fontWeight: 800),
                  MySpacing.height(8),
                  Wrap(
                    spacing: 16,
                    runSpacing: 12,
                    children: _buildMorningSlotList(),
                  ),
                  MySpacing.height(32),
                  MyText('Afternoon Slots', fontWeight: 800),
                  MySpacing.height(8),
                  Wrap(
                    spacing: 16,
                    runSpacing: 12,
                    children: _buildAfternoonSlotList(),
                  ),
                  MySpacing.height(32),
                  MyText('Evening Slots', fontWeight: 800),
                  MySpacing.height(8),
                  Wrap(
                    spacing: 16,
                    runSpacing: 12,
                    children: _buildEveningSlotList(),
                  ),
                ],
              ),
            ),
            Padding(
              padding: MySpacing.all(24),
              child: MyButton.block(
                borderRadiusAll: 8,
                elevation: 0,
                onPressed: () {
                  if (selectedDate != 0 && selectedTime.isNotEmpty) {
                    DateTime selectedDateTime = DateTime.parse(data[selectedDate - 1].date);
                    bookAppointment(selectedDateTime, selectedTime);
                  } else {
                    // Handle case where no date or time is selected
                    print('Please select a date and time');
                  }
                },
                backgroundColor: customTheme.medicarePrimary,
                child: MyText("Confirm Appointment",
                    fontWeight: 700, color: customTheme.medicareOnPrimary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
