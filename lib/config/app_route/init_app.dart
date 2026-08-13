import 'package:alarm/alarm.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:time_verse/config/services/alerm_notification_service.dart';
import 'package:time_verse/config/services/firebase/fire_base_service.dart';
import 'package:time_verse/config/services/firebase/firebase_forground.dart';
import 'package:time_verse/firebase_options.dart';
import 'package:timezone/data/latest.dart' as tz;

Future<void> initApp() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    if (e.toString().contains('duplicate-app')) {
      Firebase.app();
    } else {
      rethrow;
    }
  }

  FirebaseMessaging.onBackgroundMessage(firebaseBackgroundHandler);

  tz.initializeTimeZones();
  await Alarm.init();

  await Purchases.configure(
    PurchasesConfiguration('goog_ivtlyZlqEWjaXHEZPUlSfuPOnLE'),
  );
  debugPrint("RevenueCat initialized");

  await _initBackgroundServices();
}

Future<void> _initBackgroundServices() async {
  await FCMService.initialize();
  await NotificationService.init();
}