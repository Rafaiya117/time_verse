import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:time_verse/config/app_route/nav_config.dart';
import 'package:time_verse/config/services/alerm_service.dart';
import 'package:time_verse/features/all_events/model/event_model.dart';
import 'package:time_verse/features/all_events/repository/all_event_repository.dart';

class AllEventsController extends ChangeNotifier {
  final AllEventRepository _repository;

  int selectedIndex = 0;
  final List<EventModel> _events = [];
  List<EventModel> get events => List.unmodifiable(_events);

  AllEventsController({AllEventRepository? repository}) : _repository = repository ?? AllEventRepository() {
    fetchAllEvents();
  }

  void updateIndexFromRoute(String location) {
    final index = appRoutes.indexWhere((r) => location.startsWith(r));
    if (index != -1 && index != selectedIndex) {
      selectedIndex = index;
      notifyListeners();
    }
  }

  void navigateTo(int index, BuildContext context) {
    selectedIndex = index;
    notifyListeners();
    context.push(appRoutes[index]);
  }

  String formatEventDate(String rawDate) {
    return _repository.formatEventDate(rawDate);
  }

  Future<void> fetchAllEvents() async {
    try {
      final apiEvents = await _repository.fetchApiEvents();
      final googleEvents = await _repository.fetchGoogleCalendarEvents();

      _events
        ..clear()
        ..addAll(apiEvents)
        ..addAll(googleEvents);

      debugPrint('All event data-----------${_events.length}');
      notifyListeners();

      await Alarm.stopAll();
      final nowWithBuffer = DateTime.now().subtract(const Duration(minutes: 1));

      for (final event in _events) {
        if (event.alarmTime.isNotEmpty) {
          final cleanIso = event.alarmTime.trim().replaceAll(RegExp(r'Z$'), '');
          final parsedAlarm = DateTime.tryParse(cleanIso);

          if (parsedAlarm != null && parsedAlarm.isAfter(nowWithBuffer)) {
            try {
              await AlarmHelper.scheduleEventAlarm(event);
              debugPrint("⏰ Successfully scheduled alarm for: ${event.title} at $parsedAlarm");
            } catch (alarmError) {
              debugPrint("❌ Failed to set alarm for ${event.title}: $alarmError");
            }
          } else {
            debugPrint(
              "⚠️ Alarm skipped for ${event.title}. Time past or invalid: ${event.alarmTime} (Parsed: $parsedAlarm, Now: ${DateTime.now()})",
            );
          }
        }
      }
    } catch (e) {
      debugPrint('⚠️ Error fetching events: $e');
    }
  }

  Future<bool> deleteEvent(EventModel event, {String deleteType = 'single'}) async {
    try {
      final success = await _repository.deleteEvent(event, deleteType: deleteType);
      if (success) {
        _events.removeWhere((e) => e.id == event.id);
        notifyListeners();
      }
      return success;
    } catch (e) {
      debugPrint('⚠️ Error deleting event: $e');
      return false;
    }
  }

  Future<bool> removeEventFromList(EventModel event, {String deleteType = 'single'}) async {
    final success = await deleteEvent(event, deleteType: deleteType);
    if (success) {
      debugPrint('✅ Event removed from list: ${event.id}');
      try {
        await Alarm.stop(event.id);
      } catch (_) {}
      return true;
    }
    return false;
  }

  Future<T?> runWithLoaderAndTimer<T>({
    required BuildContext context,
    required Future<T> Function() task,
  }) async {
    final startTime = DateTime.now();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setState) {
            Duration elapsed = DateTime.now().difference(startTime);

            Future.delayed(const Duration(seconds: 1), () {
              if (context.mounted) setState(() {});
            });

            return Center(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 12),
                    Text(
                      "Deleting...\n${elapsed.inSeconds}s",
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    try {
      final result = await task();
      return result;
    } finally {
      if (context.mounted) Navigator.pop(context);
    }
  }
}
