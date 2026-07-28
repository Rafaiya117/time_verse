import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimePickerController extends ChangeNotifier {
  final Map<String, TimeOfDay?> _selectedTimes = {};

  // 🛠️ ADDED: Store reminder option selection (e.g. "10 min before")
  String _selectedReminderOption = '10 min before';

  // 🛠️ ADDED: Getter for selectedReminderOption
  String get selectedReminderOption => _selectedReminderOption;

  // 🛠️ ADDED: Method to update the selected option
  void setReminderOption(String option) {
    _selectedReminderOption = option;
    notifyListeners();
  }

  TimeOfDay? getTime(String fieldKey) => _selectedTimes[fieldKey];

  void setTime(String key, TimeOfDay time) {
    _selectedTimes[key] = time;
    notifyListeners();
  }

  Future<void> selectTime(BuildContext context, String fieldKey) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTimes[fieldKey] ?? TimeOfDay.now(),
    );

    if (picked != null) {
      _selectedTimes[fieldKey] = picked;
      // ✅ DYNAMIC SYNC: If start time is chosen, copy it to end time automatically
      if (fieldKey == 'start') {
        _selectedTimes['end'] = picked;
      }

      notifyListeners();
    }
  }

  String formatTime(TimeOfDay? time) {
    if (time == null) return '';
    final dt = DateTime(0, 1, 1, time.hour, time.minute);
    return DateFormat('HH:mm:ss').format(dt);
  }
}