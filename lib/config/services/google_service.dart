import 'dart:convert';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

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
      serverClientId: '', 
    );
  }

  /// Sign in with Google
  Future<bool> signIn() async {
    try {
      final user = await _googleSignIn.authenticate();
      if (user == null) return false; // user cancelled
      _currentUser = user;

      final auth = await user.authorizationClient.authorizationForScopes(scopes);
      final accessToken = auth?.accessToken;
      print("ACCESS TOKEN: $accessToken");

      // Optional: get ID token if needed for backend
      final idToken = (await user.authentication)?.idToken;
      print("ID TOKEN: $idToken");

      return true;
    } catch (e) {
      print("Google Sign-In error: $e");
      return false;
    }
  }

  /// Sign out
  Future<void> signOut() async {
    await _googleSignIn.disconnect();
    _currentUser = null;
    print("Signed out");
  }

  /// Add an event to the user's primary Google Calendar
  Future<void> addEvent({
    required String summary,
    required DateTime start,
    required DateTime end,
  }) async {
    if (_currentUser == null) {
      print("User not signed in");
      return;
    }

    final auth =
        await _currentUser!.authorizationClient.authorizationForScopes(scopes);

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
}
