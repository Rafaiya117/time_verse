import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:time_verse/config/app_route/app_prefernce.dart';
import 'package:time_verse/config/services/user_session.dart';
import 'package:time_verse/features/auth/auth_service/auth_service.dart';

class GoogleServices {
  // Use instance for 7.x plugin
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  GoogleSignInAccount? _currentUser;//266848129575-j21g213vsnsai5k8jneg66j93nvua5vn.apps.googleusercontent.com
  final String serverClientId = '468767271373-igakn4plmbu2io7ocqph0miemm38lumq.apps.googleusercontent.com';
  String? _accessToken;
  String? get accessToken => _accessToken;

  final List<String> scopes = [
    'email',
    'profile',
    'openid',
    'https://www.googleapis.com/auth/calendar',
    'https://www.googleapis.com/auth/calendar.events',
  ];

  void init() {
    _googleSignIn.initialize(serverClientId: serverClientId);
  }

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
      _accessToken = accessToken;
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
    _accessToken = null; // ✅ clear token

    await AuthService().clearToken();
    await AppPrefs.setLoggedIn(false);
    await AppPrefs.setGoogleLogin(false);
    await AppPrefs.clearGoogleToken();
    print("Signed out");
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
          await AppPrefs.setGoogleLogin(true);
          await AppPrefs.saveGoogleToken(accessToken);

          // ✅ Save user info in UserSession
          UserSession().username = data['name'] ?? UserSession().username;
          UserSession().profileImageUrl = data['picture'] ?? UserSession().profileImageUrl;
        }

        debugPrint('✅ Google login successful $response');
      } else {
        debugPrint('⚠️ Unexpected status code: ${response.statusCode}');
      }
    } on DioException catch (e) {
      debugPrint('❌ Error sending tokens: ${e.response?.data ?? e.message}');
    }
  }

  Future<void> createGoogleCalendarEvent({
    required String accessToken,
    required String title,
    required String date,
    required String startTime,
    required String endTime,
    String? description,
    String? location,
  }) async {
    final dio = Dio();

    final startDateTime = "${date}T$startTime:00";
    final endDateTime = "${date}T$endTime:00";

    final body = {
      "summary": title,
      "description": description ?? "",
      "location": location ?? "",
      "start": {"dateTime": startDateTime, "timeZone": "Asia/Dhaka"},
      "end": {"dateTime": endDateTime, "timeZone": "Asia/Dhaka"},
    };

    try {
      final response = await dio.post(
        "https://www.googleapis.com/calendar/v3/calendars/primary/events",
        data: body,
        options: Options(
          headers: {
            "Authorization": "Bearer $accessToken",
            "Content-Type": "application/json",
          },
        ),
      );

      if (response.statusCode == 200) {
        debugPrint("✅ Event added to Google Calendar");
      } else {
        debugPrint("⚠️ Google Calendar error: ${response.data}");
      }
    } catch (e) {
      debugPrint("❌ Google Calendar Exception: $e");
    }
  }
}
