import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:time_verse/config/app_route/app_prefernce.dart';
import 'package:time_verse/features/auth/auth_model/auth_model.dart';

class AuthService {
  late final Dio _dio;
  final String _baseUrl = dotenv.env['BASE_URL'] ?? '';
  late final String? _token;

  AuthService() {
    _dio = Dio(BaseOptions(
      baseUrl: _baseUrl,
      headers: {'Content-Type': 'application/json'},
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ));
  }

  // ---------------- TOKEN HANDLING ---------------- //
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', token);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  // Future<void> clearToken() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.remove('access_token');
  // }

Future<void> clearToken() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('access_token');
  
  _token = null; 
}


// ---------------- USER INFO ---------------- //

  Future<int?> getUserId() async {
    final token = await getToken();
    if (token == null || token.isEmpty) return null;

    final decodedToken = JwtDecoder.decode(token);

    // adjust key if backend uses a different name
    return decodedToken['user_id'] ?? decodedToken['id'];
  }


  Future<Options> _authorizedHeader() async {
    final token = await getToken();
    return Options(
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
  }

  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  // ---------------- AUTH REQUESTS ---------------- //

  Future<Map<String, dynamic>> login(String email, String password) async {
  try {
    final response = await _dio.post(
      'api/v1/login/',
      data: jsonEncode({'email': email, 'password': password}),
    );

    final data = response.data is String ? jsonDecode(response.data) : response.data;
    final normalizedData = data['data'] != null
      ? data
       : {'data': {'access': data['access'], 'refresh': data['refresh'], 'user': null}};

  if (response.statusCode == 200 && normalizedData['data']?['access'] != null) {
    final token = normalizedData['data']['access'];
    debugPrint('!=========Access Token: $token');
    await saveToken(token);
    await AppPrefs.setLoggedIn(true);
    
  final user = normalizedData['data']['user'] != null
    ? User.fromJson(normalizedData['data']['user'])
    : null;

  return {
    'success': true,
    'data': {
      'token': token,
      'refresh': normalizedData['data']['refresh'],
      'user': user,
    },
  };
}

final errorMessage = normalizedData['detail'] ?? normalizedData['message'] ?? 'Login failed';
return {
  'success': false,
  'error': errorMessage,
};
  } on DioException catch (e) {
    return {'success': false, 'error': _handleError(e)};
  }
}

Future<Map<String, dynamic>> signup(String email, String password, String name, {String? profileImagePath}) async {
  try {
    final Map<String, dynamic> payload = {
      'email': email,
      'password': password,
      'name': name,
    };

    // optional profile image
    if (profileImagePath != null) {
      payload['profile_image'] = profileImagePath;
    }

    final response = await _dio.post(
      'api/v1/register/',
      data: jsonEncode(payload),
    );

    final data = response.data is String ? jsonDecode(response.data) : response.data;

    final userData = data['data']?['user'];
    final user = userData != null ? User.fromJson(userData) : null;

    // treat message containing "success" as successful
    final bool success = data['success'] ?? (data['message']?.toLowerCase().contains('success') ?? false);

    return {
      'success': success,
      'message': data['message'] ?? 'Signup successful',
      'data': {
        'user': user,
        'access': data['data']?['access'],
        'refresh': data['data']?['refresh'],
      },
    };
  } on DioException catch (e) {
    return {
      'success': false,
      'error': _handleError(e),
    };
  }
}

// Future<Map<String, dynamic>> forgotPassword(String email) async {
//     try {
//       final response = await _dio.post(
//         'api/v1/forget_password/',
//         options: await _authorizedHeader(),
//         data: jsonEncode({'email': email}),
//       );

//       final data = response.data is String ? jsonDecode(response.data) : response.data;

//       final userData = data['data']?['user'];
//       final user = userData != null ? User.fromJson(userData) : null;

//       return {
//         'success': response.statusCode == 200,
//         'message': data['message'] ?? 'Password reset initiated',
//         'data': {'user': user},
//       };
//     } on DioException catch (e) {
//       return {'success': false, 'error': _handleError(e)};
//     }
//   }

Future<Map<String, dynamic>> forgotPassword(String email) async {
  try {
    final response = await _dio.post(
      'api/v1/forget_password/',
      options: Options(headers: {'Content-Type': 'application/json'}), // 🔹 No token needed
      data: jsonEncode({'email': email}),
    );

    final data = response.data is String ? jsonDecode(response.data) : response.data;

    final userData = data['data']?['user'];
    final user = userData != null ? User.fromJson(userData) : null;

    return {
      'success': response.statusCode == 200,
      'message': data['message'] ?? 'Password reset initiated',
      'data': {'user': user},
    };
  } on DioException catch (e) {
    return {'success': false, 'error': _handleError(e)};
  }
}


  // Future<Map<String, dynamic>> verifyOtp(String email, String otp) async {
  //   try {
  //     final response = await _dio.post(
  //       'api/v1/verify-otp/',
  //       options: await _authorizedHeader(),
  //       data: jsonEncode({'email': email, 'otp': otp}),
  //     );
  //     final data = response.data is String ? jsonDecode(response.data) : response.data;
  //     final userData = data['data']?['user'];
  //     final user = userData != null ? User.fromJson(userData) : null;

  //     return {
  //       'success': response.statusCode == 200,
  //       'message': data['message'] ?? 'OTP verified',
  //       'data': {'user': user},
  //     };
  //   } on DioException catch (e) {
  //     return {'success': false, 'error': _handleError(e)};
  //   }
  // }
  Future<Map<String, dynamic>> verifyOtp(String email, String otp) async {
  try {
    final response = await _dio.post(
      'api/v1/verify-otp/',
      options: Options(headers: {'Content-Type': 'application/json'}), 
      data: jsonEncode({'email': email, 'otp': otp}),
    );

    final data = response.data is String ? jsonDecode(response.data) : response.data;
    final userData = data['data']?['user'];
    final user = userData != null ? User.fromJson(userData) : null;

    return {
      'success': response.statusCode == 200,
      'message': data['message'] ?? 'OTP verified',
      'data': {'user': user},
    };
  } on DioException catch (e) {
    return {'success': false, 'error': _handleError(e)};
  }
}


  Future<Map<String, dynamic>> resetPassword(String email,String otp,String newPassword,) async {
  try {
    final response = await _dio.post(
      'api/v1/reset-password/',
      options: Options(headers: {'Content-Type': 'application/json'}), // 🔹 No token needed
      data: jsonEncode({
        'email': email,
        'otp': otp,
        'new_password': newPassword,
      }),
    );

    final data = response.data is String ? jsonDecode(response.data) : response.data;

    final userData = data['data']?['user'];
    final user = userData != null ? User.fromJson(userData) : null;

    return {
      'success': response.statusCode == 200 || data['message']?.toString().toLowerCase().contains('success') == true,
      'message': data['message'] ?? 'Password reset successful',
      'data': {'user': user},
    };
  } on DioException catch (e) {
    return {'success': false, 'error': _handleError(e)};
  }
}

  
  Future<Map<String, dynamic>> changePassword(String oldPassword, String newPassword) async {
  try {
    print('🔐 Sending password change request...');
    print('➡️ old: $oldPassword | new: $newPassword');

    final response = await _dio.post(
      '/api/v1/change-password/',
      options: await _authorizedHeader(),
      data: jsonEncode({
        'old_password': oldPassword,
        'new_password': newPassword,
      }),
    );

    print('✅ Response: ${response.statusCode}');
    print('📦 Data: ${response.data}');

    final data = response.data is String ? jsonDecode(response.data) : response.data;
    final userData = data['data']?['user'];
    final user = userData != null ? User.fromJson(userData) : null;

    return {
      'success': response.statusCode == 200,
      'message': data['message'] ?? 'Password changed successfully',
      'data': {'user': user},
    };
  } on DioException catch (e) {
    print('❌ Dio Error: ${e.message}');
    print('📡 Response data: ${e.response?.data}');
    return {'success': false, 'error': _handleError(e)};
  } catch (e, stack) {
    print('💥 General Error: $e');
    print(stack);
    return {'success': false, 'error': e.toString()};
  }
}


// ---------------- ERROR HANDLER ---------------- //
  // String _handleError(DioException e) {
  // debugPrint("DioException response: ${e.response?.data}");

  // if (e.response != null && e.response!.data != null) {
  //   final data = e.response!.data;

  //   if (data is Map<String, dynamic>) {
  //     return data['detail'] ?? data['message'] ?? 'Request failed';
  //   } else if (data is String) {
  //     try {
  //       final decoded = jsonDecode(data);
  //       return decoded['detail'] ?? decoded['message'] ?? 'Request failed';
  //     } catch (_) {
  //       return data; 
  //     }
  //   }
  // }

  // if (e.type == DioExceptionType.connectionTimeout ||
  //     e.type == DioExceptionType.receiveTimeout) {
  //   return 'Connection timeout. Try again.';
  // }
  //   return e.message ?? 'Something went wrong. Please try later.';
  // }
  String _handleError(DioException e) {
  debugPrint("DioException response: ${e.response?.data}");

  if (e.response != null && e.response!.data != null) {
    final data = e.response!.data;

    if (data is Map<String, dynamic>) {
      final detail = data['detail'];
      final message = data['message'];
      final error = data['error'];

      if (detail != null) return detail.toString();
      if (message != null) return message.toString();
      if (error != null) return error.toString();
      for (var value in data.values) {
        if (value is List && value.isNotEmpty) {
          return value.first.toString();
        } else if (value is String) {
          return value;
        }
      }
      return 'Request failed';
    }
    else if (data is String) {
      try {
        final decoded = jsonDecode(data);
        if (decoded is Map<String, dynamic>) {
          final detail = decoded['detail'] ?? decoded['message'] ?? decoded['error'];
          if (detail != null) return detail.toString();
          for (var value in decoded.values) {
            if (value is List && value.isNotEmpty) {
              return value.first.toString();
            } else if (value is String) {
              return value;
            }
          }
        }
      } catch (_) {
        return data;
      }
    }
  }
  if (e.type == DioExceptionType.connectionTimeout ||
      e.type == DioExceptionType.receiveTimeout) {
    return 'Connection timeout. Try again.';
  }
  if (e.type == DioExceptionType.badResponse &&
      e.response?.statusCode == 401) {
    return 'Unauthorized. Please log in again.';
  }
  return e.message ?? 'Something went wrong. Please try later.';
}

}