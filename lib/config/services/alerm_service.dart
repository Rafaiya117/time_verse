// ignore_for_file: deprecated_member_use
import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:time_verse/features/all_events/model/event_model.dart';
import 'package:time_verse/features/calender/repository/add_event_repository.dart';
import 'package:time_verse/features/settings/notification/controller/notification_controller.dart';



class AlarmHelper {
  static final Set<int> _scheduledIds = {};
  static const MethodChannel _ringtoneChannel = MethodChannel('com.infiniquote.app/ringtone');

  static Future<void> scheduleEventAlarm(
    BuildContext context, 
    EventModel event, [
    List<DateTime>? occurrences,
  ]) async {

    final timesToSchedule = occurrences != null && occurrences.isNotEmpty 
        ? List<DateTime>.from(occurrences) 
        : <DateTime>[];

    // 💡 FIX: Generate occurrences for repeating events if none were provided
    if (timesToSchedule.isEmpty && event.alarmTime.isNotEmpty) {
      final cleanIso = event.alarmTime.trim().replaceAll(RegExp(r'Z$'), '');
      final parsed = DateTime.tryParse(cleanIso);
      
      if (parsed != null) {
        final repeatRule = event.repeat?.toLowerCase().trim() ?? '';
        if (repeatRule.isNotEmpty && repeatRule != "don't repeat") {
          final repo = AddEventRepository();
          timesToSchedule.addAll(
            repo.generateAlarmOccurrences(
              startDateTime: parsed,
              selectedRepeat: event.repeat,
              customRepeatCount: 1,
              customRepeatUnit: 'week',
              selectedDays: [],
              repeatEndType: 'Never',
              customEndDate: DateTime.now().add(const Duration(days: 365)),
              customOccurrences: 30,
            ),
          );
        } else {
          timesToSchedule.add(parsed);
        }
      }
    }

    final controller = context.read<NotificationSettingsController>();
    String targetRingtonePath = controller.selectedRingtone;

    if (!targetRingtonePath.startsWith('content://') && !targetRingtonePath.startsWith('file://')) {
      try {
        final String? systemUri = await _ringtoneChannel.invokeMethod('getDefaultRingtoneUri');
        if (systemUri != null && systemUri.isNotEmpty) {
          targetRingtonePath = systemUri;
          controller.setSelectedRingtone(systemUri);
          debugPrint('🎯 SUCCESS: Fetched and verified native device alarm URI: $targetRingtonePath');
        } else {
          debugPrint('⚠️ WARNING: Native channel returned an empty URI string.');
        }
      } catch (e) {
        debugPrint('⚠️️ ERROR: Failed to communicate over native MethodChannel: $e');
      }
    }

    if (targetRingtonePath.isEmpty) {
      targetRingtonePath = 'assets/alarm.mp3';
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
            assetAudioPath: targetRingtonePath,
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
        debugPrint('⏰ Alarm scheduled for ${event.title} at $localTime (ID: $alarmId) with Path: $targetRingtonePath');
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

  static Future<void> scheduleAlarmsForEvents(BuildContext context, List<EventModel> events) async {
    for (var event in events) {
      await scheduleEventAlarm(context, event);
    }
  }

  static void resetScheduledIds() {
    _scheduledIds.clear();
  }
}