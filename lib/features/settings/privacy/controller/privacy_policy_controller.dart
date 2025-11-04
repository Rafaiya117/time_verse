import 'package:flutter/material.dart';
import 'package:time_verse/features/settings/privacy/privacy_service/privacy_service.dart';


class PrivacyController extends ChangeNotifier {
  final PrivacyService _privacyService = PrivacyService();

  Map<String, dynamic>? _privacyData;
  bool _isLoading = false;
  String? _errorMessage;

  Map<String, dynamic>? get privacyData => _privacyData;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadPrivacyPolicy() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final data = await _privacyService.fetchPrivacyPolicy();
      _privacyData = data;
    } catch (e) {
      _errorMessage = 'Failed to load privacy policy';
    }

    _isLoading = false;
    notifyListeners();
  }
}