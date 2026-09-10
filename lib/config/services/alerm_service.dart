// ignore_for_file: deprecated_member_use
import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:time_verse/features/all_events/model/event_model.dart';

// class AlarmHelper {
//   static final Set<int> _scheduledIds = {};

//   static Future<void> scheduleEventAlarm(EventModel event) async {
//   if (_scheduledIds.contains(event.id)) {
//     debugPrint('🔁 Alarm already scheduled for ${event.title}');
//     return;
//   }

//   try {
//     if (event.alarmTime.isEmpty) return;

//     // 🛠️ FIX: Standardize local ISO parsing
//     final cleanIso = event.alarmTime.trim().replaceAll(RegExp(r'Z$'), '');
//     final localTime = DateTime.parse(cleanIso);

//     if (localTime.isBefore(DateTime.now())) {
//       debugPrint('⛔ Skipping past alarm for ${event.title}: $localTime (Now: ${DateTime.now()})');
//       return;
//     }

//     await Alarm.set(
//       alarmSettings: AlarmSettings(
//         id: event.id,
//         dateTime: localTime,
//         assetAudioPath: 'assets/alarm.mp3',
//         loopAudio: true,
//         vibrate: true,
//         volumeSettings: VolumeSettings.fixed(volume: 1.0),
//         androidFullScreenIntent: true,
//         notificationSettings: NotificationSettings(
//           title: event.title,
//           body: event.description,
//           stopButton: 'STOP',
//           icon: 'notification_icon',
//         ),
//         payload: event.id.toString(),
//       ),
//     );
//     _scheduledIds.add(event.id);
//     debugPrint('⏰ Alarm scheduled for ${event.title} at $localTime');
//   } catch (e) {
//     debugPrint('⚠️ Failed to schedule alarm for ${event.title}: $e');
//   }
// }
//   static void listenToAlarmRingtone(BuildContext context) {
//     Alarm.ringStream.stream.listen((alarmSettings) {
//       if (context.mounted) {
//         context.push('/alarm', extra: alarmSettings);
//       }
//     });
//   }

//   static Future<void> stopAlarm(int id) async {
//     await Alarm.stop(id);
//     _scheduledIds.remove(id);
//   }

//   static Future<void> scheduleAlarmsForEvents(List<EventModel> events) async {
//     for (var event in events) {
//       await scheduleEventAlarm(event);
//     }
//   }

//   static void resetScheduledIds() {
//     _scheduledIds.clear();
//   }
// }

class AlarmHelper {
  static final Set<int> _scheduledIds = {};

  static Future<void> scheduleEventAlarm(
    EventModel event, [
    List<DateTime>? occurrences,
  ]) async {

    final timesToSchedule = occurrences ?? [];
    // Fallback to primary event alarm time if no occurrences list is provided
    if (timesToSchedule.isEmpty && event.alarmTime.isNotEmpty) {
      final cleanIso = event.alarmTime.trim().replaceAll(RegExp(r'Z$'), '');
      final parsed = DateTime.tryParse(cleanIso);
      if (parsed != null) timesToSchedule.add(parsed);
    }

    for (int i = 0; i < timesToSchedule.length; i++) {
      final localTime = timesToSchedule[i];
      final alarmId = event.id * 100 + i;

      if (_scheduledIds.contains(alarmId)) {
        debugPrint('🔁 Alarm already scheduled with ID $alarmId for ${event.title}');
        continue;
      }

      if (localTime.isBefore(DateTime.now())) {
        debugPrint('⛔ Skipping past alarm for ${event.title}: $localTime (Now: ${DateTime.now()})');
        continue;
      }

      try {
        await Alarm.set(
          alarmSettings: AlarmSettings(
            id: alarmId,
            dateTime: localTime,
            assetAudioPath: 'assets/alarm.mp3',
            loopAudio: true,
            vibrate: true,
            volumeSettings: VolumeSettings.fixed(volume: 1.0),
            androidFullScreenIntent: true,
            notificationSettings: NotificationSettings(
              title: event.title,
              body: event.description,
              stopButton: 'STOP',
              icon: 'notification_icon',
            ),
            payload: event.id.toString(),
          ),
        );
        _scheduledIds.add(alarmId);
        debugPrint('⏰ Alarm scheduled for ${event.title} at $localTime (ID: $alarmId)');
      } catch (e) {
        debugPrint('⚠️ Failed to schedule alarm for ${event.title}: $e');
      }
    }
  }

  static void listenToAlarmRingtone(BuildContext context) {
    Alarm.ringStream.stream.listen((alarmSettings) {
      if (context.mounted) {
        context.push('/alarm', extra: alarmSettings);
      }
    });
  }

  static Future<void> stopAlarm(int id) async {
    await Alarm.stop(id);
    _scheduledIds.remove(id);
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