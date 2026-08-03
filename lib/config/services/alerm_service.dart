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
      if (event.alarmTime.isEmpty) return;

      // DateTime.parse().toLocal() converts both "2026-08-03T08:59:00Z" and "2026-08-03T14:59:00" 
      // accurately into your device's exact local time (14:59:00 local)
      final localTime = DateTime.parse(event.alarmTime).toLocal();

      if (localTime.isBefore(DateTime.now())) {
        debugPrint('⛔ Skipping past alarm for ${event.title}: $localTime (Now: ${DateTime.now()})');
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

  static void resetScheduledIds() {
    _scheduledIds.clear();
  }
}