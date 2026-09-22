import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// class TimePickerController extends ChangeNotifier {
//   final Map<String, TimeOfDay?> _selectedTimes = {};

//   String _selectedReminderOption = '5 min before';

//   String get selectedReminderOption => _selectedReminderOption;

//   void setReminderOption(String option) {
//     _selectedReminderOption = option;
//     notifyListeners();
//   }

//   TimeOfDay? getTime(String fieldKey) => _selectedTimes[fieldKey];

//   void setTime(String key, TimeOfDay time) {
//     _selectedTimes[key] = time;
//     notifyListeners();
//   }

//   Future<void> selectTime(BuildContext context, String fieldKey) async {
//     final TimeOfDay? picked = await showTimePicker(
//       context: context,
//       initialTime: _selectedTimes[fieldKey] ?? TimeOfDay.now(),
//     );

//     if (picked != null) {
//       _selectedTimes[fieldKey] = picked;
//       if (fieldKey == 'start') {
//         _selectedTimes['end'] = picked;
//       }

//       notifyListeners();
//     }
//   }

//   String formatTime(TimeOfDay? time) {
//     if (time == null) return '';
//     final dt = DateTime(0, 1, 1, time.hour, time.minute);
//     return DateFormat('HH:mm:ss').format(dt);
//   }
// }

class TimePickerController extends ChangeNotifier {
  final Map<String, TimeOfDay?> _selectedTimes = {};

  String _selectedReminderOption = '5 min before';
  TimeOfDay? _customAlarmTimeOfDay; // <-- Added to track custom time

  String get selectedReminderOption => _selectedReminderOption;
  TimeOfDay? get customAlarmTimeOfDay => _customAlarmTimeOfDay; // <-- Getter

  void setReminderOption(String option) {
    _selectedReminderOption = option;
    _customAlarmTimeOfDay = null; // Clear custom time when preset is chosen
    notifyListeners();
  }

  // Added method to handle custom time picking
  void setCustomReminderOption(String formattedTime, TimeOfDay timeOfDay) {
    _selectedReminderOption = formattedTime;
    _customAlarmTimeOfDay = timeOfDay;
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