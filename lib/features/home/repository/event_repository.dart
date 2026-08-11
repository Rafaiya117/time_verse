import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:time_verse/features/all_events/model/event_model.dart';
import 'package:time_verse/features/auth/auth_service/auth_service.dart';
import 'package:time_verse/features/home/model/ai_refelction_model.dart';
import 'package:time_verse/features/home/model/quotedata_model.dart';

class EventRepository {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: dotenv.env['BASE_URL'] ?? '',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  // Future<Options> _getAuthOptions() async {
  //   final token = await AuthService().getToken();
  //   return Options(
  //     headers: {
  //       'Authorization': 'Bearer $token',
  //       'Content-Type': 'application/json',
  //     },
  //   );
  // }

  /// Fetch events for a specific date and user ID
  Future<List<EventModel>> fetchTodaysEvents(String userId, {DateTime? date}) async {
    try {
      final token = await AuthService().getToken();
      final dateToFetch = date ?? DateTime.now();
      final formattedDate = "${dateToFetch.year.toString().padLeft(4, '0')}-${dateToFetch.month.toString().padLeft(2, '0')}-${dateToFetch.day.toString().padLeft(2, '0')}";

      final response = await _dio.get(
        'api/v1/event/',
        queryParameters: {'date': formattedDate},
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      final data = response.data is String ? jsonDecode(response.data) : response.data;
      if (data is List) {
        return data.map((e) => EventModel.fromMap(e)).where((event) => event.user.toString() == userId.toString()).toList();
      } else {
        debugPrint("❌ API did not return List");
        return [];
      }
    } catch (e) {
      debugPrint("❌ Error fetching events: $e");
      return [];
    }
  }

  /// Fetch all events to generate latest inspirational quote
  Future<List<QuoteData>?> fetchInspirationalQuotes(String currentUserId) async {
    try {
      final token = await AuthService().getToken();
      final response = await _dio.get(
        'api/v1/event/',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      debugPrint("📡 Response Status: ${response.statusCode}");
      debugPrint("📦 Raw Response Type: ${response.data.runtimeType}");

      if (response.statusCode == 200) {
        final List data = response.data is List ? response.data : [response.data];
        debugPrint("📊 Total Events From API: ${data.length}");

        final userEvents = data.where((event) {
          debugPrint("🔎 Checking Event User: ${event['user']}");
          return event['user'].toString() == currentUserId.toString();
        }).toList();

        debugPrint("🎯 User Events After Filter: ${userEvents.length}");

        if (userEvents.isEmpty) {
          debugPrint("⚠️ No user events found. Restoring default quote.");
          return null;
        }

        userEvents.sort((a, b) {
          final aTime = DateTime.parse(a['created_at']);
          final bTime = DateTime.parse(b['created_at']);
          return aTime.compareTo(bTime);
        });

        final latest = userEvents.last;

        debugPrint("🏆 Latest Event ID: ${latest['id']}");
        debugPrint("🏆 Alarm time ${latest['alarm_time']}");
        debugPrint("📝 Description: ${latest['description']}");
        debugPrint("📌 Type Description: ${latest['type_event_description']}");

        final quoteText = (latest['description']?.toString().trim().isNotEmpty == true)
        ? latest['description'].toString(): latest['type_event_description']?.toString() ?? '';
        debugPrint("✨ Final Quote Text: $quoteText");
        return [
          QuoteData(
            id: latest['id'],
            name: latest['category_name']?.toString() ?? '', // 👈 Fixed: handles null safely
            quote: quoteText,
            reference: latest['title']?.toString() ?? '',
          ),
        ];
      }
    } catch (e) {
      debugPrint('⚠️ Error fetching events: $e');
    }
    return null;
  }

  /// Submit review/feedback to API
  Future<bool> postReviewToApi({required int rating, required String comments}) async {
    try {
      final token = await AuthService().getToken();
      final baseUrl = dotenv.env['BASE_URL'] ?? '';
      final Map<String, dynamic> reviewData = {
        'rating': rating,
        'comments': comments.trim(),
      };

      final response = await _dio.post(
        '$baseUrl/api/v1/event/feedback/',
        data: jsonEncode(reviewData),
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      debugPrint('📤 Post Review Response Data: ${response.data}');
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      debugPrint('⚠️ Error posting review: $e');
      return false;
    }
  }

  /// Save quote to favorites API
  Future<bool> saveQuoteToFavorite({required int eventId}) async {
    try {
      final token = await AuthService().getToken();
      final baseUrl = dotenv.env['BASE_URL'] ?? '';

      final response = await _dio.post(
        '$baseUrl/api/v1/event/$eventId/favorite',
        data: {},
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      debugPrint('⚠️ Error saving quote: $e');
      return false;
    }
  }

  /// Fetch AI Mood Reflection
  Future<EventReflectionResponse?> fetchAIMooodReflection() async {
    try {
      final token = await AuthService().getToken();
      if (token == null || token.isEmpty) {
        debugPrint('⚠️ Error: Empty or missing auth token in fetchAIMooodReflection');
        return null;
      }

      final response = await _dio.get(
        'api/v1/event/ai-reflection/',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );
      debugPrint('📥 AI Reflection Response Data: ${response.data}');
      if (response.statusCode == 200 && response.data != null) {
        debugPrint('ai_reflection ${response.data}');
        return EventReflectionResponse.fromJson(response.data);
      }
    } on DioException catch (e) {
      debugPrint('❌ Dio error fetching AI reflection: ${e.response?.statusCode} -> ${e.response?.data}');
    } catch (e) {
      debugPrint('⚠️ Unexpected error fetching AI reflection: $e');
    }
    return null;
  }

  /// Local Storage Alarm Checks
  Future<bool> alarmsAlreadyScheduled(int userId) async {
    final prefs = await SharedPreferences.getInstance();
    final todayKey = DateFormat('yyyy-MM-dd').format(DateTime.now());
    return prefs.getBool('alarms_scheduled_${userId}_$todayKey') ?? false;
  }

  Future<void> markAlarmsScheduled(int userId) async {
    final prefs = await SharedPreferences.getInstance();
    final todayKey = DateFormat('yyyy-MM-dd').format(DateTime.now());
    await prefs.setBool('alarms_scheduled_${userId}_$todayKey', true);
  }
}