import 'package:alarm/alarm.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:time_verse/config/app_route/app_prefernce.dart';
import 'package:time_verse/core/components/custom_dialogue.dart';
import 'package:time_verse/features/auth/auth_service/auth_service.dart';
import 'package:time_verse/features/home/controller/home_controller.dart';
import 'package:time_verse/features/settings/profile/controller/profile_controller.dart';

class DeleteAcController extends ChangeNotifier {
  Future<void> executeAccountDeletion({required BuildContext context,required String password,}) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    final success = await _deleteAccountApiCall(password);
    
    if (!context.mounted) return;
    Navigator.pop(context); 

    if (success) {
      await showMessageDialog(
        context,
        'Your account has been permanently deleted.',
        title: 'Success',
        icon: Icons.check_circle_outline,
        iconColor: Colors.green,
      );
      
      await Alarm.stopAll();
      await AppPrefs.setLoggedIn(false);
      await AuthService().clearToken();
      
      if (!context.mounted) return;
      context.read<HomeController>().todaysEvents.clear();
      context.read<ProfileController>().clearProfile();

      await Future.delayed(const Duration(milliseconds: 800));
      
      if (context.mounted) {
        Navigator.pop(context); // Close parent profile/settings interface context
        context.go('/login');
      }
    } else {
      await showMessageDialog(
        context,
        'Failed to delete account. Check password.',
        title: 'Error',
        icon: Icons.error_outline,
        iconColor: Colors.red,
      );
    }
  }

  // Private helper to isolate backend logic cleanly
  Future<bool> _deleteAccountApiCall(String password) async {
    try {
      final token = await AuthService().getToken();
      final baseUrl = dotenv.env['BASE_URL'] ?? '';

      final response = await Dio().post(
        '${baseUrl}api/v1/delete-account/',
        data: {"password": password},
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );
      return response.statusCode == 200;
    } catch (e) {
      debugPrint("❌ Delete account error: $e");
      return false;
    }
  }
}