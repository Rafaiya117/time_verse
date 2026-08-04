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

  // Options List (matching EditEventController)
  final List<String> repeatOptions = [
    "Don't repeat",
    'Every 1 day',
    'Every 1 week',
    'Every 1 month',
    'Every 1 year',
  ];

  // Map user UI text to backend API choice keys
  static const Map<String, String?> _repeatMap = {
    "Don't repeat": null,
    'Every 1 day': 'Every 1 day',
    'Every 1 week': 'Every 1 week',
    'Every 1 month': 'Every 1 month',
    'Every 1 year': 'Every 1 year',
  };

  String? get apiRepeatValue => _repeatMap[selectedRepeat] ?? selectedRepeat;

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
    final start = _cleanTimeStr(rawStart);
    final end = _cleanTimeStr(rawEnd);
    final calculatedAlarmTime = _calculateAlarmOffset(start, rawAlarm.trim());
    final formattedAlarmISO = _formatAlarmTime(dateController.text, calculatedAlarmTime);

    final validationError = validateFields(
      title: titleController.text,
      date: dateController.text,
      startTime: start,
      endTime: end,
    );

    if (validationError != null) {
      await showMessageDialog(
        context, validationError,
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
        location: locationController.text.trim().isEmpty ? null : locationController.text.trim(),
        alarmTime: formattedAlarmISO,
        categoryName: selectedCategory?.isEmpty == true ? null : selectedCategory,
        note: noteController.text.trim(),
        repeat: apiRepeatValue,
      );

      if (context.mounted) Navigator.pop(context);

      if (result != null) {
        await AlarmHelper.scheduleEventAlarm(EventModel.fromMap(result));

        try {
          final alarmTime = DateTime.tryParse(result['alarm_time'] ?? '');
          if (alarmTime != null) {
            await NotificationService.scheduleNotification(
              id: result['id'],
              title: result['title'],
              body: result['description'],
              alarmTime: alarmTime,
              payload: result['id'],
            );
          }
        } catch (e) {
          debugPrint("⚠️ Notification error: $e");
        }

        clearFields();
        onSuccess();

        if (context.mounted) {
          await showMessageDialog(
            context, 'Saved successfully',
            title: 'Success',
            icon: Icons.check_circle_outline,
            iconColor: Colors.green,
          );
          await context.read<HomeController>().fetchEvents();
          context.push('/event_details', extra: result['id'] as int);
        }
      }
    } catch (e) {
      if (context.mounted) Navigator.pop(context);
      if (context.mounted) {
        await showMessageDialog(
          context, 'Failed to save event:\n${_formatErrorMessage(e)}',
          title: 'Error',
          icon: Icons.error_outline,
          iconColor: Colors.red,
        );
      }
    }
  }

  // --- Helper Formatters ---
  String _formatAlarmTime(String date, String time) {
    final cleanDate = date.trim();
    final cleanTime = time.trim();

    if (cleanTime.isEmpty) return "${cleanDate}T00:00:00";

    try {
      final timeFormatter = cleanTime.split(':').length == 3
          ? DateFormat("HH:mm:ss")
          : DateFormat("HH:mm");

      DateTime? parsedDate;
      for (final format in _dateFormats) {
        try {
          parsedDate = format.parse(cleanDate);
          break;
        } catch (_) {}
      }
      parsedDate ??= DateTime.parse(cleanDate);

      final parsedTime = timeFormatter.parse(cleanTime);
      final combined = DateTime(
        parsedDate.year, parsedDate.month, parsedDate.day,
        parsedTime.hour, parsedTime.minute, parsedTime.second,
      );

      return DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(combined);
    } catch (_) {
      return "${date}T00:00:00";
    }
  }

  void selectCategory(String categoryName) {
    selectedCategory = categoryName;
    notifyListeners();
  }

  void selectRepeat(String? repeat) {
    selectedRepeat = repeat;
    notifyListeners();
  }

  String _cleanTimeStr(String timeRaw) {
    final clean = timeRaw.trim();
    if (clean.toLowerCase().contains('am') || clean.toLowerCase().contains('pm')) {
      try {
        return DateFormat("HH:mm").format(DateFormat("h:mm a").parse(clean));
      } catch (_) {}
    }
    return clean;
  }

  String _calculateAlarmOffset(String start, String alarmClean) {
    if (alarmClean.isEmpty || start.isEmpty) return start;
    try {
      final parsedStart = DateFormat("HH:mm").parse(start);
      Duration offset = const Duration(minutes: 10);

      if (alarmClean.contains('5 min')) offset = const Duration(minutes: 5);
      else if (alarmClean.contains('10 min')) offset = const Duration(minutes: 10);
      else if (alarmClean.contains('30 min')) offset = const Duration(minutes: 30);
      else if (alarmClean.contains('1 hr') || alarmClean.contains('60 min')) offset = const Duration(hours: 1);

      return DateFormat("HH:mm").format(parsedStart.subtract(offset));
    } catch (_) {
      return start;
    }
  }

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