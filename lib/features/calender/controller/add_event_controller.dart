// ignore_for_file: use_build_context_synchronously, curly_braces_in_flow_control_structures
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:time_verse/core/components/custom_dialogue.dart';
import 'package:time_verse/features/calender/controller/time_controller.dart';
import 'package:time_verse/features/calender/model/event_category_model.dart';
import 'package:time_verse/features/calender/repository/add_event_repository.dart';
import 'package:time_verse/features/calender/repository/event_detail_utils.dart';
import 'package:time_verse/features/calender/services/event_alarm_service.dart';
import 'package:time_verse/features/calender/services/event_services.dart';
import 'package:time_verse/features/home/controller/home_controller.dart';

class AddEventController extends ChangeNotifier {
  final AddEventRepository _repository = AddEventRepository();
  final EventService _eventService = EventService();
  final EventAlarmService _alarmService = EventAlarmService();

  List<EventCategory> categories = [];
  bool isLoading = false;
  bool _isSaving = false;
  String? selectedCategory;
  String? selectedRepeat;

  int customRepeatCount = 1;
  String customRepeatUnit = 'week';
  List<String> selectedDays = ['S'];
  String repeatEndType = 'Never';
  DateTime? _customEndDate;
  int customOccurrences = 1;

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
    'Every 1 day': '1 day',
    'Every 1 week': '1 week',
    'Every 1 month': '1 month',
    'Every 1 year': '1 year',
  };

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

  DateTime get customEndDate {
    if (_customEndDate != null) return _customEndDate!;
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
      return '$customRepeatCount $unitStr$plural';
    }
    if (selectedRepeat == null || selectedRepeat == "Don't repeat") {
      return null;
    }
    return _repeatMap[selectedRepeat] ??
        selectedRepeat?.replaceFirst(RegExp(r'^Every\s+', caseSensitive: false), '').trim();
  }

  Map<String, dynamic>? get customRepeatMap {
    if (selectedRepeat != 'Custom') return null;
    final formattedDays = selectedDays.map((d) => d.split('-').first).toList();
    return {
      "repeat_every": customRepeatCount,
      "repeat_unit": customRepeatUnit.toLowerCase(),
      "repeat_days": formattedDays,
      "ends": repeatEndType.toLowerCase(),
      "end_date": repeatEndType == 'On' ? DateFormat('yyyy-MM-dd').format(customEndDate) : null,
      "end_count": repeatEndType == 'After' ? customOccurrences : null,
    };
  }

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

  String? validateFields({
    required String title,
    required String date,
    required String startTime,
    required String endTime,
  }) {
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
    if (_isSaving) return;
    _isSaving = true;

    final start = EventDateTimeUtils.cleanTimeStr(rawStart);
    final end = EventDateTimeUtils.cleanTimeStr(rawEnd);
    final timePickerController = context.read<TimePickerController>();
    final customAlarm = timePickerController.customAlarmTimeOfDay;

    final String calculatedAlarmTime;
    if (customAlarm != null) {
      final dt = DateTime(0, 1, 1, customAlarm.hour, customAlarm.minute);
      calculatedAlarmTime = DateFormat('HH:mm:ss').format(dt);
    } else {
      calculatedAlarmTime = EventDateTimeUtils.calculateAlarmOffset(start, rawAlarm.trim());
    }

    final formattedAlarmISO = EventDateTimeUtils.formatAlarmISO(dateController.text, calculatedAlarmTime);

    final validationError = validateFields(
      title: titleController.text,
      date: dateController.text,
      startTime: start,
      endTime: end,
    );

    if (validationError != null) {
      _isSaving = false;
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
      final eventModel = await _eventService.createAndSyncEvent(
        title: titleController.text,
        dateText: dateController.text,
        startTime: start,
        endTime: end,
        alarmISO: formattedAlarmISO,
        location: locationController.text,
        categoryName: selectedCategory,
        note: noteController.text,
        apiRepeatValue: apiRepeatValue,
        customRepeatMap: customRepeatMap,
      );

      if (context.mounted) Navigator.pop(context);

      if (eventModel != null) {
        final baseDateTime = EventDateTimeUtils.parseDateTime(dateController.text, calculatedAlarmTime);

        // Schedule alarms and local notifications via EventAlarmService
        await _alarmService.scheduleReminders(
          context: context,
          event: eventModel,
          baseDateTime: baseDateTime,
          selectedRepeat: selectedRepeat,
          customRepeatCount: customRepeatCount,
          customRepeatUnit: customRepeatUnit,
          selectedDays: selectedDays,
          repeatEndType: repeatEndType,
          customEndDate: customEndDate,
          customOccurrences: customOccurrences,
        );

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
        }
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context);
        await showMessageDialog(
          context,
          'Failed to save event:\n${e.toString()}',
          title: 'Error',
          icon: Icons.error_outline,
          iconColor: Colors.red,
        );
      }
    } finally {
      _isSaving = false;
    }
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