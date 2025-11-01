import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimePickerController extends ChangeNotifier {
  final Map<String, TimeOfDay?> _selectedTimes = {};

  TimeOfDay? getTime(String fieldKey) => _selectedTimes[fieldKey];

  Future<void> selectTime(BuildContext context, String fieldKey) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTimes[fieldKey] ?? TimeOfDay.now(),
    );

    if (picked != null) {
      _selectedTimes[fieldKey] = picked;
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
