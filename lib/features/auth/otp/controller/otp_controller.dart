import 'package:flutter/material.dart';
import 'package:time_verse/features/auth/auth_service/auth_service.dart';

import 'dart:async';

class OtpController extends ChangeNotifier {
  final otpController = TextEditingController();
  final AuthService _authService = AuthService();

  String? otpError;

  Timer? _timer;
  int _secondsRemaining = 180; // 3 minutes

  String get formattedTime {
    final minutes = (_secondsRemaining ~/ 60).toString().padLeft(2, '0');
    final seconds = (_secondsRemaining % 60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  void startTimer() {
    _timer?.cancel(); // avoid duplicate timers
    _secondsRemaining = 180;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        _secondsRemaining--;
        notifyListeners(); // 🔥 update UI
      } else {
        timer.cancel();
      }
    });
  }

  void disposeControllers() {
    otpController.dispose();
    _timer?.cancel(); // ✅ important
  }

  bool areFieldsFilled(List<TextEditingController> controllers) {
    for (final controller in controllers) {
      if (controller.text.trim().isEmpty) {
        return false;
      }
    }
    return true;
  }

  bool validateOtpField() {
    return areFieldsFilled([otpController]);
  }

  Future<bool> verifyOtpUser(String email, String otp) async {
    try {
      final response = await _authService.verifyOtp(email, otp);
      if (response['success'] == true) {
        return true;
      } else {
        otpError = response['error'] ?? response['message'];
        return false;
      }
    } catch (e) {
      otpError = 'Something went wrong. Please try again.';
      return false;
    }
  }
}