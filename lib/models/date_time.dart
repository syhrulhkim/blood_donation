import 'package:intl/intl.dart';
import 'package:blood_donation/models/slot.dart';

class MyDateTime {
  final String date, day;
  MyDateTime(this.date, this.day);

  static List<MyDateTime> filteredList() {
    List<MyDateTime> list = [];
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day, 7, 0); // Today 7:00 AM
    List<String> allSlots = Slot.morningList() + Slot.afternoonList() + Slot.eveningList();

    // If the current time is past the last slot, start from tomorrow
    if (isPastLastSlot(now, allSlots)) {
      today = today.add(Duration(days: 1));
    }

    // Add today's date
    list.add(MyDateTime(today.toString(), _getDayOfWeek(today)));

    // Add upcoming dates for the next 10 days starting from tomorrow
    for (int i = 1; i <= 10; i++) {
      DateTime nextDate = today.add(Duration(days: i));
      list.add(MyDateTime(nextDate.toString(), _getDayOfWeek(nextDate)));
    }

    return list;
  }

  static bool isPastLastSlot(DateTime dateTime, List<String> slotList) {
    // Convert the current time to minutes for comparison
    int currentHour = dateTime.hour;
    int currentMinute = dateTime.minute;
    int currentTime = currentHour * 60 + currentMinute;

    // Iterate through the slot times to find the last slot time
    int lastSlotTime = 0;
    for (String slotTime in slotList) {
      List<String> timeParts = slotTime.split(':');
      int slotHour = int.parse(timeParts[0]);
      int slotMinute = int.parse(timeParts[1].split(' ')[0]);
      String meridiem = timeParts[1].split(' ')[1];

      // Convert slot time to 24-hour format
      if (meridiem == 'pm' && slotHour != 12) {
        slotHour += 12;
      }

      int slotTimeInMinutes = slotHour * 60 + slotMinute;
      if (slotTimeInMinutes > lastSlotTime) {
        lastSlotTime = slotTimeInMinutes;
      }
    }

    // Check if the current time is past the last slot time
    return currentTime > lastSlotTime;
  }

  static String _getDayOfWeek(DateTime date) {
    DateFormat dateFormat = DateFormat('E', 'en_US');
    return dateFormat.format(date);
  }
}
