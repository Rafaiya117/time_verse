import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:time_verse/config/app_route/nav_config.dart';
import 'package:time_verse/features/all_events/custom_widget/event_remove_modal.dart';
import 'package:time_verse/features/all_events/model/event_model.dart';
import 'package:time_verse/features/auth/auth_service/auth_service.dart';

import 'package:intl/intl.dart';

class AllEventsController extends ChangeNotifier {
  int selectedIndex = 0;
  final Dio _dio = Dio();

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

  void confirmAndRemoveEvent(BuildContext context, int index) {
    showRemoveEventDialog(
      context,
      onConfirm: () {
        removeEvent(index);
      },
    );
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
  Future<void> fetchEvents() async {
    try {
      final authService = AuthService();
      //final token = await authService.getToken();
      final token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzY0NzkxOTE1LCJpYXQiOjE3NjQ0OTE5MTUsImp0aSI6ImQ0ZmZiMzA0ODQ1ODQwMmM5YmFlMGVlYmU1YmQ5Yzk1IiwidXNlcl9pZCI6IjI3In0.4eETFk_9AwVkJtsosOZJBP5Pub3pJ5ZEGypEfrFPMSs";
      debugPrint('🚀 Token fetched: $token');

      final baseUrl = dotenv.env['BASE_URL'] ?? '';
      debugPrint('🌐 Base URL: $baseUrl');

      final response = await _dio.get(
        '${baseUrl}api/v1/event/',
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
          ..addAll(
            data.map((json) {
              final formattedDate = formatEventDate(json['date'] ?? '');
              debugPrint('💬 Event parsed: ${json['title']} - $formattedDate');

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
            }).toList(),
          );        
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
