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
    notifyListeners();
  }
  final List<EventModel> _events = [
    EventModel(
      title: 'Soccer Practice & Fun',
      date: 'Today',
      time: '4.00 PM',
      location: 'City Sports Complex',
    ),
    EventModel(
      title: 'Emma\'s 10th Birthday Party',
      date: 'Saturday, Sep 19,2025',
      time: '3.00 - 6:00 PM',
      location: '123 Oak Street, Springfield',
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
   Future<void> fetchUpcomingEvents() async {
    try {
      final authService = AuthService();
      final token = await authService.getToken();
      debugPrint('🚀 Token fetched: $token');

      final baseUrl = dotenv.env['BASE_URL'] ?? '';
      debugPrint('Base URL: $baseUrl');

      final response = await _dio.get(
        '${baseUrl}api/v1/up-comming/events/',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      debugPrint('📦 API Response Status: ${response.statusCode}');
      debugPrint('📄 Response data: ${response.data}');

      if (response.statusCode == 200) {
        final List data = response.data;
        debugPrint('✅ Number of events fetched: ${data.length}');

        _events
          ..clear()
          ..addAll(data.map((json) {
            final formattedDate = formatEventDate(json['start_date'] ?? '');
            debugPrint('💬 Event parsed: ${json['title']} - $formattedDate');

            return EventModel(
              title: json['title'] ?? '',
              date: formattedDate,
              time: json['start_date'] ?? '', 
              location: json['category_name'] ?? '',
            );
          }).toList());
        notifyListeners();
        debugPrint('🎉 Events added to controller: ${_events.length}');
      } else {
        debugPrint('❌ Failed to load events: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('⚠️ Error fetching events: $e');
    }
  }
}
