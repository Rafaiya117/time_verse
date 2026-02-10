import 'package:flutter/material.dart';
import 'package:time_verse/config/app_route/app_prefernce.dart';
import 'package:time_verse/features/auth/auth_service/auth_service.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginController extends ChangeNotifier{
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

   final AuthService _authService = AuthService();
   String? loginError; 

  void disposeControllers() {
    emailController.dispose();
    passwordController.dispose();
  }

  bool rememberMe = false;

  void toggleRememberMe(bool? value) {
    rememberMe = value ?? false;
    notifyListeners();
  }

   bool areFieldsFilled(List<TextEditingController> controllers) {
    for (var controller in controllers) {
      if (controller.text.trim().isEmpty) {
        return false;
      }
    }
    return true;
  }

  bool validateLoginFields() {
    return areFieldsFilled([emailController, passwordController]);
  }

//!------------Log in --------!
  Future<bool> loginUser() async {
    try {
      final response = await _authService.login(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      if (response['success'] == true) {
        loginError = null; 
        return true;
      } else {
        loginError = response['error'] ?? 'Login failed';
        return false;
      }
    } catch (e) {
      debugPrint("Login error: $e");
      loginError = 'Something went wrong. Please try again.';
      return false;
    }
  }
  //!---Remember me -----!
  Future<void> loadRememberedUser() async {
  final data = await AppPrefs.getRememberedUser();
  if (data['remember'] == true) {
    emailController.text = data['email'] ?? '';
    passwordController.text = data['password'] ?? '';
    rememberMe = true;
  }
    notifyListeners();
  }

  // Future<void> startGoogleLogin() async {
  //   final url = Uri.parse("http://10.10.13.74:5000/google_auth/google/login");

  //   try {
  //     // Open in external browser
  //     if (!await launchUrl(
  //       url,
  //       mode: LaunchMode.externalApplication,
  //     )) {
  //       print("Could not launch login url");
  //     }
  //   } catch (e) {
  //     print("Error launching login url: $e");
  //   }
  // }
}