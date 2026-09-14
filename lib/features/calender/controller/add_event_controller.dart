// ignore_for_file: use_build_context_synchronously, curly_braces_in_flow_control_structures
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:time_verse/config/services/alerm_notification_service.dart';
import 'package:time_verse/config/services/alerm_service.dart';
import 'package:time_verse/config/services/google_service.dart';
import 'package:time_verse/config/services/offline_service.dart';
import 'package:time_verse/core/components/custom_dialogue.dart';
import 'package:time_verse/features/all_events/model/event_model.dart';
import 'package:time_verse/features/calender/model/event_category_model.dart';
import 'package:time_verse/features/calender/repository/add_event_repository.dart';
import 'package:time_verse/features/calender/repository/event_detail_utils.dart';
import 'package:time_verse/features/home/controller/home_controller.dart';

class AddEventController extends ChangeNotifier {
  final AddEventRepository _repository;

  AddEventController({AddEventRepository? repository}): _repository = repository ?? AddEventRepository();

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

  int customOccurrences = 1;

  final List<String> repeatOptions = ["Don't repeat",'Every 1 day','Every 1 week','Every 1 month','Every 1 year','Custom...',];

  static const Map<String, String?> _repeatMap = {"Don't repeat": '','Every 1 day': '1 day','Every 1 week': '1 week','Every 1 month': '1 month','Every 1 year': '1 year',};

  void selectRepeat(String label) {
    selectedRepeat = label;
    notifyListeners();
  }

  void setCustomRepeat({required int count,required String unit,required List<String> days,required String endType,required DateTime endDate,required int occurrences,}) {
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
    return _repeatMap[selectedRepeat] ?? (selectedRepeat?.replaceFirst(RegExp(r'^Every\s+', caseSensitive: false), '').trim());
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

  // Text Controllers
  final titleController = TextEditingController();
  final dateController = TextEditingController();
  final startTimeController = TextEditingController();
  final endTimeController = TextEditingController();
  final locationController = TextEditingController();
  final alarmTimeController = TextEditingController();
  final noteController = TextEditingController();

  List<TextEditingController> get _allControllers => [titleController,dateController,startTimeController,endTimeController,locationController,alarmTimeController,noteController,];

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
  if (_isSaving) return;
  _isSaving = true;

  final start = EventDateTimeUtils.cleanTimeStr(rawStart);
  final end = EventDateTimeUtils.cleanTimeStr(rawEnd);
  final calculatedAlarmTime = EventDateTimeUtils.calculateAlarmOffset(start, rawAlarm.trim());
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
    final result = await _repository.createTask(
      title: titleController.text.trim(),
      date: EventDateTimeUtils.parseBackendDate(dateController.text.trim()),
      startTime: start,
      endTime: end,
      location: locationController.text.trim().isEmpty ? null : locationController.text.trim(),
      alarmTime: formattedAlarmISO,
      categoryName: selectedCategory?.isEmpty == true ? null : selectedCategory,
      note: noteController.text.trim(),
      repeat: apiRepeatValue,
      customRepeat: customRepeatMap,
    );

    if (context.mounted) Navigator.pop(context);

    if (result != null) {
      final resultMap = Map<String, dynamic>.from(result);
      if (resultMap['alarm_time'] == null || resultMap['alarm_time'].toString().isEmpty) {
        resultMap['alarm_time'] = formattedAlarmISO;
      }

      final eventModel = EventModel.fromMap(resultMap);

      // Generate recurring timestamps via repository helper
      final baseDateTime = EventDateTimeUtils.parseDateTime(dateController.text, calculatedAlarmTime);
      final alarmDateTimes = _repository.generateAlarmOccurrences(
        startDateTime: baseDateTime,
        selectedRepeat: selectedRepeat,
        customRepeatCount: customRepeatCount,
        customRepeatUnit: customRepeatUnit,
        selectedDays: selectedDays,
        repeatEndType: repeatEndType,
        customEndDate: customEndDate,
        customOccurrences: customOccurrences,
      );

      // Schedule alarms and local notifications for all occurrences
      await AlarmHelper.scheduleEventAlarm(eventModel, alarmDateTimes);

      try {
        for (int i = 0; i < alarmDateTimes.length; i++) {
          final alarmDt = alarmDateTimes[i];
          await NotificationService.scheduleNotification(
            id: eventModel.id * 100 + i,
            title: eventModel.title,
            body: eventModel.description,
            alarmTime: alarmDt,
            payload: eventModel.id.toString(),
          );
        }
      } catch (e) {
        debugPrint("⚠️ Notification error: $e");
      }

      // Sync to Google Calendar if access token is available
      try {
        final googleToken = await GoogleServices().getValidAccessToken();
        if (googleToken != null && googleToken.isNotEmpty) {
          await GoogleServices().createGoogleCalendarEvent(
            accessToken: googleToken,
            title: titleController.text.trim(),
            date: EventDateTimeUtils.parseBackendDate(dateController.text.trim()),
            startTime: start,
            endTime: end,
            description: noteController.text.trim(),
            location: locationController.text.trim(),
            alarmTimeISO: formattedAlarmISO,
          );
        }
      } catch (e) {
        debugPrint("⚠️ Google Calendar sync error: $e");
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
  } on DioException catch (e) {
    if (context.mounted) Navigator.pop(context);

    if (e.type == DioExceptionType.connectionTimeout || 
        e.type == DioExceptionType.sendTimeout || 
        e.type == DioExceptionType.receiveTimeout || 
        e.type == DioExceptionType.connectionError) {
      final isCustom = apiRepeatValue?.toLowerCase() == 'custom';
      final offlineBody = {
        "title": titleController.text.trim(),
        "date": EventDateTimeUtils.parseBackendDate(dateController.text.trim()),
        "start_time": start,
        "end_time": end,
        "alarm_time": formattedAlarmISO,
        "repeat": isCustom ? "custom" : (apiRepeatValue ?? "1 day"),
        if (isCustom && customRepeatMap != null) "custom_repeat": customRepeatMap,
        "is_alarm_sent":true,
        "is_completed": false,
        if (locationController.text.trim().isNotEmpty) "location": locationController.text.trim(),
        if (selectedCategory?.isNotEmpty == true) "category_name": selectedCategory,
        if (noteController.text.trim().isNotEmpty) "type_event_description": noteController.text.trim(),
      };

      // Save to cache queue
      await OfflineSyncService().saveToQueue(offlineBody);

      // Schedule local alarms offline
      final baseDateTime = EventDateTimeUtils.parseDateTime(dateController.text, calculatedAlarmTime);
      final alarmDateTimes = _repository.generateAlarmOccurrences(
        startDateTime: baseDateTime,
        selectedRepeat: selectedRepeat,
        customRepeatCount: customRepeatCount,
        customRepeatUnit: customRepeatUnit,
        selectedDays: selectedDays,
        repeatEndType: repeatEndType,
        customEndDate: customEndDate,
        customOccurrences: customOccurrences,
      );

      final mockId = DateTime.now().millisecondsSinceEpoch % 100000;
      final mockEventModel = EventModel(
        id: mockId,
        title: titleController.text.trim(),
        description: noteController.text.trim(),
        alarmTime: formattedAlarmISO,
        date: EventDateTimeUtils.parseBackendDate(dateController.text.trim()),
        startTime: start,
        endTime: end,
        location: locationController.text.trim(),
        isCompleted: false,
        isFavorite: false,
        createdAt: DateTime.now().toIso8601String(),
        user: 0,
        userName: '',
      );

      await AlarmHelper.scheduleEventAlarm(mockEventModel, alarmDateTimes);
      clearFields();
      onSuccess();

      if (context.mounted) {
        await showMessageDialog(
          context,
          'Saved offline! Event will sync once connection is restored.',
          title: 'Offline Mode',
          icon: Icons.wifi_off_outlined,
          iconColor: Colors.orange,
        );
        context.pop();
      }
    } else {
      if (context.mounted) {
        await showMessageDialog(
          context,
          'Failed to save event:\n${EventDateTimeUtils.formatErrorMessage(e)}',
          title: 'Error',
          icon: Icons.error_outline,
          iconColor: Colors.red,
        );
      }
    }
  } catch (e) {
    if (context.mounted) Navigator.pop(context);
    if (context.mounted) {
      await showMessageDialog(
        context,
        'Failed to save event:\n${EventDateTimeUtils.formatErrorMessage(e)}',
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