// lib/services/event_service.dart
import 'package:dio/dio.dart';
import 'package:time_verse/config/services/google_service.dart';
import 'package:time_verse/config/services/offline_service.dart';
import 'package:time_verse/features/all_events/model/event_model.dart';
import 'package:time_verse/features/calender/repository/add_event_repository.dart';
import 'package:time_verse/features/calender/repository/event_detail_utils.dart';

class EventService {
  final AddEventRepository _repository = AddEventRepository();

  Future<EventModel?> createAndSyncEvent({
    required String title,
    required String dateText,
    required String startTime,
    required String endTime,
    required String alarmISO,
    String? location,
    String? categoryName,
    String? note,
    String? apiRepeatValue,
    Map<String, dynamic>? customRepeatMap,
  }) async {
    final backendDate = EventDateTimeUtils.parseBackendDate(dateText.trim());

    try {
      final result = await _repository.createTask(
        title: title.trim(),
        date: backendDate,
        startTime: startTime,
        endTime: endTime,
        location: location?.trim().isEmpty == true ? null : location?.trim(),
        alarmTime: alarmISO,
        categoryName: categoryName?.isEmpty == true ? null : categoryName,
        note: note?.trim(),
        repeat: apiRepeatValue,
        customRepeat: customRepeatMap,
      );

      if (result != null) {
        final resultMap = Map<String, dynamic>.from(result);
        if (resultMap['alarm_time'] == null || resultMap['alarm_time'].toString().isEmpty) {
          resultMap['alarm_time'] = alarmISO;
        }
        resultMap['is_alarm_sent'] = true;

        final eventModel = EventModel.fromMap(resultMap);

        // Sync to Google Calendar if access token is present
        final googleToken = GoogleServices().accessToken;
        if (googleToken != null && googleToken.isNotEmpty) {
          await GoogleServices().createGoogleCalendarEvent(
            accessToken: googleToken,
            title: title.trim(),
            date: backendDate,
            startTime: startTime,
            endTime: endTime,
            description: note,
            location: location,
            repeat: apiRepeatValue,
            customRepeat: customRepeatMap,
          );
        }

        return eventModel;
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.connectionError) {
        
        final isCustom = apiRepeatValue?.toLowerCase() == 'custom';
        final offlineBody = {
          "title": title.trim(),
          "date": backendDate,
          "start_time": startTime,
          "end_time": endTime,
          "alarm_time": alarmISO,
          if (apiRepeatValue != null) "repeat": isCustom ? "custom" : apiRepeatValue,
          if (isCustom && customRepeatMap != null) "custom_repeat": customRepeatMap,
          "is_alarm_sent": true,
          "is_completed": false,
          if (location?.trim().isNotEmpty == true) "location": location!.trim(),
          if (categoryName?.isNotEmpty == true) "category_name": categoryName,
          if (note?.trim().isNotEmpty == true) "type_event_description": note!.trim(),
        };

        await OfflineSyncService().saveToQueue(offlineBody);

        return EventModel(
          id: DateTime.now().millisecondsSinceEpoch % 100000,
          title: title.trim(),
          description: note?.trim() ?? '',
          alarmTime: alarmISO,
          date: backendDate,
          startTime: startTime,
          endTime: endTime,
          location: location?.trim() ?? '',
          isCompleted: false,
          isFavorite: false,
          createdAt: DateTime.now().toIso8601String(),
          user: 0,
          userName: '',
        );
      }
      rethrow;
    }
    return null;
  }
}