import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:time_verse/config/services/google_service.dart';
import 'package:time_verse/features/all_events/model/event_model.dart';
import 'package:time_verse/features/auth/auth_service/auth_service.dart';
import 'package:time_verse/features/calender/model/calender_model.dart';
import 'package:time_verse/features/calender/services/calender_sync_service.dart';
import 'package:time_verse/features/calender/services/event_alarm_service.dart';

class CalendarController extends ChangeNotifier {
  CalendarModel model = CalendarModel(
    focusedDay: DateTime.now(),
    selectedDay: DateTime.now(), // Default to today
  );

  final CalendarSyncService _syncService = CalendarSyncService();
  final EventAlarmService _alarmService = EventAlarmService();
  final Dio _dio = Dio();

  DateTime get focusedDay => model.focusedDay;
  DateTime? get selectedDay => model.selectedDay;

  final List<EventModel> _events = [];
  List<EventModel> get events => List.unmodifiable(_events);

  DateTime? _lastTapDate;
  DateTime? _lastTapTime;

  // Single-tap updates date schedule; double-tap navigates to AddEventPage with date
  void handleDayTap(BuildContext context, DateTime selectedDay, DateTime focusedDay) {
    final now = DateTime.now();

    if (_lastTapDate != null &&
        isSameDay(_lastTapDate!, selectedDay) &&
        _lastTapTime != null &&
        now.difference(_lastTapTime!) < const Duration(milliseconds: 400)) {
      _lastTapDate = null;
      _lastTapTime = null;

      final formattedDate = DateFormat('MMMM d, yyyy').format(selectedDay);
      context.push('/add_event?selectedDate=$formattedDate');
    } else {
      _lastTapDate = selectedDay;
      _lastTapTime = now;
      onDaySelected(selectedDay, focusedDay);
    }
  }

  void onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    model
      ..selectedDay = selectedDay
      ..focusedDay = focusedDay;
    notifyListeners();

    fetchUpcomingEvents(date: selectedDay);
  }

  bool isSameDay(DateTime? a, DateTime? b) {
    if (a == null || b == null) return false;
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  Future<void> fetchUpcomingEvents({DateTime? date}) async {
    final targetDate = date ?? selectedDay ?? DateTime.now();
    final combinedEvents = await _syncService.fetchCombinedEvents(targetDate);

    _events
      ..clear()
      ..addAll(combinedEvents);

    notifyListeners();
  }

  Future<bool> deleteEvent(EventModel event, {String deleteType = 'single'}) async {
    try {
      if (event.category == 'Google Calendar') {
        final accessToken = await GoogleServices().getValidAccessToken();
        if (accessToken == null || accessToken.isEmpty) return false;

        final googleEventId = event.location.isNotEmpty ? event.location : event.createdAt;
        final success = await GoogleServices().deleteGoogleCalendarEvent(
          accessToken: accessToken,
          eventId: googleEventId,
        );

        if (success) {
          _events.removeWhere((e) => e.id == event.id);
          notifyListeners();
        }
        return success;
      }

      final token = await AuthService().getToken();
      final baseUrl = dotenv.env['BASE_URL'] ?? '';

      final response = await _dio.delete(
        '${baseUrl}api/v1/event/delete/${event.id}/?delete_type=$deleteType',
        options: Options(headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        }),
      );

      final isSuccess = response.statusCode == 200 || response.statusCode == 204;
      if (isSuccess) {
        _events.removeWhere((e) => e.id == event.id);
        notifyListeners();
      }
      return isSuccess;
    } catch (e) {
      debugPrint('⚠️ Error deleting event: $e');
      return false;
    }
  }

  Future<bool> removeEventFromList(EventModel event, {String deleteType = 'single'}) async {
    final success = await deleteEvent(event, deleteType: deleteType);
    if (success) {
      await _alarmService.cancelReminders(event.id);
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
                    Text("Deleting...\n${elapsed.inSeconds}s", textAlign: TextAlign.center),
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