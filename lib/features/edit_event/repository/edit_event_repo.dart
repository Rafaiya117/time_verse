import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:time_verse/features/auth/auth_service/auth_service.dart';
import 'package:time_verse/features/edit_event/model/edit_event_model.dart';

class EditEventRepository {
  final Dio _dio = Dio();

  /// Fetch categories list from API
  Future<List<EditCategoryModel>> getCategories() async {
    try {
      final authService = AuthService();
      final token = await authService.getToken();
      final baseUrl = dotenv.env['BASE_URL'] ?? '';
      final url = '${baseUrl}api/v1/categories/';

      final response = await _dio.get(
        url,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => EditCategoryModel.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      debugPrint('⚠️ Error fetching categories: $e');
      rethrow;
    }
  }

  /// Fetch single event details by ID
  Future<EditEventModel?> getEventDetails(String eventId) async {
    try {
      final parsedId = int.tryParse(eventId);
      if (parsedId == null) {
        debugPrint('⚠️ Invalid eventId provided: "$eventId"');
        return null;
      }

      final authService = AuthService();
      final token = await authService.getToken();
      final baseUrl = dotenv.env['BASE_URL'] ?? '';
      final url = '${baseUrl}api/v1/event/details/?event_id=$parsedId';

      final response = await _dio.get(
        url,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        debugPrint('✅ Event details fetched: $data');

        return EditEventModel(
          id: data['id']?.toString() ?? eventId,
          title: data['title']?.toString(),
          note: data['note']?.toString(),
          location: data['location']?.toString(),
          date: data['date'] != null ? DateTime.tryParse(data['date'].toString()) : null,
          startTime: data['start_time']?.toString(),
          endTime: data['end_time']?.toString(),
          category: data['category']?.toString(),
          reminder: data['alarm_time']?.toString(),
          repeat: data['repeat']?.toString(),
        );
      } else {
        debugPrint('❌ Failed to fetch event details: ${response.statusCode}');
        return null;
      }
    } on DioException catch (e) {
      debugPrint('❌ Dio 500/Server Error Response Data: ${e.response?.data}');
      return null;
    } catch (e) {
      debugPrint('⚠️ Error fetching event details in repo: $e');
      return null;
    }
  }

  /// Update event via API
  Future<bool> updateEvent(String eventId, EditEventModel eventData) async {
    try {
      final parsedId = int.tryParse(eventId) ?? eventId;
      final authService = AuthService();
      final token = await authService.getToken();
      final baseUrl = dotenv.env['BASE_URL'] ?? '';
      final url = '${baseUrl}api/v1/event/update/$parsedId/';

      final response = await _dio.put(
        url,
        data: eventData.toJson(),
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      debugPrint('⚠️ Error updating event: $e');
      rethrow;
    }
  }
}