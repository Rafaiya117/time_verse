import 'package:flutter/material.dart';

abstract class BaseController extends ChangeNotifier {
  bool _isInitialized = false;
  void initOnce() {
    if (_isInitialized) return;
    _isInitialized = true;
    onInit();
  }
  @protected
  void onInit();
}
