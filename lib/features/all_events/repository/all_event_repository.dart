import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'package:time_verse/config/services/google_service.dart';
import 'package:time_verse/config/services/user_session.dart';
import 'package:time_verse/features/all_events/model/event_model.dart';
import 'package:time_verse/features/auth/auth_service/auth_service.dart';

// class AllEventRepository {
//   final Dio _dio = Dio();

//   String formatEventDate(String rawDate) {
//     final startDateTime = DateTime.tryParse(rawDate);
//     if (startDateTime == null) return rawDate;

//     // Directly returns actual date string instead of returning 'Today'
//     return DateFormat('EEEE, MMM d, yyyy').format(startDateTime);
//   }

//   Future<List<EventModel>> fetchGoogleCalendarEvents() async {
//     final accessToken = GoogleServices().accessToken;
//     if (accessToken == null || accessToken.isEmpty) return [];

//     final gEventsData = await GoogleServices().getGoogleCalendarEvents(
//       accessToken: accessToken,
//       timeMin: DateTime.now().subtract(const Duration(days: 30)),
//     );

//     return gEventsData.map((json) {
//       final rawStart = json['startTime'] ?? '';
//       final rawEnd = json['endTime'] ?? '';

//       String extractTime(String isoString) {
//         final dt = DateTime.tryParse(isoString);
//         return dt != null ? DateFormat('HH:mm').format(dt) : '';
//       }

//       return EventModel(
//         id: json['id'].hashCode,
//         userName: UserSession().username ?? 'Google Calendar',
//         title: json['title'] ?? '',
//         description: json['description'] ?? '',
//         date: formatEventDate(rawStart),
//         startTime: extractTime(rawStart),
//         endTime: extractTime(rawEnd),
//         location: json['google_id'] ?? '',
//         alarmTime: json['alarm_time'] ?? '',
//         isCompleted: false,
//         createdAt: rawStart.isNotEmpty ? rawStart : DateTime.now().toIso8601String(),
//         user: int.tryParse(UserSession().userId ?? '0') ?? 0,
//         category: 'Google Calendar',
//         isFavorite: false,
//       );
//     }).toList();
//   }

//   Future<List<EventModel>> fetchApiEvents() async {
//     final authService = AuthService();
//     final token = await authService.getToken();
//     final baseUrl = dotenv.env['BASE_URL'] ?? '';

//     final response = await _dio.get(
//       '${baseUrl}api/v1/event/',
//       options: Options(
//         headers: {
//           'Authorization': 'Bearer $token',
//           'Content-Type': 'application/json',
//         },
//       ),
//     );

//     if (response.statusCode == 200) {
//       final List data = response.data;
//       final currentUserId = int.tryParse(UserSession().userId ?? '');

//       return data.where((json) => json['user'] == currentUserId).map((json) {
//         final rawDate = json['date']?.toString() ?? '';
//         final formattedDate = formatEventDate(rawDate);
//         return EventModel(
//           id: json['id'] ?? 0,
//           userName: json['user_name']?.toString() ?? '',
//           title: json['title']?.toString() ?? '',
//           description: json['description']?.toString() ?? '',
//           date: formattedDate,
//           startTime: json['start_time']?.toString() ?? '',
//           endTime: json['end_time']?.toString() ?? '',
//           location: json['location']?.toString() ?? '',
//           alarmTime: json['alarm_time']?.toString() ?? '',
//           isCompleted: json['is_completed'] ?? false,
//           createdAt: rawDate.isNotEmpty ? rawDate : (json['created_at']?.toString() ?? ''),
//           user: json['user'] ?? 0,
//           category: json['category']?.toString(),
//           isFavorite: json['is_favorite'] ?? false,
//         );
//       }).toList();
//     }
//     return [];
//   }

//   // Future<bool> deleteEvent(EventModel event) async {
//   //   if (event.category == 'Google Calendar') {
//   //     final accessToken = GoogleServices().accessToken;
//   //     if (accessToken == null || accessToken.isEmpty) {
//   //       debugPrint('⚠️ No access token available for Google Calendar delete');
//   //       return false;
//   //     }

//   //     final googleEventId = event.location;
//   //     if (googleEventId.isEmpty) return false;

//   //     return await GoogleServices().deleteGoogleCalendarEvent(
//   //       accessToken: accessToken,
//   //       eventId: googleEventId,
//   //     );
//   //   }

//   //   final token = await AuthService().getToken();
//   //   final baseUrl = dotenv.env['BASE_URL'] ?? '';

//   //   final response = await _dio.delete(
//   //     '${baseUrl}api/v1/evenet/delete/${event.id}/',
//   //     options: Options(
//   //       headers: {
//   //         'Authorization': 'Bearer $token',
//   //         'Content-Type': 'application/json',
//   //       },
//   //     ),
//   //   );

//   //   return response.statusCode == 200 || response.statusCode == 204;
//   // }


//   Future<bool> deleteEvent(EventModel event, {String deleteType = 'single'}) async {
//     if (event.category == 'Google Calendar') {
//       final accessToken = GoogleServices().accessToken;
//       if (accessToken == null || accessToken.isEmpty) {
//         debugPrint('⚠️ No access token available for Google Calendar delete');
//         return false;
//       }

//       final googleEventId = event.location;
//       if (googleEventId.isEmpty) return false;

//       return await GoogleServices().deleteGoogleCalendarEvent(
//         accessToken: accessToken,
//         eventId: googleEventId,
//       );
//     }

//     final token = await AuthService().getToken();
//     final baseUrl = dotenv.env['BASE_URL'] ?? '';

//     final response = await _dio.delete(
//       '${baseUrl}api/v1/event/delete/${event.id}/?delete_type=$deleteType',
//       options: Options(
//         headers: {
//           'Authorization': 'Bearer $token',
//           'Content-Type': 'application/json',
//         },
//       ),
//     );

//     return response.statusCode == 200 || response.statusCode == 204;
//   }
// }

class AllEventRepository {
  final Dio _dio = Dio();

  String formatEventDate(String rawDate) {
    final startDateTime = DateTime.tryParse(rawDate);
    if (startDateTime == null) return rawDate;

    // Directly returns actual date string instead of returning 'Today'
    return DateFormat('EEEE, MMM d, yyyy').format(startDateTime);
  }

  Future<List<EventModel>> fetchGoogleCalendarEvents() async {
    final accessToken = await GoogleServices().getValidAccessToken();
    if (accessToken == null || accessToken.isEmpty) return [];

    final gEventsData = await GoogleServices().getGoogleCalendarEvents(
      accessToken: accessToken,
      timeMin: DateTime.now().subtract(const Duration(days: 30)),
    );

    return gEventsData.map((json) {
      final rawStart = json['startTime'] ?? '';
      final rawEnd = json['endTime'] ?? '';

      String extractTime(String isoString) {
        final dt = DateTime.tryParse(isoString);
        return dt != null ? DateFormat('HH:mm').format(dt) : '';
      }

      return EventModel(
        id: json['id'].hashCode,
        userName: UserSession().username ?? 'Google Calendar',
        title: json['title'] ?? '',
        description: json['description'] ?? '',
        date: formatEventDate(rawStart),
        startTime: extractTime(rawStart),
        endTime: extractTime(rawEnd),
        location: json['google_id'] ?? '',
        alarmTime: json['alarm_time'] ?? '',
        isCompleted: false,
        createdAt: rawStart.isNotEmpty ? rawStart : DateTime.now().toIso8601String(),
        user: int.tryParse(UserSession().userId ?? '0') ?? 0,
        category: 'Google Calendar',
        isFavorite: false,
      );
    }).toList();
  }

  Future<List<EventModel>> fetchApiEvents() async {
    final authService = AuthService();
    final token = await authService.getToken();
    final baseUrl = dotenv.env['BASE_URL'] ?? '';

    final response = await _dio.get(
      '${baseUrl}api/v1/event/',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ),
    );

    if (response.statusCode == 200) {
      final List data = response.data;
      final currentUserId = int.tryParse(UserSession().userId ?? '');

      return data.where((json) => json['user'] == currentUserId).map((json) {
        final rawDate = json['date']?.toString() ?? '';
        final formattedDate = formatEventDate(rawDate);
        return EventModel(
          id: json['id'] ?? 0,
          userName: json['user_name']?.toString() ?? '',
          title: json['title']?.toString() ?? '',
          description: json['description']?.toString() ?? '',
          date: formattedDate,
          startTime: json['start_time']?.toString() ?? '',
          endTime: json['end_time']?.toString() ?? '',
          location: json['location']?.toString() ?? '',
          alarmTime: json['alarm_time']?.toString() ?? '',
          isCompleted: json['is_completed'] ?? false,
          createdAt: rawDate.isNotEmpty ? rawDate : (json['created_at']?.toString() ?? ''),
          user: json['user'] ?? 0,
          category: json['category']?.toString(),
          isFavorite: json['is_favorite'] ?? false,
        );
      }).toList();
    }
    return [];
  }

  Future<bool> deleteEvent(EventModel event, {String deleteType = 'single'}) async {
    if (event.category == 'Google Calendar') {
      final accessToken = await GoogleServices().getValidAccessToken();
      if (accessToken == null || accessToken.isEmpty) {
        debugPrint('⚠️ No access token available for Google Calendar delete');
        return false;
      }

      final googleEventId = event.location.isNotEmpty ? event.location : event.createdAt;
      if (googleEventId.isEmpty) return false;

      return await GoogleServices().deleteGoogleCalendarEvent(
        accessToken: accessToken,
        eventId: googleEventId,
      );
    }

    final token = await AuthService().getToken();
    final baseUrl = dotenv.env['BASE_URL'] ?? '';

    final response = await _dio.delete(
      '${baseUrl}api/v1/event/delete/${event.id}/?delete_type=$deleteType',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ),
    );

    return response.statusCode == 200 || response.statusCode == 204;
  }
}