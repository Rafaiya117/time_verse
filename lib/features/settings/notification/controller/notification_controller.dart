import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:time_verse/features/settings/notification/model/notification_model.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'package:url_launcher/url_launcher.dart';

// class NotificationSettingsController extends ChangeNotifier {
//   final NotificationSettingsModel _settings = NotificationSettingsModel();

//   // Getters
//   bool get allowNotifications => _settings.allowNotifications;
//   bool get allowAlarms => _settings.allowAlarms;
//   bool get vibrate => _settings.vibrate;
//   double get notificationVolume => _settings.notificationVolume;
//   double get alarmVolume => _settings.alarmVolume;
//   String get selectedRingtone => _settings.selectedRingtone;
//   int snoozeDurationMinutes = 5;

//   // Setters / Actions
//   void setAllowNotifications(bool val) {
//     _settings.allowNotifications = val;
//     notifyListeners();
//   }

//   void setAllowAlarms(bool val) {
//     _settings.allowAlarms = val;
//     notifyListeners();
//   }

//   void setVibrate(bool val) {
//     _settings.vibrate = val;
//     notifyListeners();
//   }

//   void setNotificationVolume(double val) {
//     _settings.notificationVolume = val;
//     notifyListeners();
//   }

//   void setAlarmVolume(double val) {
//     _settings.alarmVolume = val;
//     notifyListeners();
//   }

//   void setSelectedRingtone(String ringtone) {
//     _settings.selectedRingtone = ringtone;
//     notifyListeners();
//   }

//   void setSnoozeDuration(int minutes) {
//     snoozeDurationMinutes = minutes;
//     notifyListeners();
//   }

//   // Request Android 12+ Exact Alarm Intent Permission
//   Future<void> checkAndRequestExactAlarmPermission() async {
//     if (Platform.isAndroid) {
//       final status = await Permission.scheduleExactAlarm.status;
//       if (status.isDenied || status.isPermanentlyDenied) {
//         const intent = AndroidIntent(
//           action: 'android.settings.REQUEST_SCHEDULE_EXACT_ALARM',
//         );
//         await intent.launch();
//       }
//     }
//   }

//   Future<void> openDeviceSoundSettings() async {
//     if (Platform.isAndroid) {
//       const intent = AndroidIntent(action: 'android.settings.SOUND_SETTINGS');
//       await intent.launch();
//     } else if (Platform.isIOS) {
//       final Uri url = Uri.parse('App-Prefs:root=Sounds');
//       if (await canLaunchUrl(url)) {
//         await launchUrl(url);
//       } else {
//         // Fallback for iOS settings root if deep link is restricted
//         await launchUrl(Uri.parse('App-Prefs:'));
//       }
//     }
//   }
// }

class NotificationSettingsController extends ChangeNotifier {
  final NotificationSettingsModel _settings = NotificationSettingsModel();
  
  // Method Channel linked to the native MainActivity setup
  static const MethodChannel _platform = MethodChannel('com.infiniquote.app/ringtone');

  int snoozeDurationMinutes = 5;

  // Getters
  bool get allowNotifications => _settings.allowNotifications;
  bool get allowAlarms => _settings.allowAlarms;
  bool get vibrate => _settings.vibrate;
  double get notificationVolume => _settings.notificationVolume;
  double get alarmVolume => _settings.alarmVolume;
  
  // Fallback cleanly to default asset if no system ringtone path has been captured yet
  String get selectedRingtone => _settings.selectedRingtone.isEmpty ? 'assets/alarm.mp3' : _settings.selectedRingtone;

  // Setters / Actions
  void setAllowNotifications(bool val) {
    _settings.allowNotifications = val;
    notifyListeners();
  }

  void setAllowAlarms(bool val) {
    _settings.allowAlarms = val;
    notifyListeners();
  }

  void setVibrate(bool val) {
    _settings.vibrate = val;
    notifyListeners();
  }

  void setNotificationVolume(double val) {
    _settings.notificationVolume = val;
    notifyListeners();
  }

  void setAlarmVolume(double val) {
    _settings.alarmVolume = val;
    notifyListeners();
  }

  void setSelectedRingtone(String ringtone) {
    _settings.selectedRingtone = ringtone;
    notifyListeners();
  }

  void setSnoozeDuration(int minutes) {
    snoozeDurationMinutes = minutes;
    notifyListeners();
  }

  // CALL THIS: Dynamically requests the active system tone path from Kotlin
  Future<void> fetchAndSyncSystemRingtone() async {
    if (Platform.isAndroid) {
      try {
        final String? systemRingtoneUri = await _platform.invokeMethod('getDefaultRingtoneUri');
        if (systemRingtoneUri != null && systemRingtoneUri.isNotEmpty) {
          setSelectedRingtone(systemRingtoneUri);
        }
      } catch (e) {
        debugPrint("Failed to fetch system ringtone URI: $e");
      }
    }
  }

  // Request Android 12+ Exact Alarm Intent Permission
  Future<void> checkAndRequestExactAlarmPermission() async {
    if (Platform.isAndroid) {
      final status = await Permission.scheduleExactAlarm.status;
      if (status.isDenied || status.isPermanentlyDenied) {
        const intent = AndroidIntent(
          action: 'android.settings.REQUEST_SCHEDULE_EXACT_ALARM',
        );
        await intent.launch();
      }
    }
  }

  Future<void> openDeviceSoundSettings() async {
    if (Platform.isAndroid) {
      const intent = AndroidIntent(action: 'android.settings.SOUND_SETTINGS');
      await intent.launch();
      
      // Delays checking by 2 seconds so the user has time to tweak settings before syncing path
      Future.delayed(const Duration(seconds: 2), () => fetchAndSyncSystemRingtone());
    } else if (Platform.isIOS) {
      final Uri url = Uri.parse('App-Prefs:root=Sounds');
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        await launchUrl(Uri.parse('App-Prefs:'));
      }
    }
  }
}