class MyDateTime {
  final String date, day;
  MyDateTime(this.date, this.day);

  static List<MyDateTime> dummyList() {
    List<MyDateTime> list = [];
    // Get today's date
    DateTime today = DateTime.now();
    // Add today's date
    list.add(MyDateTime(today.toString(), _getDayOfWeek(today)));
    // Add upcoming dates for the next 10 days
    for (int i = 1; i <= 10; i++) {
      DateTime nextDate = today.add(Duration(days: i));
      list.add(MyDateTime(nextDate.toString(), _getDayOfWeek(nextDate)));
    }
    return list;
  }

  static String _getDayOfWeek(DateTime date) {
    // Days of the week
    List<String> days = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
    // Get the day of the week index
    int dayIndex = date.weekday - 1;
    return days[dayIndex];
  }
}