import 'package:alarm/alarm.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:time_verse/config/app_route/nav_config.dart';
import 'package:time_verse/features/all_events/model/event_model.dart';
import 'package:time_verse/features/auth/auth_service/auth_service.dart';
import 'package:time_verse/features/calender/model/calender_model.dart';

class CalendarController extends ChangeNotifier {
  CalendarModel model = CalendarModel(focusedDay: DateTime.now());

  DateTime get focusedDay => model.focusedDay;
  DateTime? get selectedDay => model.selectedDay;
  final Dio _dio = Dio();

  void onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    model
      ..selectedDay = selectedDay
      ..focusedDay = focusedDay;

      fetchUpcomingEvents(date: selectedDay);
    notifyListeners();
  }
  final List<EventModel> _events = [
    EventModel(
      title: 'Soccer Practice & Fun',
      date: 'Today',
      startTime: '4.00 PM',
      location: 'City Sports Complex', 
      id:0, 
      userName: '', 
      description: '', 
      endTime: '', 
      alarmTime: '', 
      isCompleted: false, 
      createdAt: '', 
      user: 0, 
      isFavorite: false,
    ),
    EventModel(
      title: 'Emma\'s 10th Birthday Party',
      date: 'Saturday, Sep 19,2025',
      startTime: '3.00 - 6:00 PM',
      location: '123 Oak Street, Springfield', 
      id: 0, 
      userName: '', 
      description: '', 
      endTime: '', 
      alarmTime: '', 
      isCompleted: false, 
      createdAt: '', 
      user: 0, 
      isFavorite: false,
    ),
  ];

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

  // ------------------ Fetch events from API ------------------ //
  //  Future<void> fetchUpcomingEvents() async {
  //   try {
  //     final authService = AuthService();
  //     final token = await authService.getToken();
  //     debugPrint('🚀 Token fetched: $token');

  //     final baseUrl = dotenv.env['BASE_URL'] ?? '';
  //     debugPrint('Base URL: $baseUrl');

  //     final response = await _dio.get(
  //       '${baseUrl}api/v1/up-comming/events/',
  //       options: Options(
  //         headers: {
  //           'Authorization': 'Bearer $token',
  //           'Content-Type': 'application/json',
  //         },
  //       ),
  //     );

  //     debugPrint('📦 API Response Status: ${response.statusCode}');
  //     debugPrint('📄 Response data: ${response.data}');

  //     if (response.statusCode == 200) {
  //       final List data = response.data;
  //       debugPrint('✅ Number of events fetched: ${data.length}');

  //       _events
  //         ..clear()
  //         ..addAll(
  //           data.map((json) {
  //             final formattedDate = formatEventDate(json['date'] ?? '');
  //             debugPrint('💬 Event parsed: ${json['title']} - $formattedDate');

  //             return EventModel(
  //               id: json['id'] ?? 0,
  //               userName: json['user_name']?.toString() ?? '',
  //               title: json['title']?.toString() ?? '',
  //               description: json['description']?.toString() ?? '',
  //               date: formattedDate,
  //               startTime: json['start_time']?.toString() ?? '',
  //               endTime: json['end_time']?.toString() ?? '',
  //               location: json['location']?.toString() ?? '',
  //               alarmTime: json['alarm_time']?.toString() ?? '',
  //               isCompleted: json['is_completed'] ?? false,
  //               createdAt: json['created_at']?.toString() ?? '',
  //               user: json['user'] ?? 0,
  //               category: json['category']?.toString(),
  //               isFavorite: json['is_favorite'] ?? false,
  //             );
  //           }).toList(),
  //         );
  //       notifyListeners();
  //       debugPrint('🎉 Events added to controller: ${_events.length}');
  //     }
  //     else {
  //       debugPrint('❌ Failed to load events: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     debugPrint('⚠️ Error fetching events: $e');
  //   }
  // }

  Future<void> fetchUpcomingEvents({DateTime? date}) async {
  try {
    final authService = AuthService();
    final token = await authService.getToken();

    // 1. Format the date for the API (e.g., "2026-04-26")
    // Use the passed date, or the currently selected day, or today as fallback.
    final targetDate = date ?? selectedDay ?? DateTime.now();
    final String formattedQueryDate = DateFormat('yyyy-MM-dd').format(targetDate);

    final baseUrl = dotenv.env['BASE_URL'] ?? '';

    final response = await _dio.get(
      '${baseUrl}api/v1/up-comming/events/',
      // 2. Add the query parameter here
      queryParameters: {'date': formattedQueryDate}, 
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ),
    );

    if (response.statusCode == 200) {
      final List data = response.data;
      _events.clear();
      _events.addAll(data.map((json) {
        final formattedDate = formatEventDate(json['date'] ?? '');
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
          createdAt: json['created_at']?.toString() ?? '',
          user: json['user'] ?? 0,
          category: json['category']?.toString(),
          isFavorite: json['is_favorite'] ?? false,
        );
      }).toList());
      
      notifyListeners();
    }
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
