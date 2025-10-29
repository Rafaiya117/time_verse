import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:time_verse/config/app_route/nav_config.dart';

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
}