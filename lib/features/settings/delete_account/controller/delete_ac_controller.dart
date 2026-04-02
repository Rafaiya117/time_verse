import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:time_verse/features/auth/auth_service/auth_service.dart';

class DeleteAcController extends ChangeNotifier{
  Future<bool> deleteAccount(String password) async {
  try {
    final token = await AuthService().getToken();
    final baseUrl = dotenv.env['BASE_URL'] ?? '';

    final response = await Dio().post(
      '${baseUrl}api/v1/delete-account/',
      data: {
        "password": password,
      },
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