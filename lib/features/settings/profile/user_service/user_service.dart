import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:time_verse/features/auth/auth_model/auth_model.dart';
import 'package:time_verse/features/auth/auth_service/auth_service.dart';

class UserService {
  Dio _dio = Dio();
  final AuthService _authService = AuthService(); 
  final String _baseUrl = dotenv.env['BASE_URL'] ?? '';

  // Add a private cached user
  User? _currentUser;

  // Expose it publicly
  User? get currentUser => _currentUser;

  UserService(){
     _dio = Dio(BaseOptions(
      baseUrl: _baseUrl,
      headers: {'Content-Type': 'application/json'},
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ));
  }

  Future<User?> getUserProfile() async {
    try {
      final response = await _dio.get(
        'api/v1/profile/',
        options: await _authorizedHeader(),
      );

      // Parse JSON
      final data = response.data is String ? jsonDecode(response.data) : response.data;

      if (response.statusCode == 200 && data != null) {
        _currentUser = User.fromJson(data);
        debugPrint("✅ User loaded: ${_currentUser!.name}");
        return _currentUser;
      } else {
        debugPrint("❌ Failed to load user data: ${data['message'] ?? 'Unknown error'}");
        return null;
      }
    } on DioException catch (e) {
      debugPrint("❌ Dio error while fetching user: ${e.response?.data ?? e.message}");
      return null;
    } catch (e) {
      debugPrint("❌ Exception while fetching user: $e");
      return null;
    }
  }

  Future<User?> updateUserProfile(User user, {File? profileImage}) async {
  try {
    dynamic payload;
    if (profileImage != null) {
      payload = FormData.fromMap({
        'id': user.id,
        'name': user.name,
        'birth_date': user.birthDate,
        'password': user.password,
        'profile_picture': await MultipartFile.fromFile(
          profileImage.path,
          filename: profileImage.path.split('/').last,
        ),
      });
    } else {
      // Otherwise send normal JSON
      payload = jsonEncode(user.toJson());
    }

    final response = await _dio.put(
      'api/v1/profile/',
      options: await _authorizedHeader(),
      data: payload,
    );

    final data = response.data is String ? jsonDecode(response.data) : response.data;

    if (response.statusCode == 200 && data != null) {
      final user = User.fromJson(data);
        _currentUser = user;
      debugPrint("✅ User updated successfully: ${user.name}");
      return user;
    } else {
      debugPrint("❌ Failed to update user: ${data['message'] ?? 'Unknown error'}");
      return null;
    }
  } on DioException catch (e) {
    debugPrint("❌ Dio error while updating user: ${e.response?.data ?? e.message}");
    return null;
  } catch (e) {
    debugPrint("❌ Exception while updating user: $e");
    return null;
  }
}

  //!---------- Helper ------------!
    Future<Options> _authorizedHeader() async {
    final token = await _authService.getToken();
    return Options(
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
  }
}