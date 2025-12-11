import 'package:firebase_messaging/firebase_messaging.dart';

class FCMService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static String? _token;

  static Future<void> initialize() async {
    await _messaging.requestPermission();
    try {
      _token = await _messaging.getToken();
      print('!------------------FCM Token--------------: $_token'); 
    } catch (e) {
      print('❌ Error getting FCM token: $e');
    }
    _messaging.onTokenRefresh.listen((newToken) {
      _token = newToken;
      print('🔄 FCM Token refreshed: $newToken');
    });
  }

  static String? get token => _token;
}