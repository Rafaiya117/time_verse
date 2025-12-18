import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:time_verse/features/all_events/model/event_model.dart';
import 'package:timezone/timezone.dart' as tz;

class AlarmHelper {
  static final Set<int> _scheduledIds = {};

  static Future<void> scheduleEventAlarm(EventModel event) async {
    if (_scheduledIds.contains(event.id)) {
      debugPrint('🔁 Alarm already scheduled for ${event.title}');
      return;
    }

    try {
      final utcTime = DateTime.parse(event.alarmTime);
      final localTime = tz.TZDateTime.from(utcTime, tz.local);

      if (localTime.isBefore(tz.TZDateTime.now(tz.local))) {
        debugPrint('⛔ Skipping past alarm: ${event.title}');
        return;
      }

      await Alarm.set(
        alarmSettings: AlarmSettings(
          id: event.id,
          dateTime: localTime,
          assetAudioPath: 'assets/alarm.mp3',
          loopAudio: true,
          vibrate: true,
          volumeSettings: VolumeSettings.fixed(volume: 1.0),
          notificationSettings: NotificationSettings(
            title: event.title,
            body: event.description,
            stopButton: 'STOP',
          ),
        ),
      );

      _scheduledIds.add(event.id);

      debugPrint('⏰ Alarm scheduled for ${event.title} at $localTime');
    } catch (e) {
      debugPrint('⚠️ Failed to schedule alarm for ${event.title}: $e');
    }
  }
  static Future<void> scheduleAlarmsForEvents(List<EventModel> events) async {
    for (var event in events) {
      await scheduleEventAlarm(event);
    }
  }
}
