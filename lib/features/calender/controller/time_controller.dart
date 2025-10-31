import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:time_verse/features/calender/model/time_model.dart';

class TimePickerController extends ChangeNotifier {
  final TimePickerModel _model = TimePickerModel();

  TimeOfDay? get startTime => _model.startTime;
  TimeOfDay? get endTime => _model.endTime;

  Future<void> selectTime(BuildContext context, bool isStart) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      if (isStart) {
        _model.startTime = picked;
      } else {
        _model.endTime = picked;
      }
      notifyListeners();
    }
  }

  String formatTime(TimeOfDay? time) {
    if (time == null) return '';
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat('hh:mm a').format(dt);
  }
}
