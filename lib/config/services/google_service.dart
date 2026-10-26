import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:time_verse/config/app_route/app_prefernce.dart';
import 'package:time_verse/config/services/user_session.dart';
import 'package:time_verse/features/auth/auth_service/auth_service.dart';




class GoogleServices {
  static final GoogleServices _instance = GoogleServices._internal();
  factory GoogleServices() => _instance;
  GoogleServices._internal();

  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  GoogleSignInAccount? _currentUser;
  final String serverClientId = 'xxxxxxxxxxxxxxxxxxxxxxxxxxxx';
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
    _googleSignIn.initialize(
      //serverClientId: serverClientId,
    );
  }

  /// Silent token retrieval that will NEVER trigger an unexpected UI popup
  Future<String?> getValidAccessToken() async {
    if (_accessToken != null && _accessToken!.isNotEmpty) {
      return _accessToken;
    }
    try {
      if (_currentUser != null) {
        final auth = await _currentUser!.authorizationClient.authorizeScopes(scopes);
        _accessToken = auth.accessToken;
        return _accessToken;
      }
      return null;
    } catch (e) {
      debugPrint("❌ Error retrieving access token: $e");
      return null;
    }
  }

  /// Explicit user-initiated Google Sign-In only

  Future<bool> signIn() async {
    try {
      // 1. Clear any stale cached session state before authenticating
      await signOut();

      // 2. Single interactive sign-in call
      final user = await _googleSignIn.authenticate();
      _currentUser = user;

      if (_currentUser != null) {
        // 3. Extract authentication tokens cleanly
        final authentication = await _currentUser!.authentication;
        final idToken = authentication.idToken;
        debugPrint("🆔 ID TOKEN: $idToken");

        // 4. Retrieve access token via authorizeScopes
        final auth = await _currentUser!.authorizationClient.authorizeScopes(scopes);
        _accessToken = auth.accessToken;
        debugPrint("🔑 ACCESS TOKEN: $_accessToken");

        // 5. Fetch server auth code cleanly
        final serverAuth = await _currentUser!.authorizationClient.authorizeServer(scopes);
        final String? serverAuthCode = serverAuth?.serverAuthCode;
        debugPrint("🎟 AUTH CODE: $serverAuthCode");

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
        await signOut();
        return false;
      }

      debugPrint("❌ Google Sign-In error: $e");
      await signOut();
      return false;
    }
  }

  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      _currentUser = null;
      _accessToken = null;
    } catch (e) {
      debugPrint("Error signing out Google: $e");
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
        debugPrint('⚠️️ Unexpected status code: ${response.statusCode}');
      }
    } on DioException catch (e) {
      debugPrint('❌ Error sending tokens: ${e.response?.data ?? e.message}');
    }
  }

  String? _buildGoogleRRule(String? repeat, Map<String, dynamic>? customRepeat) {
    if (repeat == null || repeat.isEmpty || repeat == "Don't repeat") return null;

    final rule = repeat.toLowerCase().trim();

    if (rule == 'every 1 day' || rule == '1 day') return 'RRULE:FREQ=DAILY';
    if (rule == 'every 1 week' || rule == '1 week') return 'RRULE:FREQ=WEEKLY';
    if (rule == 'every 1 month' || rule == '1 month') return 'RRULE:FREQ=MONTHLY';
    if (rule == 'every 1 year' || rule == '1 year') return 'RRULE:FREQ=YEARLY';

    if (rule == 'custom' && customRepeat != null) {
      final unit = customRepeat['repeat_unit']?.toString().toUpperCase() ?? 'WEEKLY';
      final interval = customRepeat['repeat_every'] ?? 1;
      String freq = 'WEEKLY';

      if (unit.contains('DAY')) freq = 'DAILY';
      else if (unit.contains('MONTH')) freq = 'MONTHLY';
      else if (unit.contains('YEAR')) freq = 'YEARLY';

      String rrule = 'RRULE:FREQ=$freq;INTERVAL=$interval';

      final days = customRepeat['repeat_days'] as List?;
      if (days != null && days.isNotEmpty) {
        final dayMap = {'S': 'SU', 'M': 'MO', 'T': 'TU', 'W': 'WE', 'F': 'FR'};
        final mappedDays = days.map((d) => dayMap[d] ?? 'MO').join(',');
        rrule += ';BYDAY=$mappedDays';
      }

      if (customRepeat['ends'] == 'on' && customRepeat['end_date'] != null) {
        final endDate = DateTime.tryParse(customRepeat['end_date'].toString());
        if (endDate != null) {
          final formattedEnd = DateFormat("yyyyMMdd'T'HHmmss'Z'").format(endDate.toUtc());
          rrule += ';UNTIL=$formattedEnd';
        }
      } else if (customRepeat['ends'] == 'after' && customRepeat['end_count'] != null) {
        rrule += ';COUNT=${customRepeat['end_count']}';
      }

      return rrule;
    }

    return null;
  }

  Future<void> createGoogleCalendarEvent({
    required String accessToken,
    required String title,
    required String date,
    required String startTime,
    required String endTime,
    String? description,
    String? location,
    String? alarmTimeISO,
    String? repeat,
    Map<String, dynamic>? customRepeat,
  }) async {
    final cleanStart = startTime.split(':').length == 2 ? "$startTime:00" : startTime;
    var cleanEnd = endTime.split(':').length == 2 ? "$endTime:00" : endTime;

    String userTimeZone = 'Asia/Dhaka';
    try {
      userTimeZone = (await FlutterTimezone.getLocalTimezone()).identifier;
    } catch (e) {
      debugPrint("⚠️ Could not fetch IANA timezone: $e");
    }

    final DateTime? parsedDate = DateTime.tryParse(date) ?? DateFormat('MMMM d, yyyy').tryParse(date);
    if (parsedDate == null) return;

    final startParts = cleanStart.split(':').map(int.parse).toList();
    final endParts = cleanEnd.split(':').map(int.parse).toList();

    final startDt = DateTime(parsedDate.year, parsedDate.month, parsedDate.day, startParts[0], startParts[1]);
    var endDt = DateTime(parsedDate.year, parsedDate.month, parsedDate.day, endParts[0], endParts[1]);

    if (endDt.isBefore(startDt) || endDt.isAtSameMomentAs(startDt)) {
      endDt = endDt.add(const Duration(days: 1));
    }

    final startIso = "${DateFormat('yyyy-MM-dd').format(startDt)}T$cleanStart";
    final endIso = "${DateFormat('yyyy-MM-dd').format(endDt)}T$cleanEnd";

    final rrule = _buildGoogleRRule(repeat, customRepeat);

    final body = {
      "summary": title,
      "description": description ?? "",
      "location": location ?? "",
      "start": {
        "dateTime": startIso,
        "timeZone": userTimeZone,
      },
      "end": {
        "dateTime": endIso,
        "timeZone": userTimeZone,
      },
      if (rrule != null) "recurrence": [rrule],
      "reminders": {
        "useDefault": false,
        "overrides": [
          {"method": "popup", "minutes": 15},
        ],
      },
    };

    try {
      final dio = Dio();
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
        debugPrint("✅ Event with recurrence successfully added to Google Calendar!");
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