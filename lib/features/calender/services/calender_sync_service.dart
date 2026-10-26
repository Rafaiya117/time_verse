import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'package:time_verse/config/services/google_service.dart';
import 'package:time_verse/config/services/user_session.dart';
import 'package:time_verse/features/all_events/model/event_model.dart';
import 'package:time_verse/features/auth/auth_service/auth_service.dart';


// class CalendarSyncService {
//   final Dio _dio = Dio();

//   String normalizeTime(String rawTime) {
//     if (rawTime.isEmpty) return '';
//     final parts = rawTime.split(':');
//     if (parts.length >= 2) {
//       return '${parts[0].padLeft(2, '0')}:${parts[1].padLeft(2, '0')}';
//     }
//     return rawTime;
//   }

//   bool isEventOccurringOnDate(EventModel event, DateTime targetDate) {
//     final rawDateStr = event.createdAt.isNotEmpty ? event.createdAt : event.date;
//     final startDate = DateTime.tryParse(rawDateStr);
//     if (startDate == null) return false;

//     final start = DateTime(startDate.year, startDate.month, startDate.day);
//     final target = DateTime(targetDate.year, targetDate.month, targetDate.day);

//     if (target.isBefore(start)) return false;
//     if (start.year == target.year && start.month == target.month && start.day == target.day) {
//       return true;
//     }

//     final repeatRule = event.repeat?.toLowerCase().trim() ?? '';
//     if (repeatRule.isEmpty || repeatRule == "don't repeat") return false;

//     switch (repeatRule) {
//       case '1 day':
//       case 'every 1 day':
//         return true;
//       case '1 week':
//       case 'every 1 week':
//         return target.difference(start).inDays % 7 == 0;
//       case '1 month':
//       case 'every 1 month':
//         return target.day == start.day;
//       case '1 year':
//       case 'every 1 year':
//         return target.month == start.month && target.day == start.day;
//       default:
//         return false;
//     }
//   }

//   Future<List<EventModel>> fetchBackendEvents(DateTime targetDate) async {
//     try {
//       final token = await AuthService().getToken();
//       final baseUrl = dotenv.env['BASE_URL'] ?? '';

//       final response = await _dio.get(
//         '${baseUrl}api/v1/up-comming/events/',
//         options: Options(headers: {
//           'Authorization': 'Bearer $token',
//           'Content-Type': 'application/json',
//         }),
//       );

//       if (response.statusCode == 200 && response.data is List) {
//         final List data = response.data;
//         return data.map((json) {
//           final rawDate = json['date']?.toString() ?? '';
//           return EventModel(
//             id: json['id'] ?? 0,
//             userName: json['user_name']?.toString() ?? '',
//             title: json['title']?.toString() ?? '',
//             description: json['description']?.toString() ?? json['type_event_description']?.toString() ?? '',
//             date: rawDate,
//             startTime: normalizeTime(json['start_time']?.toString() ?? ''),
//             endTime: normalizeTime(json['end_time']?.toString() ?? ''),
//             location: json['location']?.toString() ?? '',
//             alarmTime: json['alarm_time']?.toString() ?? '',
//             isCompleted: json['is_completed'] ?? false,
//             createdAt: json['created_at']?.toString() ?? rawDate,
//             user: json['user'] ?? 0,
//             category: json['category_name']?.toString() ?? json['category']?.toString(),
//             isFavorite: json['is_favorite'] ?? false,
//             repeat: json['repeat']?.toString(),
//           );
//         }).where((e) => isEventOccurringOnDate(e, targetDate)).map((e) {
//           final formattedDate = DateFormat('yyyy-MM-dd').format(targetDate);
//           return EventModel(
//             id: e.id,
//             userName: e.userName,
//             title: e.title,
//             description: e.description,
//             date: formattedDate,
//             startTime: e.startTime,
//             endTime: e.endTime,
//             location: e.location,
//             alarmTime: e.alarmTime,
//             isCompleted: e.isCompleted,
//             createdAt: e.createdAt,
//             user: e.user,
//             category: e.category,
//             isFavorite: e.isFavorite,
//             repeat: e.repeat,
//           );
//         }).toList();
//       }
//     } catch (e) {
//       debugPrint('⚠️ Error fetching backend events: $e');
//     }
//     return [];
//   }

//   Future<List<EventModel>> fetchGoogleEvents(DateTime targetDate) async {
//     final accessToken = GoogleServices().accessToken;
//     if (accessToken == null || accessToken.isEmpty) return [];

//     // Query a full 24-hour window covering local date boundaries
//     final dayStart = DateTime(targetDate.year, targetDate.month, targetDate.day, 0, 0, 0);
//     final dayEnd = DateTime(targetDate.year, targetDate.month, targetDate.day, 23, 59, 59);

//     final gEventsData = await GoogleServices().getGoogleCalendarEvents(
//       accessToken: accessToken,
//       timeMin: dayStart,
//       timeMax: dayEnd,
//     );

//     final String targetDateStr = DateFormat('yyyy-MM-dd').format(targetDate);
//     final List<EventModel> filteredEvents = [];

//     for (var json in gEventsData) {
//       String formattedStart = json['startTime'] ?? '';
//       String formattedEnd = json['endTime'] ?? '';

//       final startParsed = DateTime.tryParse(formattedStart)?.toLocal();
//       if (startParsed != null) {
//         formattedStart = DateFormat('HH:mm').format(startParsed);
//       } else {
//         formattedStart = normalizeTime(formattedStart);
//       }

//       final endParsed = DateTime.tryParse(formattedEnd)?.toLocal();
//       if (endParsed != null) {
//         formattedEnd = DateFormat('HH:mm').format(endParsed);
//       } else {
//         formattedEnd = normalizeTime(formattedEnd);
//       }

//       final eventLocalDate = json['date'] ?? (startParsed != null ? DateFormat('yyyy-MM-dd').format(startParsed) : targetDateStr);

//       // 💡 Filter out events whose local date does NOT belong to targetDate
//       if (eventLocalDate != targetDateStr) continue;

//       filteredEvents.add(
//         EventModel(
//           id: json['id'],
//           userName: UserSession().username ?? 'Google Calendar',
//           title: json['title'] ?? '',
//           description: json['description'] ?? '',
//           date: targetDateStr,
//           startTime: formattedStart,
//           endTime: formattedEnd,
//           location: json['google_id'] ?? json['location'] ?? '',
//           alarmTime: json['alarm_time'] ?? '',
//           isCompleted: false,
//           createdAt: DateTime.now().toIso8601String(),
//           user: int.tryParse(UserSession().userId ?? '0') ?? 0,
//           category: 'Google Calendar',
//           isFavorite: false,
//         ),
//       );
//     }

//     return filteredEvents;
//   }

//   Future<List<EventModel>> fetchCombinedEvents(DateTime targetDate) async {
//     final results = await Future.wait([
//       fetchBackendEvents(targetDate),
//       fetchGoogleEvents(targetDate),
//     ]);

//     final Map<String, EventModel> uniqueEvents = {};

//     for (var event in [...results[0], ...results[1]]) {
//       // 💡 Incorporate ID/google_id into deduplication key so distinct events on the same day remain visible
//       final String idPart = event.location.isNotEmpty ? event.location : event.id.toString();
//       final key = '${event.title.trim().toLowerCase()}_${event.date}_${normalizeTime(event.startTime)}_$idPart';
      
//       uniqueEvents.putIfAbsent(key, () => event);
//     }

//     return uniqueEvents.values.toList();
//   }
// }


class CalendarSyncService {
  final Dio _dio = Dio();

  String normalizeTime(String rawTime) {
    if (rawTime.isEmpty) return '00:00';
    final parts = rawTime.split(':');
    if (parts.length >= 2) {
      return '${parts[0].padLeft(2, '0')}:${parts[1].padLeft(2, '0')}';
    }
    return rawTime;
  }

  bool isEventOccurringOnDate(EventModel event, DateTime targetDate, Map<String, dynamic>? rawJson) {
    final rawDateStr = event.date.isNotEmpty ? event.date : event.createdAt;
    final startDate = DateTime.tryParse(rawDateStr);
    if (startDate == null) return false;

    final start = DateTime(startDate.year, startDate.month, startDate.day);
    final target = DateTime(targetDate.year, targetDate.month, targetDate.day);

    // If target date is before the event even starts, it's impossible
    if (target.isBefore(start)) return false;

    // Direct day match
    if (start.year == target.year && start.month == target.month && start.day == target.day) {
      return true;
    }

    // 💡 FIXED: Read from both flat repeat string AND nested custom_repeat maps
    String repeatRule = event.repeat?.toLowerCase().trim() ?? '';
    
    if (repeatRule.isEmpty && rawJson != null && rawJson['custom_repeat'] != null) {
      final custom = rawJson['custom_repeat'];
      if (custom is Map) {
        final unit = custom['repeat_unit']?.toString().toLowerCase() ?? '';
        if (unit.isNotEmpty) {
          repeatRule = '1 $unit'; // Fallback translation
        }
      }
    }

    if (repeatRule.isEmpty || repeatRule == "don't repeat") return false;

    switch (repeatRule) {
      case '1 day':
      case 'every 1 day':
      case 'daily':
        return true;
      case '1 week':
      case 'every 1 week':
      case 'weekly':
        return target.difference(start).inDays % 7 == 0;
      case '1 month':
      case 'every 1 month':
      case 'monthly':
        return target.day == start.day;
      case '1 year':
      case 'every 1 year':
      case 'yearly':
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
        final List<EventModel> filteredList = [];

        for (var json in data) {
          final rawDate = json['date']?.toString() ?? '';
          final eventModel = EventModel(
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

          // ✅ FIXED: Pass raw JSON to check custom_repeat parameters safely
          if (isEventOccurringOnDate(eventModel, targetDate, json)) {
            final formattedDate = DateFormat('yyyy-MM-dd').format(targetDate);
            filteredList.add(
              EventModel(
                id: eventModel.id,
                userName: eventModel.userName,
                title: eventModel.title,
                description: eventModel.description,
                date: formattedDate, // Pin perfectly to viewed tracking target day
                startTime: eventModel.startTime,
                endTime: eventModel.endTime,
                location: eventModel.location,
                alarmTime: eventModel.alarmTime,
                isCompleted: eventModel.isCompleted,
                createdAt: eventModel.createdAt,
                user: eventModel.user,
                category: eventModel.category,
                isFavorite: eventModel.isFavorite,
                repeat: eventModel.repeat,
              ),
            );
          }
        }
        return filteredList;
      }
    } catch (e) {
      debugPrint('⚠️ Error fetching backend events: $e');
    }
    return [];
  }

  Future<List<EventModel>> fetchGoogleEvents(DateTime targetDate) async {
    final accessToken = GoogleServices().accessToken;
    if (accessToken == null || accessToken.isEmpty) return [];

    final dayStart = DateTime(targetDate.year, targetDate.month, targetDate.day, 0, 0, 0);
    final dayEnd = DateTime(targetDate.year, targetDate.month, targetDate.day, 23, 59, 59);

    final gEventsData = await GoogleServices().getGoogleCalendarEvents(
      accessToken: accessToken,
      timeMin: dayStart,
      timeMax: dayEnd,
    );

    final targetDateStr = DateFormat('yyyy-MM-dd').format(targetDate);
    final List<EventModel> events = [];

    for (var json in gEventsData) {
      final rawStart = json['startTime'] ?? '';
      final rawEnd = json['endTime'] ?? '';
      final eventDate = json['date']?.isNotEmpty == true ? json['date'] : targetDateStr;

      if (eventDate != targetDateStr) continue;

      events.add(
        EventModel(
          id: json['id'],
          userName: UserSession().username ?? 'Google Calendar',
          title: json['title'] ?? '',
          description: json['description'] ?? '',
          date: targetDateStr,
          startTime: normalizeTime(rawStart),
          endTime: normalizeTime(rawEnd),
          location: json['google_id'] ?? json['location'] ?? '',
          alarmTime: json['alarm_time'] ?? '',
          isCompleted: false,
          createdAt: DateTime.now().toIso8601String(),
          user: int.tryParse(UserSession().userId ?? '0') ?? 0,
          category: 'Google Calendar',
          isFavorite: false,
        ),
      );
    }

    return events;
  }

  Future<List<EventModel>> fetchCombinedEvents(DateTime targetDate) async {
    final results = await Future.wait([
      fetchBackendEvents(targetDate),
      fetchGoogleEvents(targetDate),
    ]);

    final List<EventModel> backendList = results[0];
    final List<EventModel> googleList = results[1];
    final Map<String, EventModel> uniqueEvents = {};

    for (var event in backendList) {
      final key = '${event.title.trim().toLowerCase()}_${event.date}_${normalizeTime(event.startTime)}';
      uniqueEvents[key] = event;
    }

    for (var event in googleList) {
      final key = '${event.title.trim().toLowerCase()}_${event.date}_${normalizeTime(event.startTime)}';
      if (!uniqueEvents.containsKey(key)) {
        uniqueEvents[key] = event;
      }
    }

    return uniqueEvents.values.toList();
  }
}
