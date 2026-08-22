// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:time_verse/config/services/alerm_notification_service.dart';
import 'package:time_verse/config/services/alerm_service.dart';
import 'package:time_verse/core/components/custom_dialogue.dart';
import 'package:time_verse/features/all_events/model/event_model.dart';
import 'package:time_verse/features/calender/model/event_category_model.dart';
import 'package:time_verse/features/calender/repository/add_event_repository.dart';
import 'package:time_verse/features/home/controller/home_controller.dart';

class AddEventController extends ChangeNotifier {
  final AddEventRepository _repository;

  AddEventController({AddEventRepository? repository}) : _repository = repository ?? AddEventRepository();

  List<EventCategory> categories = [];
  bool isLoading = false;
  String? selectedCategory;
  String? selectedRepeat;

  int customRepeatCount = 1;
  String customRepeatUnit = 'week'; // 'day', 'week', 'month', 'year'
  List<String> selectedDays = ['S']; // 'S', 'M', 'T', 'W', 'T', 'F', 'S'
  
  String repeatEndType = 'Never'; // 'Never', 'On', 'After'
  
  // Dynamic custom end date state
  DateTime? _customEndDate;

  DateTime get customEndDate {
    if (_customEndDate != null) return _customEndDate!;
    
    // Dynamic fallback based on dateController text or current date (+30 days)
    if (dateController.text.isNotEmpty) {
      final parsedDate = DateTime.tryParse(dateController.text);
      if (parsedDate != null) {
        return parsedDate.add(const Duration(days: 30));
      }
    }
    return DateTime.now().add(const Duration(days: 30));
  }

  set customEndDate(DateTime value) {
    _customEndDate = value;
    notifyListeners();
  }

  int customOccurrences = 1;

  // Options List
  final List<String> repeatOptions = [
    "Don't repeat",
    'Every 1 day',
    'Every 1 week',
    'Every 1 month',
    'Every 1 year',
    'Custom...',
  ];

  static const Map<String, String?> _repeatMap = {
    "Don't repeat": '',
    'Every 1 day': 'Every 1 day',
    'Every 1 week': 'Every 1 week',
    'Every 1 month': 'Every 1 month',
    'Every 1 year': 'Every 1 year',
  };

  void selectRepeat(String label) {
    selectedRepeat = label;
    notifyListeners();
  }

  void setCustomRepeat({
    required int count,
    required String unit,
    required List<String> days,
    required String endType,
    required DateTime endDate,
    required int occurrences,
  }) {
    customRepeatCount = count;
    customRepeatUnit = unit;
    selectedDays = days;
    repeatEndType = endType;
    _customEndDate = endDate;
    customOccurrences = occurrences;
    selectedRepeat = 'Custom';
    notifyListeners();
  }

  String get displayRepeatText {
    if (selectedRepeat == 'Custom') {
      final unitStr = customRepeatUnit.toLowerCase();
      final plural = customRepeatCount > 1 ? 's' : '';
      return 'Every $customRepeatCount $unitStr$plural';
    }
    return selectedRepeat ?? "Don't repeat";
  }

  String? get apiRepeatValue {
    if (selectedRepeat == 'Custom') {
      final unitStr = customRepeatUnit.toLowerCase();
      final plural = customRepeatCount > 1 ? 's' : '';
      return 'Every $customRepeatCount $unitStr$plural';
    }
    return _repeatMap[selectedRepeat] ?? selectedRepeat;
  }
  // Text Controllers
  final titleController = TextEditingController();
  final dateController = TextEditingController();
  final startTimeController = TextEditingController();
  final endTimeController = TextEditingController();
  final locationController = TextEditingController();
  final alarmTimeController = TextEditingController();
  final noteController = TextEditingController();

  List<TextEditingController> get _allControllers => [
    titleController,
    dateController,
    startTimeController,
    endTimeController,
    locationController,
    alarmTimeController,
    noteController,
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

  Future<void> fetchCategories() async {
    try {
      isLoading = true;
      notifyListeners();
      categories = await _repository.fetchCategories();
    } catch (e) {
      debugPrint('Error fetching categories: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  String? validateFields({required String title,required String date,required String startTime,required String endTime,}) {
    if (title.trim().isEmpty) return "Event title is required";
    if (date.trim().isEmpty) return "Event date is required";
    if (startTime.trim().isEmpty) return "Start time is required";
    if (endTime.trim().isEmpty) return "End time is required";
    return null;
  }

  Future<void> saveEvent({
    required BuildContext context,
    required String rawStart,
    required String rawEnd,
    required String rawAlarm,
    required VoidCallback onSuccess,
  }) async {
    final start = _cleanTimeStr(rawStart);
    final end = _cleanTimeStr(rawEnd);
    final calculatedAlarmTime = _calculateAlarmOffset(start, rawAlarm.trim());
    final formattedAlarmISO =
        _formatAlarmISO(dateController.text, calculatedAlarmTime);

    final validationError = validateFields(
      title: titleController.text,
      date: dateController.text,
      startTime: start,
      endTime: end,
    );

    if (validationError != null) {
      await showMessageDialog(
        context,
        validationError,
        title: 'Validation Error',
        icon: Icons.warning_amber_outlined,
        iconColor: Colors.orange,
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final result = await _repository.createTask(
        title: titleController.text.trim(),
        date: _parseBackendDate(dateController.text.trim()),
        startTime: start,
        endTime: end,
        location: locationController.text.trim().isEmpty
            ? null
            : locationController.text.trim(),
        alarmTime: formattedAlarmISO,
        categoryName:
            selectedCategory?.isEmpty == true ? null : selectedCategory,
        note: noteController.text.trim(),
        repeat: apiRepeatValue,
      );

      if (context.mounted) Navigator.pop(context);

      if (result != null) {
        final resultMap = Map<String, dynamic>.from(result);
        if (resultMap['alarm_time'] == null ||
            resultMap['alarm_time'].toString().isEmpty) {
          resultMap['alarm_time'] = formattedAlarmISO;
        }

        final eventModel = EventModel.fromMap(resultMap);
        await AlarmHelper.scheduleEventAlarm(eventModel);

        // Schedule Banner Notification
        try {
          final alarmDateTime = DateTime.tryParse(
              resultMap['alarm_time'].toString().replaceAll('Z', ''));
          if (alarmDateTime != null) {
            await NotificationService.scheduleNotification(
              id: eventModel.id,
              title: eventModel.title,
              body: eventModel.description,
              alarmTime: alarmDateTime,
              payload: eventModel.id.toString(),
            );
          }
        } catch (e) {
          debugPrint("⚠️ Notification error: $e");
        }

        clearFields();
        onSuccess();
        if (context.mounted) {
          await showMessageDialog(
            context,
            'Saved successfully',
            title: 'Success',
            icon: Icons.check_circle_outline,
            iconColor: Colors.green,
          );
          await context.read<HomeController>().fetchEvents();
          if (context.mounted) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (context.mounted) {
                context.push('/event_details', extra: result['id'] as int);
              }
            });
          }
        }
      }
    } catch (e) {
      if (context.mounted) Navigator.pop(context);
      if (context.mounted) {
        await showMessageDialog(
          context,
          'Failed to save event:\n${_formatErrorMessage(e)}',
          title: 'Error',
          icon: Icons.error_outline,
          iconColor: Colors.red,
        );
      }
    }
  }

  // --- CONSOLIDATED TIME & DATE UTILITIES ---

  /// Standardizes any time string (12h AM/PM or 24h) to "HH:mm" format.
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
    if (alarmClean.isEmpty || startTimeClean.isEmpty) return startTimeClean;
    try {
      final lowerAlarm = alarmClean.toLowerCase();
      // If user provided a direct time (e.g., "09:50 AM" or "21:50")
      if (lowerAlarm.contains(':') || lowerAlarm.contains('am') || lowerAlarm.contains('pm')) {
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
      debugPrint("⚠️ Failed to parse offset: $e");
      return startTimeClean;
    }
  }

  /// Parses date & time into a combined local DateTime object.
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
    final hour = timeParts.length > 0 ? int.tryParse(timeParts[0]) ?? 0 : 0;
    final minute = timeParts.length > 1 ? int.tryParse(timeParts[1]) ?? 0 : 0;

    return DateTime(parsedDate.year, parsedDate.month, parsedDate.day, hour, minute);
  }

  /// Formats date and time into local ISO 8601 String (`yyyy-MM-ddTHH:mm:ss`).
  String _formatAlarmISO(String date, String time) {
    try {
      final dt = _parseDateTime(date, time);
      return DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(dt);
    } catch (_) {
      return "${_parseBackendDate(date)}T00:00:00";
    }
  }

  /// Normalizes any date string into `yyyy-MM-dd`.
  String _parseBackendDate(String rawDateText) {
    for (final format in _dateFormats) {
      try {
        return DateFormat("yyyy-MM-dd").format(format.parse(rawDateText));
      } catch (_) {}
    }
    try {
      return DateFormat("yyyy-MM-dd").format(DateTime.parse(rawDateText));
    } catch (_) {
      return rawDateText;
    }
  }

  String _formatErrorMessage(dynamic e) {
    if (e is DioException && e.response?.data is Map) {
      return (e.response!.data as Map).entries.map((entry) => "${entry.key}: ${entry.value.toString().replaceAll('[', '').replaceAll(']', '')}").join("\n");
    } else if (e is DioException) {
      return e.response?.data?.toString() ?? e.message ?? "Unknown server error";
    }
    return e.toString();
  }

  void selectCategory(String categoryName) {
    selectedCategory = categoryName;
    notifyListeners();
  }

  
  void clearFields() {
    for (var controller in _allControllers) {
      controller.clear();
    }
    selectedCategory = null;
    selectedRepeat = null;
    notifyListeners();
  }

  @override
  void dispose() {
    for (var controller in _allControllers) {
      controller.dispose();
    }
    super.dispose();
  }
}