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

  // Future<Map<String, dynamic>?> createTask({
  //   required String title,
  //   required String date,
  //   required String startTime,
  //   required String endTime,
  //   String? location,
  //   required String alarmTime,
  //   String? categoryName,
  //   bool isCompleted = false,
  //   String? note,
  //   String? repeat,
  // }) async {
  //   final baseUrl = dotenv.env['BASE_URL'] ?? '';
  //   final url = "${baseUrl}api/v1/event/create/";

  //   // Map UI label/custom values to backend repeat string format
  //   String formattedRepeat = "1 day";
  //   if (repeat != null && repeat.isNotEmpty) {
  //     final lower = repeat.toLowerCase();
  //     if (lower.startsWith("every ")) {
  //       formattedRepeat = repeat.substring(6).trim();
  //     } else if (lower.contains("week")) {
  //       formattedRepeat = repeat.contains(RegExp(r'\d+')) ? repeat : "1 week";
  //     } else if (lower.contains("month")) {
  //       formattedRepeat = repeat.contains(RegExp(r'\d+')) ? repeat : "1 month";
  //     } else if (lower.contains("year")) {
  //       formattedRepeat = repeat.contains(RegExp(r'\d+')) ? repeat : "1 year";
  //     } else if (lower.contains("day")) {
  //       formattedRepeat = repeat.contains(RegExp(r'\d+')) ? repeat : "1 day";
  //     } else {
  //       formattedRepeat = repeat;
  //     }
  //   }

  //   final Map<String, dynamic> body = {
  //     "title": title,
  //     "date": date,
  //     "start_time": startTime,
  //     "end_time": endTime,
  //     "alarm_time": alarmTime,
  //     "repeat": formattedRepeat,
  //     "is_completed": isCompleted,
  //     if (location?.trim().isNotEmpty ?? false) "location": location!.trim(),
  //     if (categoryName?.trim().isNotEmpty ?? false)
  //       "category_name": categoryName!.trim(),
  //     if (note?.trim().isNotEmpty ?? false)
  //       "type_event_description": note!.trim(),
  //   };

  //   final response = await _dio.post(
  //     url,
  //     data: body,
  //     options: await _authorizedHeader(),
  //   );

  //   if (response.statusCode == 200 || response.statusCode == 201) {
  //     if (await AppPrefs.isGoogleLogin()) {
  //       final googleService = GoogleServices();
  //       if (googleService.accessToken == null) {
  //         await googleService.signIn();
  //       }

  //       if (googleService.accessToken != null) {
  //         await googleService.createGoogleCalendarEvent(
  //           accessToken: googleService.accessToken!,
  //           title: title,
  //           startTime: startTime,
  //           endTime: endTime,
  //           description: note,
  //           location: location,
  //           date: date,
  //         );
  //       }
  //     }
  //     return response.data;
  //   }
  //   return null;
  // }

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
}
