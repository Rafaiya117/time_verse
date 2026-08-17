import 'dart:io';
import 'package:flutter/material.dart';
import 'package:time_verse/features/settings/notification/model/notification_model.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'package:url_launcher/url_launcher.dart';

class NotificationSettingsController extends ChangeNotifier {
  final NotificationSettingsModel _settings = NotificationSettingsModel();

  // Getters
  bool get allowNotifications => _settings.allowNotifications;
  bool get allowAlarms => _settings.allowAlarms;
  bool get vibrate => _settings.vibrate;
  double get notificationVolume => _settings.notificationVolume;
  double get alarmVolume => _settings.alarmVolume;
  String get selectedRingtone => _settings.selectedRingtone;
  int snoozeDurationMinutes = 5;

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

  Future<void> openDeviceSoundSettings() async {
    if (Platform.isAndroid) {
      const intent = AndroidIntent(action: 'android.settings.SOUND_SETTINGS');
      await intent.launch();
    } else if (Platform.isIOS) {
      final Uri url = Uri.parse('App-Prefs:root=Sounds');
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        // Fallback for iOS settings root if deep link is restricted
        await launchUrl(Uri.parse('App-Prefs:'));
      }
    }
  }
}
