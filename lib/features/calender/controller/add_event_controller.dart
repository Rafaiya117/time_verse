import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:time_verse/features/all_events/controller/all_events.dart';
import 'package:time_verse/features/auth/auth_service/auth_service.dart';
import 'package:time_verse/features/calender/model/event_category_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AddEventController extends ChangeNotifier {
  final Dio _dio = Dio();
  List<EventCategory> categories = [];
  bool isLoading = false;
  TextEditingController titleController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController startTimeController = TextEditingController();
  TextEditingController endTimeController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController alarmTimeController = TextEditingController();
  TextEditingController noteController = TextEditingController();

  Future<Options> _authorizedHeader() async {
    final token = await AuthService().getToken();
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

      if (response.statusCode == 200) {
        categories = (response.data as List).map((json) => EventCategory.fromJson(json)).toList();
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

  // controller add event
Future<Map<String, dynamic>?> createTask({
  required String title,
  required String date,
  required String startTime,
  required String endTime,
  required String location,
  required String alarmTime,
  required String categoryName,
  bool isCompleted = false,
  String? note,
}) async {
  final baseUrl = dotenv.env['BASE_URL'] ?? '';
  final authService = AuthService();
  final accessToken = await authService.getToken();
  final allevent =  AllEventsController();
  try {
    final url = Uri.parse("$baseUrl/api/v1/event/create/");
    final formattedAlarmTime = _formatAlarmTime(date, alarmTime);

    final body = {
      "title": title,
      "date": date,
      "start_time": startTime,
      "end_time": endTime,
      "location": location,
      "alarm_time": formattedAlarmTime,
      "category_name": categoryName,
      "is_completed": isCompleted,
      "type_event_description": note ?? "",
    };

    final response = await _dio.post(
      url.toString(),
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
      debugPrint("✅ Event created successfully: ${response.data}");
      return response.data;
    }
    allevent.fetchAllEvents();
  } catch (e) {
    debugPrint("❌ Exception: $e");
  }
  return null;
}


String _formatAlarmTime(String date, String time) {
  try {
    if (time.trim().isEmpty) {
      return "${date}T00:00:00${_localTimeZoneOffset()}";
    }

    final parsedDate = DateFormat("yyyy-MM-dd").parse(date);
    final parsedTime = DateFormat("HH:mm:ss").parse(time); // your formatTime outputs HH:mm:ss

    final combined = DateTime(
      parsedDate.year,
      parsedDate.month,
      parsedDate.day,
      parsedTime.hour,
      parsedTime.minute,
      parsedTime.second,
    );

    final formatted = "${combined.year.toString().padLeft(4,'0')}-"
        "${combined.month.toString().padLeft(2,'0')}-"
        "${combined.day.toString().padLeft(2,'0')}T"
        "${combined.hour.toString().padLeft(2,'0')}:"
        "${combined.minute.toString().padLeft(2,'0')}:"
        "${combined.second.toString().padLeft(2,'0')}"
        "${_localTimeZoneOffset()}";

    return formatted;
  } catch (_) {
    return "${date}T00:00:00${_localTimeZoneOffset()}";
  }
}

// Helper: local offset like +06:00
String _localTimeZoneOffset() {
  final offset = DateTime.now().timeZoneOffset;
  final hours = offset.inHours.abs().toString().padLeft(2,'0');
  final minutes = (offset.inMinutes.abs() % 60).toString().padLeft(2,'0');
  final sign = offset.isNegative ? '-' : '+';
  return "$sign$hours:$minutes";
}

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


