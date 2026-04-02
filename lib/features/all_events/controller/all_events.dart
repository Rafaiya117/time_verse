import 'package:alarm/alarm.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:time_verse/config/app_route/nav_config.dart';
import 'package:time_verse/config/services/alerm_service.dart';
import 'package:time_verse/config/services/user_session.dart';
import 'package:time_verse/features/all_events/model/event_model.dart';
import 'package:time_verse/features/auth/auth_service/auth_service.dart';
import 'package:intl/intl.dart';

class AllEventsController extends ChangeNotifier {
  int selectedIndex = 0;
  final Dio _dio = Dio();

   AllEventsController() {
    fetchAllEvents(); 
  }

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
  
  final List<EventModel> _events = [
  //  EventModel(
  //     title: 'Soccer Practice & Fun',
  //     date: 'Today',
  //     startTime: '4.00 PM',
  //     location: 'City Sports Complex', 
  //     id:0, 
  //     userName: '', 
  //     description: '', 
  //     endTime: '', 
  //     alarmTime: '', 
  //     isCompleted: false, 
  //     createdAt: '', 
  //     user: 0, 
  //     isFavorite: false,
  //   ),
  //   EventModel(
  //     title: 'Emma\'s 10th Birthday Party',
  //     date: 'Saturday, Sep 19,2025',
  //     startTime: '3.00 - 6:00 PM',
  //     location: '123 Oak Street, Springfield', 
  //     id: 0, 
  //     userName: '', 
  //     description: '', 
  //     endTime: '', 
  //     alarmTime: '', 
  //     isCompleted: false, 
  //     createdAt: '', 
  //     user: 0, 
  //     isFavorite: false,
  //   ),
  //   EventModel(
  //     title: 'Soccer Practice & Fun',
  //     date: 'Today',
  //     startTime: '4.00 PM',
  //     location: 'City Sports Complex', 
  //     id:0, 
  //     userName: '', 
  //     description: '', 
  //     endTime: '', 
  //     alarmTime: '', 
  //     isCompleted: false, 
  //     createdAt: '', 
  //     user: 0, 
  //     isFavorite: false,
  //   ),
  //   EventModel(
  //     title: 'Emma\'s 10th Birthday Party',
  //     date: 'Saturday, Sep 19,2025',
  //     startTime: '3.00 - 6:00 PM',
  //     location: '123 Oak Street, Springfield', 
  //     id: 0, 
  //     userName: '', 
  //     description: '', 
  //     endTime: '', 
  //     alarmTime: '', 
  //     isCompleted: false, 
  //     createdAt: '', 
  //     user: 0, 
  //     isFavorite: false,
  //   ),
  ];

  List<EventModel> get events => List.unmodifiable(_events);

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

  // ------------------ Fetch events from API ------------------ //
  Future<void> fetchAllEvents() async {
  try {
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
      _events
        ..clear()
        ..addAll(
          data.where((json) => json['user'] == currentUserId).map((json) {
            final formattedDate = formatEventDate(json['date'] ?? '');

            return EventModel(
              id: json['id'] ?? 0,
              userName: json['user_name']?.toString() ?? '',
              title: json['title']?.toString() ?? '',
              description:json['description']?.toString() ?? '',
              date: formattedDate,
              startTime:json['start_time']?.toString() ?? '',
              endTime: json['end_time']?.toString() ?? '',
              location: json['location']?.toString() ?? '',
              alarmTime:json['alarm_time']?.toString() ?? '',
              isCompleted: json['is_completed'] ?? false,
              createdAt:json['created_at']?.toString() ?? '',
              user: json['user'] ?? 0,
              category: json['category']?.toString(),
              isFavorite: json['is_favorite'] ?? false,
            );
          }).toList(),
        );

      notifyListeners();
      await Alarm.stopAll();
      for (final event in _events) {
        if (event.alarmTime.isNotEmpty) {
          await AlarmHelper.scheduleEventAlarm(event);
        }
      }
    }
  } catch (e) {
    debugPrint('⚠️ Error fetching events: $e');
  }
}

  Future<bool> deleteEvent(int eventId) async {
    try {
      final token = await AuthService().getToken();
      final baseUrl = dotenv.env['BASE_URL'] ?? '';

      final response = await _dio.delete(
        '$baseUrl/api/v1/evenet/delete/$eventId/',
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

          // update every second
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
    if (context.mounted) Navigator.pop(context); // close loader
  }
}
}
