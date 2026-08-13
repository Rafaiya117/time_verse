import 'package:alarm/alarm.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:time_verse/config/app_route/nav_config.dart';
import 'package:time_verse/config/services/google_service.dart';
import 'package:time_verse/config/services/user_session.dart';
import 'package:time_verse/features/all_events/model/event_model.dart';
import 'package:time_verse/features/auth/auth_service/auth_service.dart';
import 'package:time_verse/features/calender/model/calender_model.dart';

class CalendarController extends ChangeNotifier {
  CalendarModel model = CalendarModel(focusedDay: DateTime.now());

  DateTime get focusedDay => model.focusedDay;
  DateTime? get selectedDay => model.selectedDay;
  final Dio _dio = Dio();

  // void onDaySelected(DateTime selectedDay, DateTime focusedDay) {
  //   model
  //     ..selectedDay = selectedDay
  //     ..focusedDay = focusedDay;

  //   fetchUpcomingEvents(date: selectedDay);
  //   notifyListeners();
  // }

  void onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    model
      ..selectedDay = selectedDay
      ..focusedDay = focusedDay;

    _events.clear();
    notifyListeners();

    fetchUpcomingEvents(date: selectedDay);
  }

  final List<EventModel> _events = [];
  List<EventModel> get events => List.unmodifiable(_events);

  void removeEvent(int index) {
    _events.removeAt(index);
    notifyListeners();
  }

  int selectedIndex = 0;

  void updateIndexFromRoute(String location) {
    final index = appRoutes.indexWhere((r) => location.startsWith(r));
    if (index != -1 && index != selectedIndex) {
      selectedIndex = index;
      notifyListeners();
    }
  }

  void navigateTo(int index, BuildContext context) {
    selectedIndex = index;
    notifyListeners();
    context.push(appRoutes[index]);
  }

  // ------------------ Reusable date formatter ------------------ //
  String formatEventDate(String rawDate) {
    final startDateTime = DateTime.tryParse(rawDate);
    if (startDateTime == null) return '';

    final now = DateTime.now();
    if (startDateTime.year == now.year &&
        startDateTime.month == now.month &&
        startDateTime.day == now.day) {
      return 'Today';
    } else {
      return DateFormat('EEEE, MMM d, yyyy').format(startDateTime);
    }
  }

  // Helper method: Normalize time format (e.g., "11:00:00" -> "11:00")
  String _normalizeTime(String rawTime) {
    if (rawTime.isEmpty) return '';
    final parts = rawTime.split(':');
    if (parts.length >= 2) {
      return '${parts[0].padLeft(2, '0')}:${parts[1].padLeft(2, '0')}';
    }
    return rawTime;
  }

  // Helper method: Fetch Google Calendar events ONLY if signed in with Google
  Future<List<EventModel>> _fetchGoogleCalendarEvents({DateTime? filterDate}) async {
    final accessToken = GoogleServices().accessToken;
    if (accessToken == null || accessToken.isEmpty) return [];

    final targetDate = filterDate ?? selectedDay ?? DateTime.now();
    final dayStart = DateTime(targetDate.year, targetDate.month, targetDate.day);
    final dayEnd = dayStart.add(const Duration(days: 1));

    final gEventsData = await GoogleServices().getGoogleCalendarEvents(
      accessToken: accessToken,
      timeMin: dayStart,
      timeMax: dayEnd,
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
        location: json['location'] ?? '',
        alarmTime: '',
        isCompleted: false,
        createdAt: DateTime.now().toIso8601String(),
        user: int.tryParse(UserSession().userId ?? '0') ?? 0,
        category: 'Google Calendar',
        isFavorite: false,
      );
    }).toList();
  }

  Future<void> fetchUpcomingEvents({DateTime? date}) async {
    try {
      final authService = AuthService();
      final token = await authService.getToken();

      final targetDate = date ?? selectedDay ?? DateTime.now();
      final String formattedQueryDate = DateFormat('yyyy-MM-dd').format(targetDate);

      final baseUrl = dotenv.env['BASE_URL'] ?? '';

      final response = await _dio.get(
        '${baseUrl}api/v1/up-comming/events/',
        queryParameters: {'date': formattedQueryDate},
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      List<EventModel> apiEvents = [];

      if (response.statusCode == 200) {
        final List data = response.data;
        apiEvents = data.map((json) {
          final formattedDate = formatEventDate(json['date'] ?? '');
          return EventModel(
            id: json['id'] ?? 0,
            userName: json['user_name']?.toString() ?? '',
            title: json['title']?.toString() ?? '',
            description: json['description']?.toString() ?? '',
            date: formattedDate,
            startTime: _normalizeTime(json['start_time']?.toString() ?? ''),
            endTime: _normalizeTime(json['end_time']?.toString() ?? ''),
            location: json['location']?.toString() ?? '',
            alarmTime: json['alarm_time']?.toString() ?? '',
            isCompleted: json['is_completed'] ?? false,
            createdAt: json['created_at']?.toString() ?? '',
            user: json['user'] ?? 0,
            category: json['category']?.toString(),
            isFavorite: json['is_favorite'] ?? false,
          );
        }).toList();
      }

      // Fetch Google Calendar events ONLY if user signed in with Google
      final googleEvents = await _fetchGoogleCalendarEvents(filterDate: targetDate);

      // Deduplicate backend and Google Calendar events based on title, date, and start time
      final Map<String, EventModel> uniqueEvents = {};

      for (var event in [...apiEvents, ...googleEvents]) {
        final key = '${event.title.trim().toLowerCase()}_${event.date}_${_normalizeTime(event.startTime)}';
        
        // Keep backend event if already added, otherwise add Google event
        if (!uniqueEvents.containsKey(key)) {
          uniqueEvents[key] = event;
        }
      }

      _events
        ..clear()
        ..addAll(uniqueEvents.values);

      debugPrint('!--------Upcoming events-----------${_events.length}');
      notifyListeners();
    } catch (e) {
      debugPrint('⚠️ Error fetching events: $e');
    }
  }

  //!------------------ Remove event from API and list ------------------ //
  Future<bool> deleteEvent(int eventId) async {
    try {
      final token = await AuthService().getToken();
      final baseUrl = dotenv.env['BASE_URL'] ?? '';

      final response = await _dio.delete(
        '${baseUrl}api/v1/evenet/delete/$eventId/',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      debugPrint('⚠️ Error deleting event: $e');
      return false;
    }
  }

  Future<bool> removeEventFromList(int eventId) async {
    final success = await deleteEvent(eventId);
    if (success) {
      _events.removeWhere((event) => event.id == eventId);
      debugPrint('✅ Event removed from list: $eventId');
      notifyListeners();
      try {
        await Alarm.stop(eventId);
      } catch (_) {}
      return true;
    }
    return false;
  }

  Future<T?> runWithLoaderAndTimer<T>({
    required BuildContext context,
    required Future<T> Function() task,
  }) async {
    final startTime = DateTime.now();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setState) {
            Duration elapsed = DateTime.now().difference(startTime);

            Future.delayed(const Duration(seconds: 1), () {
              if (context.mounted) setState(() {});
            });

            return Center(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 12),
                    Text(
                      "Deleting...\n${elapsed.inSeconds}s",
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    try {
      final result = await task();
      return result;
    } finally {
      if (context.mounted) Navigator.pop(context);
    }
  }
}