class CalendarModel {
  DateTime focusedDay;
  DateTime? selectedDay;

  CalendarModel({
    required this.focusedDay,
    this.selectedDay,
  });

  bool isSameDay(DateTime day) => day.year == focusedDay.year &&
    day.month == focusedDay.month && day.day == focusedDay.day;
}
