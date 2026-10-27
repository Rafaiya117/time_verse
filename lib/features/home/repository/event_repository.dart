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

  /// Fetch events for a specific date and user ID
  Future<List<EventModel>> fetchTodaysEvents(String userId, {DateTime? date}) async {
    try {
      final token = await AuthService().getToken();
      final dateToFetch = date ?? DateTime.now();
      final formattedDate = DateFormat('yyyy-MM-dd').format(dateToFetch);

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
        return data
            .map((e) => EventModel.fromMap(e))
            .where((event) => event.user.toString() == userId.toString())
            .toList();
      } else {
        debugPrint("❌ API did not return List");
        return [];
      }
    } catch (e) {
      debugPrint("❌ Error fetching events: $e");
      return [];
    }
  }

  /// 🚀 OPTIMIZED: Fetch inspirational quote for today without querying all historical events
  Future<List<QuoteData>?> fetchInspirationalQuotes(String currentUserId, {DateTime? date}) async {
    try {
      final token = await AuthService().getToken();
      final dateToFetch = date ?? DateTime.now();
      final todayFormatted = DateFormat('yyyy-MM-dd').format(dateToFetch);

      final response = await _dio.get(
        'api/v1/event/',
        queryParameters: {'date': todayFormatted},
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        final List data = response.data is List ? response.data : [response.data];

        final userEvents = data.where((event) {
          final isUser = event['user'].toString() == currentUserId.toString();
          return isUser;
        }).toList();

        if (userEvents.isEmpty) return null;

        userEvents.sort((a, b) {
          final aTime = DateTime.tryParse(a['created_at'] ?? '') ?? DateTime.now();
          final bTime = DateTime.tryParse(b['created_at'] ?? '') ?? DateTime.now();
          return aTime.compareTo(bTime);
        });

        final latest = userEvents.last;
        final quoteText = (latest['description']?.toString().trim().isNotEmpty == true)
            ? latest['description'].toString()
            : latest['type_event_description']?.toString() ?? '';
        if (quoteText.trim().isEmpty) return null;

        return [
          QuoteData(
            id: latest['id'],
            name: latest['category_name']?.toString() ?? '',
            quote: quoteText,
            reference: latest['title']?.toString() ?? '',
          ),
        ];
      }
    } catch (e) {
      debugPrint('⚠️ Error fetching quotes: $e');
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
      if (token == null || token.isEmpty) return null;

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
      if (response.statusCode == 200 && response.data != null) {
        return EventReflectionResponse.fromJson(response.data);
      }
    } catch (e) {
      debugPrint('⚠️ Error fetching AI reflection: $e');
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