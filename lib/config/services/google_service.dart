import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:time_verse/config/app_route/app_prefernce.dart';
import 'package:time_verse/config/services/user_session.dart';
import 'package:time_verse/features/auth/auth_service/auth_service.dart';

class GoogleServices {
  static final GoogleServices _instance = GoogleServices._internal();
  factory GoogleServices() => _instance;
  GoogleServices._internal();

  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  GoogleSignInAccount? _currentUser; //266848129575-j21g213vsnsai5k8jneg66j93nvua5vn.apps.googleusercontent.com
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

  // Ensures an access token is always retrieved reliably
  Future<String?> getValidAccessToken() async {
    if (_accessToken != null && _accessToken!.isNotEmpty) {
      return _accessToken;
    }
    try {
      final user = await _googleSignIn.authenticate();
      final auth = await user.authorizationClient.authorizeScopes(scopes);
      _accessToken = auth.accessToken;
      return _accessToken;
    } catch (e) {
      debugPrint("❌ Error retrieving access token: $e");
      return null;
    }
  }

  Future<bool> signIn() async {
    try {
      if (_accessToken != null) {
        debugPrint("🔵 Reusing existing Access Token: $_accessToken");
        return true;
      }

      final user = await _googleSignIn.authenticate();
      _currentUser = user;

      if (_currentUser != null) {
        final authentication = _currentUser!.authentication;
        final idToken = authentication.idToken;
        debugPrint("🆔 ID TOKEN: $idToken");

        final auth = await _currentUser!.authorizationClient.authorizeScopes(scopes);
        _accessToken = auth.accessToken;
        debugPrint("🔑 ACCESS TOKEN: $_accessToken");

        final serverAuth = await _currentUser!.authorizationClient.authorizeServer(scopes);
        final String? serverAuthCode = serverAuth?.serverAuthCode;
        debugPrint("🎟️ AUTH CODE: $serverAuthCode");

        UserSession().username = _currentUser!.displayName;
        UserSession().profileImageUrl = _currentUser!.photoUrl;

        await AppPrefs.saveGoogleUser(
          _currentUser!.displayName ?? '',
          _currentUser!.email,
          photoUrl: _currentUser!.photoUrl,
        );

        if (idToken != null && serverAuthCode != null) {
          await sendTokensToApi(
            idToken: idToken,
            serverAuthCode: serverAuthCode,
          );
        }

        debugPrint("✅ Google Sign-In Success for: ${_currentUser!.displayName}");
        return true;
      }
      return false;
    } catch (e) {
      final errorStr = e.toString().toLowerCase();
      if (errorStr.contains('cancelled by user') || errorStr.contains('16:')) {
        debugPrint("ℹ️ Google Sign-In was canceled by the user.");
        return false;
      }

      debugPrint("❌ Google Sign-In error: $e");
      return false;
    }
  }

  Future<void> sendTokensToApi({required String idToken, required String serverAuthCode}) async {
    try {
      final dio = Dio();
      final baseurl = dotenv.env['BASE_URL'];
      final String url = '${baseurl}api/v1/auth/login/idtoken/';

      final response = await dio.post(
        url,
        data: {
          'id_token': idToken,
          'auth_code': serverAuthCode,
        },
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode == 200) {
        final data = response.data;

        final backendAccessToken = data['access_token'];
        if (backendAccessToken != null) {
          await AuthService().saveToken(backendAccessToken);
          await AppPrefs.setLoggedIn(true);
          await AppPrefs.setGoogleLogin(true);
          await AppPrefs.saveGoogleToken(backendAccessToken);

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

  // Future<void> createGoogleCalendarEvent({
  //   required String accessToken,
  //   required String title,
  //   required String date,
  //   required String startTime,
  //   required String endTime,
  //   String? description,
  //   String? location,
  //   String? alarmTimeISO,
  // }) async {
  //   final dio = Dio();

  //   final startDateTime = "${date}T$startTime";
  //   final endDateTime = "${date}T$endTime";

  //   final body = {
  //     "summary": title,
  //     "description": description ?? "",
  //     "location": location ?? "",
  //     "start": {"dateTime": startDateTime, "timeZone": "Asia/Dhaka"},
  //     "end": {"dateTime": endDateTime, "timeZone": "Asia/Dhaka"},
  //     "reminders": {
  //       "useDefault": false,
  //       "overrides": [
  //         {"method": "popup", "minutes": 15}
  //       ],
  //     },
  //   };

  //   try {
  //     final response = await dio.post(
  //       "https://www.googleapis.com/calendar/v3/calendars/primary/events",
  //       data: body,
  //       options: Options(
  //         headers: {
  //           "Authorization": "Bearer $accessToken",
  //           "Content-Type": "application/json",
  //         },
  //       ),
  //     );

  //     if (response.statusCode == 200) {
  //       debugPrint("✅ Event added to Google Calendar");
  //     } else {
  //       debugPrint("⚠️ Google Calendar error: ${response.data}");
  //     }
  //   } catch (e) {
  //     debugPrint("❌ Google Calendar Exception: $e");
  //   }
  // }
  Future<void> createGoogleCalendarEvent({
    required String accessToken,
    required String title,
    required String date,
    required String startTime,
    required String endTime,
    String? description,
    String? location,
    String? alarmTimeISO,
  }) async {
    final dio = Dio();

    // Ensure start and end times include seconds for valid ISO 8601 formatting
    final cleanStart = startTime.split(':').length == 2 ? "$startTime:00" : startTime;
    final cleanEnd = endTime.split(':').length == 2 ? "$endTime:00" : endTime;

    final startDateTime = "${date}T$cleanStart";
    final endDateTime = "${date}T$cleanEnd";

    final body = {
      "summary": title,
      "description": description ?? "",
      "location": location ?? "",
      "start": {"dateTime": startDateTime, "timeZone": "Asia/Dhaka"},
      "end": {"dateTime": endDateTime, "timeZone": "Asia/Dhaka"},
      "reminders": {
        "useDefault": false,
        "overrides": [
          {"method": "popup", "minutes": 15}
        ],
      },
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

      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint("✅ Event added to Google Calendar");
      } else {
        debugPrint("⚠️ Google Calendar error: ${response.data}");
      }
    } catch (e) {
      debugPrint("❌ Google Calendar Exception: $e");
    }
  }
  
  Future<List<Map<String, dynamic>>> getGoogleCalendarEvents({
    required String accessToken,
    DateTime? timeMin,
    DateTime? timeMax,
  }) async {
    final dio = Dio();
    final startStr = (timeMin ?? DateTime.now()).toUtc().toIso8601String();

    Map<String, dynamic> queryParameters = {
      'timeMin': startStr,
      'singleEvents': true,
      'orderBy': 'startTime',
      'showDeleted': false,
    };

    if (timeMax != null) {
      queryParameters['timeMax'] = timeMax.toUtc().toIso8601String();
    }

    try {
      final response = await dio.get(
        "https://www.googleapis.com/calendar/v3/calendars/primary/events",
        queryParameters: queryParameters,
        options: Options(
          headers: {
            "Authorization": "Bearer $accessToken",
            "Content-Type": "application/json",
          },
        ),
      );

      if (response.statusCode == 200) {
        final List items = response.data['items'] ?? [];
        final activeItems = items.where((event) => event['status'] != 'cancelled').toList();
        return activeItems.map((event) {
          final startRaw = event['start']?['dateTime'] ?? event['start']?['date'] ?? '';
          final endRaw = event['end']?['dateTime'] ?? event['end']?['date'] ?? '';
          
          DateTime? startDt = DateTime.tryParse(startRaw)?.toLocal();
          String alarmISO = '';

          if (startDt != null) {
            alarmISO = startDt.subtract(const Duration(minutes: 15)).toIso8601String();
          }
          final int eventId = event['id'].toString().hashCode.abs() % 1000000;
          return {
            'id': eventId,
            'google_id': event['id'],
            'title': event['summary'] ?? 'No Title',
            'description': event['description'] ?? '',
            'location': event['location'] ?? '',
            'startTime': startRaw,
            'endTime': endRaw,
            'date': startDt != null
                ? "${startDt.year}-${startDt.month.toString().padLeft(2, '0')}-${startDt.day.toString().padLeft(2, '0')}"
                : '',
            'alarm_time': alarmISO,
          };
        }).toList();
      }
      return [];
    } catch (e) {
      debugPrint("❌ Google Calendar Fetch Exception: $e");
      return [];
    }
  }

  Future<bool> deleteGoogleCalendarEvent({
    required String accessToken,
    required String eventId,
  }) async {
    final dio = Dio();
    try {
      final response = await dio.delete(
        "https://www.googleapis.com/calendar/v3/calendars/primary/events/$eventId",
        options: Options(
          headers: {
            "Authorization": "Bearer $accessToken",
            "Content-Type": "application/json",
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        debugPrint("✅ Event deleted from Google Calendar");
        return true;
      } else {
        debugPrint("⚠️ Google Calendar delete error: ${response.data}");
        return false;
      }
    } catch (e) {
      debugPrint("❌ Google Calendar Delete Exception: $e");
      return false;
    }
  }
}