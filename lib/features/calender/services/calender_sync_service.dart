import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'package:time_verse/config/services/google_service.dart';
import 'package:time_verse/config/services/user_session.dart';
import 'package:time_verse/features/all_events/model/event_model.dart';
import 'package:time_verse/features/auth/auth_service/auth_service.dart';


class CalendarSyncService {
  final Dio _dio = Dio();

  String normalizeTime(String rawTime) {
    if (rawTime.isEmpty) return '';
    final parts = rawTime.split(':');
    if (parts.length >= 2) {
      return '${parts[0].padLeft(2, '0')}:${parts[1].padLeft(2, '0')}';
    }
    return rawTime;
  }

  bool isEventOccurringOnDate(EventModel event, DateTime targetDate) {
    final rawDateStr = event.createdAt.isNotEmpty ? event.createdAt : event.date;
    final startDate = DateTime.tryParse(rawDateStr);
    if (startDate == null) return false;

    final start = DateTime(startDate.year, startDate.month, startDate.day);
    final target = DateTime(targetDate.year, targetDate.month, targetDate.day);

    if (target.isBefore(start)) return false;
    if (start.year == target.year && start.month == target.month && start.day == target.day) {
      return true;
    }

    final repeatRule = event.repeat?.toLowerCase().trim() ?? '';
    if (repeatRule.isEmpty || repeatRule == "don't repeat") return false;

    switch (repeatRule) {
      case '1 day':
      case 'every 1 day':
        return true;
      case '1 week':
      case 'every 1 week':
        return target.difference(start).inDays % 7 == 0;
      case '1 month':
      case 'every 1 month':
        return target.day == start.day;
      case '1 year':
      case 'every 1 year':
        return target.month == start.month && target.day == start.day;
      default:
        return false;
    }
  }

  Future<List<EventModel>> fetchBackendEvents(DateTime targetDate) async {
    try {
      final token = await AuthService().getToken();
      final baseUrl = dotenv.env['BASE_URL'] ?? '';

      final response = await _dio.get(
        '${baseUrl}api/v1/up-comming/events/',
        options: Options(headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        }),
      );

      if (response.statusCode == 200 && response.data is List) {
        final List data = response.data;
        return data.map((json) {
          final rawDate = json['date']?.toString() ?? '';
          return EventModel(
            id: json['id'] ?? 0,
            userName: json['user_name']?.toString() ?? '',
            title: json['title']?.toString() ?? '',
            description: json['description']?.toString() ?? json['type_event_description']?.toString() ?? '',
            date: rawDate,
            startTime: normalizeTime(json['start_time']?.toString() ?? ''),
            endTime: normalizeTime(json['end_time']?.toString() ?? ''),
            location: json['location']?.toString() ?? '',
            alarmTime: json['alarm_time']?.toString() ?? '',
            isCompleted: json['is_completed'] ?? false,
            createdAt: json['created_at']?.toString() ?? rawDate,
            user: json['user'] ?? 0,
            category: json['category_name']?.toString() ?? json['category']?.toString(),
            isFavorite: json['is_favorite'] ?? false,
            repeat: json['repeat']?.toString(),
          );
        }).where((e) => isEventOccurringOnDate(e, targetDate)).map((e) {
          final formattedDate = DateFormat('yyyy-MM-dd').format(targetDate);
          return EventModel(
            id: e.id,
            userName: e.userName,
            title: e.title,
            description: e.description,
            date: formattedDate,
            startTime: e.startTime,
            endTime: e.endTime,
            location: e.location,
            alarmTime: e.alarmTime,
            isCompleted: e.isCompleted,
            createdAt: e.createdAt,
            user: e.user,
            category: e.category,
            isFavorite: e.isFavorite,
            repeat: e.repeat,
          );
        }).toList();
      }
    } catch (e) {
      debugPrint('⚠️ Error fetching backend events: $e');
    }
    return [];
  }

  Future<List<EventModel>> fetchGoogleEvents(DateTime targetDate) async {
    final accessToken = GoogleServices().accessToken;
    if (accessToken == null || accessToken.isEmpty) return [];

    final dayStart = DateTime(targetDate.year, targetDate.month, targetDate.day);
    final dayEnd = dayStart.add(const Duration(days: 1));

    final gEventsData = await GoogleServices().getGoogleCalendarEvents(
      accessToken: accessToken,
      timeMin: dayStart,
      timeMax: dayEnd,
    );

    return gEventsData.map((json) {
      return EventModel(
        id: json['id'],
        userName: UserSession().username ?? 'Google Calendar',
        title: json['title'] ?? '',
        description: json['description'] ?? '',
        date: json['date'] ?? '',
        startTime: json['startTime'] ?? '',
        endTime: json['endTime'] ?? '',
        location: json['google_id'] ?? json['location'] ?? '',
        alarmTime: json['alarm_time'] ?? '',
        isCompleted: false,
        createdAt: DateTime.now().toIso8601String(),
        user: int.tryParse(UserSession().userId ?? '0') ?? 0,
        category: 'Google Calendar',
        isFavorite: false,
      );
    }).toList();
  }

  Future<List<EventModel>> fetchCombinedEvents(DateTime targetDate) async {
    final results = await Future.wait([
      fetchBackendEvents(targetDate),
      fetchGoogleEvents(targetDate),
    ]);

    final Map<String, EventModel> uniqueEvents = {};

    for (var event in [...results[0], ...results[1]]) {
      final key = '${event.title.trim().toLowerCase()}_${event.date}_${normalizeTime(event.startTime)}';
      uniqueEvents.putIfAbsent(key, () => event);
    }

    return uniqueEvents.values.toList();
  }
}