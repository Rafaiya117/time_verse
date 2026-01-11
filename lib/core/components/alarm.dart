import 'dart:async';
import 'package:alarm/alarm.dart';
import 'package:alarm/model/alarm_settings.dart';
import 'package:alarm/utils/alarm_set.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:time_verse/config/app_route/app_route.dart';

class ExampleAlarmRingScreen extends StatefulWidget {
  const ExampleAlarmRingScreen({required this.alarmSettings, super.key});

  final AlarmSettings alarmSettings;

  @override
  State<ExampleAlarmRingScreen> createState() => _ExampleAlarmRingScreenState();
}

class _ExampleAlarmRingScreenState extends State<ExampleAlarmRingScreen> {
  StreamSubscription<AlarmSet>? _subscription;

  @override
  void initState() {
    super.initState();
    debugPrint('********${widget.alarmSettings}********');
    _subscription = Alarm.ringing.listen((alarms) {
      if (alarms.containsId(widget.alarmSettings.id)) return;
      if (mounted) Navigator.pop(context);
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final notification = widget.alarmSettings.notificationSettings;
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
           Text('Alarm ringing for ${notification.title ?? 'Alarm Ringing'}'),
           Padding(
             padding: const EdgeInsets.all(12.0),
             child: Text(notification.body ?? ''),
           ),
            const Text('🔔', style: TextStyle(fontSize: 80)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    await Alarm.set(
                      alarmSettings: widget.alarmSettings.copyWith(
                        dateTime: DateTime.now().add(
                          const Duration(minutes: 1),
                        ),
                      ),
                    );

                    if (!mounted) return;
                    appRouter.go('/'); // 👈 REQUIRED
                  },
                  child: const Text('SNOOZE'),
                ),

                ElevatedButton(
                  onPressed: () async {
                    await Alarm.stop(widget.alarmSettings.id);
                    if (!mounted) return;
                    appRouter.go('/');
                  },
                  child: const Text('STOP'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
