import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
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
 
    try {
      final url = Uri.parse("$baseUrl/api/v1/event/create/");   

      final body = {
        "title": title,
        "date": date,
        "start_time": startTime,
        "end_time": endTime,
        "location": location,
        "alarm_time": alarmTime,
        "category_name": categoryName,
        "is_completed": isCompleted,
        "type_event_description": note ?? ""
      };

      final response = await _dio.post(
        url.toString(),
        data: jsonEncode(body),
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
      } else {
        print("❌ API Error: ${response.statusCode}");
        print("Response: ${response.data}");
        return null;
      }
    } catch (e) {
      print("❌ Exception: $e");
      return null;
    }
  }
}


