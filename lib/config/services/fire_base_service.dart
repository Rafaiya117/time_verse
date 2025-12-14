import 'package:firebase_messaging/firebase_messaging.dart';

// class FCMService {
//   static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
//   static String? _token;

//   static Future<void> initialize() async {
//     await _messaging.requestPermission();
//     try {
//       _token = await _messaging.getToken();
//       print('!------------------FCM Token--------------: $_token'); 
//     } catch (e) {
//       print('❌ Error getting FCM token: $e');
//     }
//     _messaging.onTokenRefresh.listen((newToken) {
//       _token = newToken;
//       print('🔄 FCM Token refreshed: $newToken');
//     });
//   }

//   static String? get token => _token;
// }

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:time_verse/features/auth/auth_service/auth_service.dart';


class FCMService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static String? _token;

  /// Initialize FCM
  static Future<void> initialize() async {
    await _messaging.requestPermission();

    try {
      _token = await _messaging.getToken();
      print('!------------------FCM Token--------------: $_token');

      // Automatically post to backend if token is available
      if (_token != null) {
        await postTokenToBackend(_token!);
      }
    } catch (e) {
      print('❌ Error getting FCM token: $e');
    }

    _messaging.onTokenRefresh.listen((newToken) async {
      _token = newToken;
      print('🔄 FCM Token refreshed: $newToken');

      await postTokenToBackend(newToken);
    });
  }

  static String? get token => _token;

  /// --------------------------
  /// Post FCM token to backend
  /// --------------------------
  static Future<void> postTokenToBackend(String token) async {
    try {
      final dio = Dio();
      final baseUrl = dotenv.env['BASE_URL'] ?? '';
      final url = '${baseUrl}api/v1/update-fcm-token/';

      // Get your authorization token
      final authToken = await AuthService().getToken();

      final response = await dio.post(
        url,
        data: {'fcm_token': token},
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $authToken',
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('✅ FCM token sent to backend successfully');
      } else {
        print('❌ Failed to send FCM token: ${response.statusCode}');
      }
    } catch (e) {
      print('⚠️ Error posting FCM token: $e');
    }
  }
}
