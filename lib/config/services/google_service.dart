import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:time_verse/features/auth/auth_service/auth_service.dart';

class GoogleServices {
  // Use instance for 7.x plugin
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  GoogleSignInAccount? _currentUser;

  // Scopes for Google Calendar API
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
      serverClientId: '266848129575-j21g213vsnsai5k8jneg66j93nvua5vn.apps.googleusercontent.com', 
    );
  }

  /// Sign in with Google
  Future<bool> signIn() async {
    try {
      final user = await _googleSignIn.authenticate();
      if (user == null) return false; 
      _currentUser = user;

      final auth = await user.authorizationClient.authorizationForScopes(scopes);
      final accessToken = auth?.accessToken;
      print("ACCESS TOKEN: $accessToken");

      final idToken = (await user.authentication)?.idToken;
      print("ID TOKEN: $idToken");


      if (accessToken != null && idToken != null) {
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
    print("Signed out");
  }

  Future<void> addEvent({
    required String summary,
    required DateTime start,
    required DateTime end,
  }) async {
    if (_currentUser == null) {
      print("User not signed in");
      return;
    }

    final auth = await _currentUser!.authorizationClient.authorizationForScopes(scopes);

    final accessToken = auth?.accessToken;
    if (accessToken == null) {
      print("Failed to get access token");
      return;
    }

    final url = Uri.parse('https://www.googleapis.com/calendar/v3/calendars/primary/events');

    final body = {
      "summary": summary,
      "start": {"dateTime": start.toIso8601String(), "timeZone": "UTC"},
      "end": {"dateTime": end.toIso8601String(), "timeZone": "UTC"},
    };

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $accessToken',
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
      String url = 'http://10.10.13.74:5002/api/v1/auth/login/idtoken/';
      final response = await dio.post(
        url,
        data: {'id_token': idToken},
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        print('✅ Tokens sent successfully: ${response.data}');
      } else {
        print('⚠️ Unexpected status code: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('❌ Error sending tokens: ${e.response?.data ?? e.message}');
    }
  }
}