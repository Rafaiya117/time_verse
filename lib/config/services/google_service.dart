import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:time_verse/config/app_route/app_prefernce.dart';
import 'package:time_verse/config/services/user_session.dart';
import 'package:time_verse/features/auth/auth_service/auth_service.dart';

class GoogleServices {
  // Use instance for 7.x plugin
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  GoogleSignInAccount? _currentUser;
  final String serverClientId = '436776654983-l40ovblu1a15ou62j4l2i3ub9ju8us44.apps.googleusercontent.com';

  final List<String> scopes = [
    'email',
    'profile',
    'openid',
    'https://www.googleapis.com/auth/calendar',
    'https://www.googleapis.com/auth/calendar.events',
  ];

  /// Initialize Google Sign-In
  void init() {
    _googleSignIn.initialize(
      serverClientId: serverClientId,
    );
  }

  /// Sign in with Google
  Future<bool> signIn() async {
    try {
      final user = await _googleSignIn.authenticate();

      _currentUser = user;

      if (_currentUser != null) {
        UserSession().username = _currentUser!.displayName;
        UserSession().profileImageUrl = _currentUser!.photoUrl;
        debugPrint("✅ Google Name: ${_currentUser!.displayName}");
        debugPrint("✅ Google Photo: ${_currentUser!.photoUrl}");
      }

      final auth = await user.authorizationClient.authorizationForScopes(scopes);
      final accessToken = auth?.accessToken;
      print("ACCESS TOKEN: $accessToken");

      final idToken = (user.authentication).idToken;
      print("ID TOKEN: $idToken");

      if (idToken != null) {
        await sendTokensToApi(idToken);
      }

      return true;
    } catch (e) {
      print("Google Sign-In error: $e");
      return false;
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.disconnect();
    _currentUser = null;
    await AuthService().clearToken();
    await AppPrefs.setLoggedIn(false);
    print("Signed out");
  }

  /// ✅ FIXED: use authorizationHeaders instead of accessToken
  Future<void> addEvent({
    required String summary,
    required DateTime start,
    required DateTime end,
  }) async {
    if (_currentUser == null) {
      print("User not signed in");
      return;
    }

    // ✅ Google handles access token internally
    final headers = await _currentUser!.authorizationClient.authorizationHeaders(scopes);
    final url = Uri.parse(
      'https://www.googleapis.com/calendar/v3/calendars/primary/events',
    );

    final body = {
      "summary": summary,
      "start": {
        "dateTime": start.toIso8601String(),
        "timeZone": "UTC",
      },
      "end": {
        "dateTime": end.toIso8601String(),
        "timeZone": "UTC",
      },
    };

    final response = await http.post(
      url,
      headers: {
        ...?headers,
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      print("Event added successfully");
    } else {
      print("Failed to add event: ${response.body}");
    }
  }

  Future<void> sendTokensToApi(String idToken) async {
    try {
      final dio = Dio();
      final baseurl = dotenv.env['BASE_URL'];
      final String url = '$baseurl/api/v1/auth/login/idtoken/';

      final response = await dio.post(
        url,
        data: {'id_token': idToken},
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode == 200) {
        final data = response.data;

        final accessToken = data['access_token'];
        if (accessToken != null) {
          await AuthService().saveToken(accessToken);
          await AppPrefs.setLoggedIn(true);
        }

        debugPrint('✅ Google login successful $response');
      } else {
        debugPrint('⚠️ Unexpected status code: ${response.statusCode}');
      }
    } on DioException catch (e) {
      debugPrint('❌ Error sending tokens: ${e.response?.data ?? e.message}');
    }
  }
}
