import 'package:flutter/material.dart';
import 'package:time_verse/features/calender/model/calender_model.dart';

class CalendarController extends ChangeNotifier {
  CalendarModel model = CalendarModel(focusedDay: DateTime.now());

  DateTime get focusedDay => model.focusedDay;
  DateTime? get selectedDay => model.selectedDay;

  void onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    model
      ..selectedDay = selectedDay
      ..focusedDay = focusedDay;
    notifyListeners();
  }
}
