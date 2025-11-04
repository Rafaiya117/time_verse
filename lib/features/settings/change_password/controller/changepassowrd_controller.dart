import 'package:flutter/material.dart';
import 'package:time_verse/features/auth/auth_service/auth_service.dart';

class ChangepassowrdController extends ChangeNotifier {
  final AuthService _authService = AuthService();

  TextEditingController old_passwordController = TextEditingController();
  TextEditingController new_passwordController = TextEditingController();
  TextEditingController confirm_passwordController = TextEditingController();

  bool _isLoading = false;
  String? _message;

  bool get isLoading => _isLoading;
  String? get message => _message;

  Future<void> changePassword(BuildContext context) async {
    final oldPass = old_passwordController.text.trim();
    final newPass = new_passwordController.text.trim();
    final confirmPass = confirm_passwordController.text.trim();

    if (oldPass.isEmpty || newPass.isEmpty || confirmPass.isEmpty) {
      _message = "All fields are required";
      notifyListeners();
      return;
    }

    if (newPass != confirmPass) {
      _message = "Passwords do not match";
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final result = await _authService.changePassword(oldPass, newPass);

      _message = result['message'];
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_message ?? "Password changed successfully")),
      );
    } catch (e) {
      _message = "Something went wrong";
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_message!)),
      );
    }

    _isLoading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    old_passwordController.dispose();
    new_passwordController.dispose();
    confirm_passwordController.dispose();
    super.dispose();
  }
}
