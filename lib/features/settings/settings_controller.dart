import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SettingsController extends ChangeNotifier {
  int selectedIndex = 0;

  final List<String> routes = [
    '/home',
    '/calendar',
    '/add',
    '/saved',
    '/settings',
  ];

  void updateIndexFromRoute(String location) {
    final index = routes.indexWhere((r) => location.startsWith(r));
    if (index != -1 && index != selectedIndex) {
      selectedIndex = index;
      notifyListeners();
    }
  }

  void navigateTo(int index, BuildContext context) {
    selectedIndex = index;
    notifyListeners();
    context.push(routes[index]);
  }
}
