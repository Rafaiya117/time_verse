class NotificationSettingsModel {
  bool allowNotifications;
  bool allowAlarms;
  bool vibrate;
  double notificationVolume;
  double alarmVolume;
  String selectedRingtone;

  NotificationSettingsModel({
    this.allowNotifications = true,
    this.allowAlarms = true,
    this.vibrate = true,
    this.notificationVolume = 0.8,
    this.alarmVolume = 1.0,
    this.selectedRingtone = 'Default Chime',
  });
}