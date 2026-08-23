import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:time_verse/config/app_route/app_prefernce.dart';
import 'package:time_verse/config/services/google_service.dart';
import 'package:time_verse/features/auth/auth_service/auth_service.dart';
import 'package:time_verse/features/calender/model/event_category_model.dart';

class AddEventRepository {
  final Dio _dio = Dio();
  final AuthService _authService = AuthService();

  /// Private helper for authorized HTTP headers
  Future<Options> _authorizedHeader() async {
    final token = await _authService.getToken();
    return Options(
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );
  }

  /// Fetches event categories from backend
  Future<List<EventCategory>> fetchCategories() async {
    final baseUrl = dotenv.env['BASE_URL'] ?? '';
    final response = await _dio.get(
      '${baseUrl}api/v1/categories/',
      options: await _authorizedHeader(),
    );

    if (response.statusCode == 200 && response.data is List) {
      debugPrint('!--------- Category ${response.data.toString()}---------!');
      return (response.data as List).map((json) => EventCategory.fromJson(json)).toList();
    }
    return [];
  }

  /// Creates a task on the server and optional Google Calendar integration
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
    String? repeat,
    Map<String, dynamic>? customRepeat,
  }) async {
    final baseUrl = dotenv.env['BASE_URL'] ?? '';
    final url = "${baseUrl}api/v1/event/create/";

    final bool isCustom = repeat?.toLowerCase() == 'custom';

    final Map<String, dynamic> body = {
      "title": title,
      "date": date,
      "start_time": startTime,
      "end_time": endTime,
      "alarm_time": alarmTime,
      "repeat": isCustom ? "custom" : (repeat ?? "1 day"),
      if (isCustom && customRepeat != null) "custom_repeat": customRepeat,
      "is_completed": isCompleted,
      if (location?.trim().isNotEmpty ?? false) "location": location!.trim(),
      if (categoryName?.trim().isNotEmpty ?? false)
        "category_name": categoryName!.trim(),
      if (note?.trim().isNotEmpty ?? false)
        "type_event_description": note!.trim(),
    };

    final response = await _dio.post(
      url,
      data: body,
      options: await _authorizedHeader(),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      if (await AppPrefs.isGoogleLogin()) {
        final googleService = GoogleServices();
        if (googleService.accessToken == null) {
          await googleService.signIn();
        }

        if (googleService.accessToken != null) {
          await googleService.createGoogleCalendarEvent(
            accessToken: googleService.accessToken!,
            title: title,
            startTime: startTime,
            endTime: endTime,
            description: note,
            location: location,
            date: date,
          );
        }
      }
      return response.data;
    }
    return null;
  }

  /// Calculates recurring alarm occurrences based on event repeat settings
  List<DateTime> generateAlarmOccurrences({
    required DateTime startDateTime,
    required String? selectedRepeat,
    required int customRepeatCount,
    required String customRepeatUnit,
    required List<String> selectedDays,
    required String repeatEndType,
    required DateTime customEndDate,
    required int customOccurrences,
    int maxLimit = 30,
  }) {
    List<DateTime> occurrences = [];

    int intervalCount = 1;
    String intervalUnit = 'none';

    if (selectedRepeat == 'Custom') {
      intervalCount = customRepeatCount;
      intervalUnit = customRepeatUnit.toLowerCase();
    } else if (selectedRepeat != null && selectedRepeat != "Don't repeat") {
      if (selectedRepeat == 'Every 1 day') {
        intervalUnit = 'day';
      } else if (selectedRepeat == 'Every 1 week') {
        intervalUnit = 'week';
      } else if (selectedRepeat == 'Every 1 month') {
        intervalUnit = 'month';
      } else if (selectedRepeat == 'Every 1 year') {
        intervalUnit = 'year';
      }
    }

    if (intervalUnit == 'none') {
      occurrences.add(startDateTime);
      return occurrences;
    }

    DateTime current = startDateTime;
    int count = 0;

    final selectedDayIndices = selectedDays.map((d) {
      final parts = d.split('-');
      return parts.length > 1 ? int.tryParse(parts[1]) ?? -1 : -1;
    }).where((idx) => idx != -1).toList();

    while (count < maxLimit) {
      if (repeatEndType == 'On' && current.isAfter(customEndDate)) {
        break;
      }
      if (repeatEndType == 'After' && count >= customOccurrences) {
        break;
      }

      if (intervalUnit == 'week' && selectedDayIndices.isNotEmpty) {
        if (selectedDayIndices.contains(current.weekday % 7)) {
          occurrences.add(current);
          count++;
        }
        current = current.add(const Duration(days: 1));
      } else {
        occurrences.add(current);
        count++;

        if (intervalUnit == 'day') {
          current = current.add(Duration(days: intervalCount));
        } else if (intervalUnit == 'week') {
          current = current.add(Duration(days: 7 * intervalCount));
        } else if (intervalUnit == 'month') {
          current = DateTime(
            current.year,
            current.month + intervalCount,
            current.day,
            current.hour,
            current.minute,
          );
        } else if (intervalUnit == 'year') {
          current = DateTime(
            current.year + intervalCount,
            current.month,
            current.day,
            current.hour,
            current.minute,
          );
        }
      }
    }

    return occurrences;
  }
}
