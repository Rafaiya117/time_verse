import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:time_verse/config/app_route/app_prefernce.dart';
import 'package:time_verse/config/services/alerm_notification_service.dart';
import 'package:time_verse/config/services/alerm_service.dart';
import 'package:time_verse/config/services/google_service.dart';
import 'package:time_verse/core/components/custom_dialogue.dart';
import 'package:time_verse/features/all_events/model/event_model.dart';
import 'package:time_verse/features/auth/auth_service/auth_service.dart';
import 'package:time_verse/features/calender/model/event_category_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:time_verse/features/home/controller/home_controller.dart';

class AddEventController extends ChangeNotifier {
  final Dio _dio = Dio();
  final AuthService _authService = AuthService();
  
  List<EventCategory> categories = [];
  bool isLoading = false;
  String? selectedCategory;

  // Grouped Text Editing Controllers
  final TextEditingController titleController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController startTimeController = TextEditingController();
  final TextEditingController endTimeController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController alarmTimeController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  // Optimized Date Formats List (Declared static final to avoid re-allocation on every save)
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

  Future<Options> _authorizedHeader() async {
    final token = await _authService.getToken();
    return Options(
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
  }

  Future<void> fetchCategories() async {
    try {
      isLoading = true;
      notifyListeners();
      
      final options = await _authorizedHeader();
      final response = await _dio.get(
        '${dotenv.env['BASE_URL']}api/v1/categories/',
        options: options,
      );

      if (response.statusCode == 200 && response.data is List) {
        categories = (response.data as List)
            .map((json) => EventCategory.fromJson(json))
            .toList();
      } else {
        debugPrint('Failed to load categories: ${response.statusCode}');
      }
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
    //required String note,
  }) {
    if (title.trim().isEmpty) return "Event title is required";
    if (date.trim().isEmpty) return "Event date is required";
    if (startTime.trim().isEmpty) return "Start time is required";
    if (endTime.trim().isEmpty) return "End time is required";
    //if (note.trim().isEmpty) return "Note/description is required";
    return null; 
  }

  Future<Map<String, dynamic>?> createTask({
    required String title,
    required String date,
    required String startTime,
    required String endTime,
    String? location,
    required String alarmTime,
    String? categoryName,
    bool isCompleted = false,
    String? note,
  }) async {
    final baseUrl = dotenv.env['BASE_URL'] ?? '';
    final accessToken = await _authService.getToken();
    final url = "$baseUrl/api/v1/event/create/";

    final Map<String, dynamic> body = {
      "title": title,
      "date": date,
      "start_time": startTime,
      "end_time": endTime,
      "alarm_time": _formatAlarmTime(date, alarmTime),
      "is_completed": isCompleted,
      // ❌ REMOVED: "type_event_description": note ?? "",
    };

    if (location != null && location.trim().isNotEmpty) {
      body["location"] = location.trim();
    }
    if (categoryName != null && categoryName.trim().isNotEmpty) {
      body["category_name"] = categoryName.trim();
    }
    
    // 🛠️ FIX: Only attach description if a note actually exists and contains text
    if (note != null && note.trim().isNotEmpty) {
      body["type_event_description"] = note.trim();
    }

    try {
      final response = await _dio.post(
        url,
        data: body,
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization": "Bearer $accessToken",
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint("✅ Backend Event Created");

        if (await AppPrefs.isGoogleLogin()) {
          final googleService = GoogleServices();
          if (googleService.accessToken == null) {
            await googleService.signIn();
          }

          if (googleService.accessToken != null) {
            await googleService.createGoogleCalendarEvent(
              accessToken: googleService.accessToken!,
              title: title,
              date: date,
              startTime: startTime,
              endTime: endTime,
              description: note,
              location: location,
            );
          }
        }
        return response.data;
      }
    } on DioException catch (e) {
      debugPrint("================= DIO ERROR DETECTED =================");
      debugPrint("URL called: $url");
      debugPrint("Payload sent: $body");
      debugPrint("Response Status Code: ${e.response?.statusCode}");
      debugPrint("RAW Backend Error Data: ${e.response?.data}");
      debugPrint("======================================================");
      rethrow;
    } catch (e) {
      debugPrint("❌ Non-Dio Exception: $e");
      rethrow;
    }
    return null;
  }

  /// ✅ Cleaned and optimized Date / Time parsing chain
  String _formatAlarmTime(String date, String time) {
    final cleanDate = date.trim();
    final cleanTime = time.trim();

    if (cleanTime.isEmpty) {
      return "${cleanDate}T00:00:00${_localTimeZoneOffset()}";
    }

    try {
      final DateFormat timeFormatter = cleanTime.split(':').length == 3 
          ? DateFormat("HH:mm:ss") 
          : DateFormat("HH:mm");

      // Cleaner linear fallback check for parsing date strings
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

      return "${DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(combined)}${_localTimeZoneOffset()}";
    } catch (e) {
      debugPrint("⚠️ Critical failure within formatAlarmTime generation: $e");
      return "${date}T00:00:00${_localTimeZoneOffset()}";
    }
  }

  String _localTimeZoneOffset() {
    final offset = DateTime.now().timeZoneOffset;
    final hours = offset.inHours.abs().toString().padLeft(2, '0');
    final minutes = (offset.inMinutes.abs() % 60).toString().padLeft(2, '0');
    return "${offset.isNegative ? '-' : '+'}$hours:$minutes";
  }

  void selectCategory(String categoryName) {
    selectedCategory = categoryName;
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

  /// ✅ Cleaner execution context flow inside `saveEvent`
  Future<void> saveEvent({
    required BuildContext context,
    required String rawStart,
    required String rawEnd,
    required String rawAlarm, // Can be left as empty string from UI now
    required VoidCallback onSuccess,
  }) async {
    final start = _cleanTimeStr(rawStart);
    final end = _cleanTimeStr(rawEnd);
    
    // 🛠️ FIX: Parse event start time and automatically subtract 10 minutes
    String alarm = start;
    try {
      final parsedStart = DateFormat("HH:mm").parse(start);
      final reminderTime = parsedStart.subtract(const Duration(minutes: 10));
      alarm = DateFormat("HH:mm").format(reminderTime);
    } catch (e) {
      debugPrint("⚠️ Failed calculating 10-minute fallback offset: $e");
    }

    final validationError = validateFields(
      title: titleController.text,
      date: dateController.text,
      startTime: start,
      endTime: end,
      //note: noteController.text,
    );

    if (validationError != null) {
      await showMessageDialog(context, validationError, title: 'Validation Error', icon: Icons.warning_amber_outlined, iconColor: Colors.orange);
      return;
    }

    // Unify multi-format testing loop smoothly
    String formattedBackendDate = "";
    final rawDateText = dateController.text.trim();
    
    for (final format in _dateFormats) {
      try {
        formattedBackendDate = DateFormat("yyyy-MM-dd").format(format.parse(rawDateText));
        break;
      } catch (_) {}
    }

    if (formattedBackendDate.isEmpty) {
      try {
        formattedBackendDate = DateFormat("yyyy-MM-dd").format(DateTime.parse(rawDateText));
      } catch (_) {
        formattedBackendDate = rawDateText;
        debugPrint("⚠️ Date parsing failed entirely. Sent raw UI text: $rawDateText");
      }
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final result = await createTask(
        title: titleController.text.trim(),
        date: formattedBackendDate,
        startTime: start,
        endTime: end,
        location: locationController.text.trim().isEmpty ? null : locationController.text.trim(),
        alarmTime: alarm,
        categoryName: selectedCategory?.isEmpty == true ? null : selectedCategory,
        note: noteController.text.trim(),
      );

      if (context.mounted) Navigator.pop(context); // Remove loading spinner safely

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
          debugPrint("⚠️ Alarm time scheduling error: $e");
        }

        clearFields();
        onSuccess();

        if (context.mounted) {
          await showMessageDialog(context, 'Saved successfully', title: 'Success', icon: Icons.check_circle_outline, iconColor: Colors.green);
          await context.read<HomeController>().fetchEvents();
          context.push('/event_details', extra: result['id'] as int);
        }
      }
    } catch (e) {
      if (context.mounted) Navigator.pop(context); // Remove loading spinner safely

      String displayErrorMessage = "Unknown server error";
      if (e is DioException && e.response?.data is Map) {
        final List<String> parsedErrors = [];
        (e.response!.data as Map).forEach((key, value) {
          parsedErrors.add("$key: ${value.toString().replaceAll('[', '').replaceAll(']', '')}");
        });
        displayErrorMessage = parsedErrors.join("\n");
      } else if (e is DioException) {
        displayErrorMessage = e.response?.data?.toString() ?? e.message ?? displayErrorMessage;
      } else {
        displayErrorMessage = e.toString();
      }

      if (context.mounted) {
        await showMessageDialog(context, 'Failed to save event:\n$displayErrorMessage', title: 'Error', icon: Icons.error_outline, iconColor: Colors.red);
      }
    }
  }

  void clearFields() {
    titleController.clear();
    dateController.clear();
    startTimeController.clear();
    endTimeController.clear();
    locationController.clear();
    alarmTimeController.clear();
    noteController.clear();
    selectedCategory = null;
    notifyListeners();
  }

  @override
  void dispose() {
    titleController.dispose();
    dateController.dispose();
    startTimeController.dispose();
    endTimeController.dispose();
    locationController.dispose();
    alarmTimeController.dispose();
    noteController.dispose();
    super.dispose();
  }
}