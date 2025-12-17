import 'package:alarm/alarm.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart' hide NotificationSettings;
import 'package:time_verse/config/services/alerm_notification_service.dart';

@pragma('vm:entry-point')
Future<void> firebaseBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  final title = message.notification?.title ?? message.data['title'];
  final body = message.notification?.body ?? message.data['body'];

  await NotificationService.scheduleNotification(
    id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
    title: title ?? 'Notification',
    body: body ?? '',
    alarmTime: DateTime.now().add(const Duration(seconds: 1)),
  );

  await Alarm.set(
    alarmSettings: AlarmSettings(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      dateTime: DateTime.now().add(const Duration(seconds: 1)),
      assetAudioPath: 'assets/alarm.mp3',
      loopAudio: true,
      vibrate: true,
      volumeSettings: VolumeSettings.fixed(volume: 1.0),
      notificationSettings: NotificationSettings(
        title: title ?? 'Alarm',
        body: body ?? '',
        stopButton: 'STOP', 
      ),
    ),
  );
}
