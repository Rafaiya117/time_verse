import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:time_verse/features/all_events/model/event_model.dart';

class AlarmHelper {
  static Future<void> scheduleEventAlarm(EventModel event) async {
    try {
      final alarmDateTime = DateTime.parse(event.alarmTime).toLocal();
      if (alarmDateTime.isBefore(DateTime.now())) return;

      await Alarm.set(
        alarmSettings: AlarmSettings(
          id: event.id,
          dateTime: alarmDateTime,
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

      debugPrint('⏰ Alarm scheduled for ${event.title} at $alarmDateTime');
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
