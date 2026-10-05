import 'package:alarm/alarm.dart';
import 'package:firebase_messaging/firebase_messaging.dart' hide NotificationSettings;
import 'package:flutter/material.dart';
import 'package:time_verse/config/services/alerm_notification_service.dart';

// @pragma('vm:entry-point')
// Future<void> firebaseBackgroundHandler(RemoteMessage message) async {
//   final title = message.notification?.title ?? message.data['title'];
//   final body = message.notification?.body ?? message.data['body'];

//   await NotificationService.scheduleNotification(
//     id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
//     title: title ?? 'Notification',
//     body: body ?? '',
//     alarmTime: DateTime.now().add(const Duration(seconds: 1)),
//     payload: message.data['eventId'], 
//   );

//   await Alarm.set(
//     alarmSettings: AlarmSettings(
//       id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
//       dateTime: DateTime.now().add(const Duration(seconds: 1)),
//       assetAudioPath: 'assets/alarm.mp3',
//       loopAudio: true,
//       vibrate: true,
//       volumeSettings: VolumeSettings.fixed(volume: 1.0),
//       notificationSettings: NotificationSettings(
//         title: title ?? 'Alarm',
//         body: body ?? '',
//         stopButton: 'STOP',
//       ),
//     ),
//   );
// }

@pragma('vm:entry-point')
Future<void> firebaseBackgroundHandler(RemoteMessage message) async {
  final String title = message.notification?.title ?? 
                       message.data['title'] ?? 
                       message.data['event_title'] ?? 
                       '';
  final String body = message.notification?.body ?? 
                     message.data['body'] ?? 
                     message.data['message'] ?? 
                     message.data['description'] ?? 
                     '';

  if (title.isEmpty && body.isEmpty) return;

  // Extract real eventId from FCM data payload, fallback to timestamp if missing
  final rawEventId = message.data['eventId'] ?? message.data['id'];
  final int alarmId = int.tryParse(rawEventId?.toString() ?? '') ?? 
                      (DateTime.now().millisecondsSinceEpoch ~/ 1000);

  final String payload = rawEventId?.toString() ?? '/home';

  // Always use a valid local asset path for alarm audio in FCM background
  const String fallbackAssetPath = 'assets/alarm.mp3';

  await NotificationService.scheduleNotification(
    id: alarmId,
    title: title,
    body: body,
    alarmTime: DateTime.now().add(const Duration(seconds: 1)),
    payload: payload, 
  );

  await Alarm.set(
    alarmSettings: AlarmSettings(
      id: alarmId, // Matches event.id so Alarm.stop(event.id) can kill it
      dateTime: DateTime.now().add(const Duration(seconds: 1)),
      assetAudioPath: fallbackAssetPath, // Fixed audio error
      loopAudio: true,
      vibrate: true,
      volumeSettings: VolumeSettings.fixed(volume: 1.0),
      notificationSettings: NotificationSettings(
        title: title,
        body: body,
        stopButton: 'STOP',
      ),
      payload: payload,
    ),
  );
}