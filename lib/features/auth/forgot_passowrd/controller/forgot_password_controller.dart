import 'package:flutter/material.dart';
import 'package:time_verse/features/auth/auth_service/auth_service.dart';

class ForgotPasswordController extends ChangeNotifier{
  TextEditingController emailController = TextEditingController();
  final AuthService _authService = AuthService(); 

  String? errorMessage;

  void disposeControllers() {
    emailController.dispose();
  }

  //!------------input validation -------------!
  bool areFieldsFilled(List<TextEditingController> controllers) {
    for (final controller in controllers) {
      if (controller.text.trim().isEmpty) {
        return false;
      }
    }
    return true;
  }

  bool validateLoginFields() {
    return areFieldsFilled([emailController]);
  }

  //!------------forgot password call -------------!
  Future<bool> sendForgotPasswordEmail() async {
    try {
      final response = await _authService.forgotPassword(emailController.text.trim());

      debugPrint("Forgot password response: $response");

      if (response['success'] == true) {
        errorMessage = null;
        return true; 
      } else {
        errorMessage = response['error'] ?? response['message'] ?? 'Request failed';
        return false;
      }
    } catch (e) {
      debugPrint("Forgot password exception: $e");
      errorMessage = 'Something went wrong. Please try again.';
      return false;
    }
  }
}