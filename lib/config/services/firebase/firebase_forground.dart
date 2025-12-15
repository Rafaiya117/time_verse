import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:time_verse/config/services/alerm_notification_service.dart';

@pragma('vm:entry-point')
Future<void> firebaseBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  final title =
      message.notification?.title ?? message.data['title'];
  final body =
      message.notification?.body ?? message.data['body'];

  await NotificationService.scheduleNotification(
    id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
    title: title ?? 'Notification',
    body: body ?? '',
    alarmTime: DateTime.now().add(const Duration(seconds: 1)),
  );
}
