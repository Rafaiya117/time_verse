import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:time_verse/config/app_route/nav_config.dart';
import 'package:time_verse/features/all_events/custom_widget/event_remove_modal.dart';
import 'package:time_verse/features/all_events/model/event_model.dart';

class AllEventsController extends ChangeNotifier{
  int selectedIndex = 0;

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
  final List<EventModel> _events = [
    EventModel(
      title: 'Soccer Practice & Fun',
      date: 'Today',
      time: '4.00 PM',
      location: 'City Sports Complex',
    ),
    EventModel(
      title: 'Emma\'s 10th Birthday Party',
      date: 'Saturday, Sep 19,2025',
      time: '3.00 - 6:00 PM',
      location: '123 Oak Street, Springfield',
    ),
    EventModel(
      title: 'Soccer Practice & Fun',
      date: 'Today',
      time: '4.00 PM',
      location: 'City Sports Complex',
    ),
    EventModel(
      title: 'Emma\'s 10th Birthday Party',
      date: 'Saturday, Sep 19,2025',
      time: '3.00 - 6:00 PM',
      location: '123 Oak Street, Springfield',
    ),
  ];

  List<EventModel> get events => List.unmodifiable(_events);

  void removeEvent(int index) {
    _events.removeAt(index);
    notifyListeners();
  }
  void confirmAndRemoveEvent(BuildContext context, int index) {
  showRemoveEventDialog(
    context,
    onConfirm: () {
      removeEvent(index);
    },
  );
}

}