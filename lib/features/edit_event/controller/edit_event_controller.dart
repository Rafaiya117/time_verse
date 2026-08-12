// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:time_verse/config/services/alerm_notification_service.dart';
import 'package:time_verse/config/services/alerm_service.dart';
import 'package:time_verse/features/edit_event/model/edit_event_model.dart';
import 'package:time_verse/features/edit_event/repository/edit_event_repo.dart';

class EditEventController extends ChangeNotifier {
  final EditEventRepository _repository = EditEventRepository();

  // Form Controllers
  final titleController = TextEditingController();
  final noteController = TextEditingController();
  final locationController = TextEditingController();
  final dateController = TextEditingController();
  final startTimeController = TextEditingController();
  final endTimeController = TextEditingController();

  // Selected State
  List<EditCategoryModel> categories = [];
  String? selectedCategory;
  String? selectedRepeat;
  String? selectedReminder;
  bool isLoading = true;

  // Options Lists
  final List<String> reminderOptions = [
    'None',
    '5 minutes before',
    '10 minutes before',
    '15 minutes before',
    '30 minutes before',
    '1 hour before',
    '1 day before',
  ];

  final List<String> repeatOptions = [
    "Don't repeat",
    'Every 1 day',
    'Every 1 week',
    'Every 1 month',
    'Every 1 year',
  ];

  static final List<DateFormat> _dateFormats = [
    DateFormat("yyyy-MM-dd"),
    DateFormat("dd/MM/yyyy"),
    DateFormat("dd-MM-yyyy"),
    DateFormat("MM/dd/yyyy"),
    DateFormat("MM-dd-yyyy"),
    DateFormat("EEEE, MMMM d, yyyy"),
    DateFormat("MMMM d, yyyy"),
    DateFormat("d MMMM yyyy"),
  ];

  Future<void> initEditPage(String eventId) async {
    isLoading = true;
    notifyListeners();

    try {
      categories = await _repository.getCategories();
      final eventDetails = await _repository.getEventDetails(eventId);

      if (eventDetails != null) {
        titleController.text = eventDetails.title ?? '';
        noteController.text = eventDetails.note ?? '';
        locationController.text = eventDetails.location ?? '';
        dateController.text = eventDetails.date != null
            ? DateFormat('MMMM d, yyyy').format(eventDetails.date!)
            : '';
        startTimeController.text = eventDetails.startTime ?? '';
        endTimeController.text = eventDetails.endTime ?? '';

        selectedCategory ??= eventDetails.category?.toString();

        selectedRepeat ??= repeatOptions.contains(eventDetails.repeat)
            ? eventDetails.repeat
            : repeatOptions.first;

        selectedReminder ??= reminderOptions.contains(eventDetails.reminder)
            ? eventDetails.reminder
            : reminderOptions.first;
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void selectCategory(dynamic category) {
    selectedCategory = category?.toString();
    notifyListeners();
  }

  void selectRepeat(String repeat) {
    selectedRepeat = repeat;
    notifyListeners();
  }

  void setSelectedRepeat(String repeat) {
    selectRepeat(repeat);
  }

  void selectReminder(String reminder) {
    selectedReminder = reminder;
    notifyListeners();
  }

  // --- TIME HELPERS FROM ADD EVENT ---
  String _cleanTimeStr(String raw) {
    final clean = raw.trim();
    if (clean.isEmpty) return "00:00";

    if (clean.toLowerCase().contains('am') || clean.toLowerCase().contains('pm')) {
      for (final pattern in ["h:mm a", "hh:mm:ss a", "hh:mm a"]) {
        try {
          return DateFormat("HH:mm").format(DateFormat(pattern).parse(clean));
        } catch (_) {}
      }
    }

    final parts = clean.split(':');
    if (parts.length >= 2) {
      final hour = parts[0].padLeft(2, '0');
      final minute = parts[1].padLeft(2, '0');
      return "$hour:$minute";
    }

    return clean;
  }

  String _calculateAlarmOffset(String startTimeClean, String alarmClean) {
    if (alarmClean.isEmpty || startTimeClean.isEmpty || alarmClean.toLowerCase() == 'none') {
      return startTimeClean;
    }
    try {
      final lowerAlarm = alarmClean.toLowerCase();
      if (lowerAlarm.contains(':') && !lowerAlarm.contains('min') && !lowerAlarm.contains('hour') && !lowerAlarm.contains('hr')) {
        return _cleanTimeStr(lowerAlarm);
      }

      final parts = startTimeClean.split(':');
      final baseTime = DateTime(2026, 1, 1, int.parse(parts[0]), int.parse(parts[1]));

      int minutesBefore = 10;
      final match = RegExp(r'\d+').firstMatch(lowerAlarm);

      if (match != null) {
        final val = int.parse(match.group(0)!);
        if (lowerAlarm.contains('hr') || lowerAlarm.contains('hour')) {
          minutesBefore = val * 60;
        } else if (lowerAlarm.contains('day')) {
          minutesBefore = val * 1440;
        } else {
          minutesBefore = val;
        }
      }

      final calculated = baseTime.subtract(Duration(minutes: minutesBefore));
      return DateFormat("HH:mm:ss").format(calculated);
    } catch (e) {
      return startTimeClean;
    }
  }

  DateTime _parseDateTime(String rawDate, String rawTime) {
    final cleanDate = rawDate.trim();
    final cleanTime = _cleanTimeStr(rawTime);

    DateTime? parsedDate;
    for (final format in _dateFormats) {
      try {
        parsedDate = format.parse(cleanDate);
        break;
      } catch (_) {}
    }
    parsedDate ??= DateTime.tryParse(cleanDate) ?? DateTime.now();

    final timeParts = cleanTime.split(':');
    final hour = timeParts.isNotEmpty ? int.tryParse(timeParts[0]) ?? 0 : 0;
    final minute = timeParts.length > 1 ? int.tryParse(timeParts[1]) ?? 0 : 0;

    return DateTime(parsedDate.year, parsedDate.month, parsedDate.day, hour, minute);
  }

  String _formatAlarmISO(String date, String time) {
    try {
      final dt = _parseDateTime(date, time);
      return DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(dt);
    } catch (_) {
      return date;
    }
  }

  Future<bool> updateEvent({
    required BuildContext context,
    required String eventId,
    String? rawStart,
    String? rawEnd,
    String? rawAlarm,
    VoidCallback? onSuccess,
  }) async {
    int? categoryId;
    try {
      final catObj = categories.firstWhere(
        (c) => c.name.toLowerCase() == selectedCategory?.toLowerCase(),
      );
      categoryId = int.tryParse(catObj.id.toString());
    } catch (_) {
      categoryId = int.tryParse(selectedCategory ?? '');
    }

    // 1. Get correct start, end, and alarm strings
    final effectiveStart = (rawStart != null && rawStart.isNotEmpty)? rawStart: startTimeController.text.trim();
    final effectiveEnd = (rawEnd != null && rawEnd.isNotEmpty)? rawEnd : endTimeController.text.trim();

    final activeReminder = (rawAlarm != null && rawAlarm.isNotEmpty)? rawAlarm : (selectedReminder ?? '');

    // 2. Clean times and calculate ISO string matching AddEvent logic
    final start = _cleanTimeStr(effectiveStart);
    final end = _cleanTimeStr(effectiveEnd);
    final calculatedAlarmTime = _calculateAlarmOffset(
      start,
      activeReminder.trim(),
    );
    final formattedAlarmISO = _formatAlarmISO(
      dateController.text,
      calculatedAlarmTime,
    );

    DateTime? parsedDate;
    if (dateController.text.isNotEmpty) {
      for (final format in _dateFormats) {
        try {
          parsedDate = format.parse(dateController.text);
          break;
        } catch (_) {}
      }
      parsedDate ??= DateTime.tryParse(dateController.text);
    }

    final updatedData = EditEventModel(
      id: eventId,
      title: titleController.text.trim(),
      note: noteController.text.trim(),
      location: locationController.text.trim(),
      date: parsedDate,
      startTime: start,
      endTime: end,
      category: categoryId,
      repeat: selectedRepeat,
      reminder: formattedAlarmISO,
    );

    final resultMap = await _repository.updateEvent(eventId, updatedData);

    if (resultMap != null) {
      try {
        final alarmTimeStr = resultMap['alarm_time']?.toString() ?? formattedAlarmISO;
        await AlarmHelper.scheduleEventAlarm(
          updatedData.toEventModel(overrideAlarmTime: alarmTimeStr),
        );
      } catch (e) {
        debugPrint("⚠️ Alarm scheduling error: $e");
      }
      try {
        final rawAlarmStr = resultMap['alarm_time']?.toString() ?? formattedAlarmISO;
        final alarmDateTime = DateTime.tryParse(rawAlarmStr)?.toLocal();

        if (alarmDateTime != null) {
          await NotificationService.scheduleNotification(
            id: int.tryParse(updatedData.id ?? '') ?? 0,
            title: updatedData.title ?? '',
            body: updatedData.note ?? '',
            alarmTime: alarmDateTime,
            payload: updatedData.id ?? '',
          );
        }
      } catch (e) {
        debugPrint("⚠️ Notification error: $e");
      }

      if (onSuccess != null) {
        onSuccess();
      }
      return true;
    }
    return false;
  }

  @override
  void dispose() {
    titleController.dispose();
    noteController.dispose();
    locationController.dispose();
    dateController.dispose();
    startTimeController.dispose();
    endTimeController.dispose();
    super.dispose();
  }
}