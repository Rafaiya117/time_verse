import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:time_verse/features/auth/auth_service/auth_service.dart';

class PrivacyService {
  final Dio _dio = Dio();
  final AuthService _authService = AuthService();

   final String _baseUrl = dotenv.env['BASE_URL'] ?? '';

  PrivacyService() {
    _dio.options.baseUrl = _baseUrl;
    _dio.options.headers = {'Content-Type': 'application/json'};
    _dio.options.connectTimeout = const Duration(seconds: 10);
    _dio.options.receiveTimeout = const Duration(seconds: 10);
  }

  Future<Options> _authorizedHeader() async {
    final token = await _authService.getToken();
    return Options(
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
  }

  Future<Map<String, dynamic>> fetchPrivacyPolicy() async {
    try {
      final options = await _authorizedHeader();
      final response = await _dio.get(
        'api/v1/privacy-policy/',
        options: options,
      );
      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to load privacy policy');
      }
    } catch (e, stack) {
      print('❌ Privacy fetch error: $e');
      print(stack);
      rethrow;
    }
  }
}