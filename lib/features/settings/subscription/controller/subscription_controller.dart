import 'package:flutter/material.dart';

class SubscriptionController extends ChangeNotifier {
  int? _selectedIndex;

  int? get selectedIndex => _selectedIndex;

  void selectCard(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  bool isCardSelected(int index) => _selectedIndex == index;
}
