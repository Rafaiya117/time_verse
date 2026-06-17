import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:time_verse/features/auth/auth_service/auth_service.dart';

class MoodController extends ChangeNotifier {
  final Dio _dio = Dio();
  int _selectedIndex = 3;

  int get selectedIndex => _selectedIndex;

  final List<Map<String, String>> moods = [
    {'emoji': '😔', 'label': 'Sad'},
    {'emoji': '😟', 'label': 'Anxious'},
    {'emoji': '😐', 'label': 'Neutral'},
    {'emoji': '😌', 'label': 'Calm'},
    {'emoji': '😊', 'label': 'Happy'},
    {'emoji': '🤩', 'label': 'Excited'},
    {'emoji': '😤', 'label': 'Stressed'},
    {'emoji': '🙏', 'label': 'Grateful'},
  ];

  void updateSelectedIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  // 🚀 POST FUNCTION
  Future<void> postMoodToApi(String moodLabel) async {
    try {
      // Fetching auth token safely from database session context wrapper
      final token = await AuthService().getToken(); 
      final baseUrl = dotenv.env['BASE_URL'] ?? '';
      
      final Map<String, dynamic> moodPayload = {
        'mood': moodLabel,
      };

      debugPrint('🚀 Sending Mood Payload: $moodPayload');

      final response = await _dio.post(
        '$baseUrl/api/v1/user/mood/',
        data: jsonEncode(moodPayload),
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      debugPrint('📥 Post Mood Response Data: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint('✅ Mood registered successfully across network layers.');
      }
    } catch (e) {
      debugPrint('⚠️ Error posting mood context structure: $e');
    }
  }
}