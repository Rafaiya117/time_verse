import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:time_verse/features/auth/auth_service/auth_service.dart';


class TermsService {
  final Dio _dio = Dio();
  final AuthService _authService = AuthService();
  final String _baseUrl = dotenv.env['BASE_URL'] ?? '';

  TermsService() {
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

  Future<Map<String, dynamic>?> fetchTerms() async {
    try {
      final response = await _dio.get(
        'api/v1/terms-and-conditions/',
        options: await _authorizedHeader(),
      );

      final data = response.data is String ? jsonDecode(response.data) : response.data;

      if (response.statusCode == 200 && data != null) {
        debugPrint("✅ Terms fetched: ${data['title']}");
        return data;
      } else {
        debugPrint("❌ Failed to fetch terms: ${data['message'] ?? 'Unknown error'}");
        return null;
      }
    } on DioException catch (e) {
      debugPrint("❌ Dio error while fetching terms: ${e.response?.data ?? e.message}");
      return null;
    } catch (e) {
      debugPrint("❌ Exception while fetching terms: $e");
      return null;
    }
  }
}
