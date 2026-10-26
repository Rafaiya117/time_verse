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
    _googleSignIn.initialize(
      serverClientId: serverClientId,
    );
  }

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

  Future<bool> signIn() async {
    try {
      await signOut();

      final user = await _googleSignIn.authenticate();
      _currentUser = user;

      if (_currentUser != null) {
        final authentication = await _currentUser!.authentication;
        final idToken = authentication.idToken;

        final auth = await _currentUser!.authorizationClient.authorizeScopes(scopes);
        _accessToken = auth.accessToken;

        final serverAuth = await _currentUser!.authorizationClient.authorizeServer(scopes);
        final String? serverAuthCode = serverAuth?.serverAuthCode;

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
        debugPrint('⚠ Unexpected status code: ${response.statusCode}');
      }
    } on DioException catch (e) {
      debugPrint('❌ Error sending tokens: ${e.response?.data ?? e.message}');
    }
  }

  String? _buildGoogleRRule(String? repeat, Map<String, dynamic>? customRepeat) {
    if (repeat == null || repeat.isEmpty || repeat == "Don't repeat") return null;

    final rule = repeat.toLowerCase().trim();

    // if (rule == 'every 1 day' || rule == '1 day') return 'RRULE:FREQ=DAILY';
    // if (rule == 'every 1 week' || rule == '1 week') return 'RRULE:FREQ=WEEKLY';
    // if (rule == 'every 1 month' || rule == '1 month') return 'RRULE:FREQ=MONTHLY';
    // if (rule == 'every 1 year' || rule == '1 year') return 'RRULE:FREQ=YEARLY';
     if (rule == 'every 1 day' || rule == '1 day') return 'RRULE:FREQ=DAILY;COUNT=7';     // Stops after 7 days
  if (rule == 'every 1 week' || rule == '1 week') return 'RRULE:FREQ=WEEKLY;COUNT=4';   // Stops after 4 weeks
  if (rule == 'every 1 month' || rule == '1 month') return 'RRULE:FREQ=MONTHLY;COUNT=12'; // Stops after 12 months
  if (rule == 'every 1 year' || rule == '1 year') return 'RRULE:FREQ=YEARLY;COUNT=5';   // Stops after 5 years

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
        final dayMap = {
          'S': 'SU', 'M': 'MO', 'T': 'TU', 'W': 'WE', 'TH': 'TH', 'F': 'FR', 'SAT': 'SA',
          '0': 'SU', '1': 'MO', '2': 'TU', '3': 'WE', '4': 'TH', '5': 'FR', '6': 'SA', '7': 'SU'
        };
        final mappedDays = days.map((d) => dayMap[d.toString().trim().toUpperCase()] ?? 'MO').join(',');
        rrule += ';BYDAY=$mappedDays';
      }

      if (customRepeat['ends'] == 'on' && customRepeat['end_date'] != null) {
        final rawEndDateStr = customRepeat['end_date'].toString();
        final parsed = DateTime.tryParse(rawEndDateStr);
        if (parsed != null) {
          // Format UNTIL strictly at end-of-day UTC (23:59:59Z) to cover local time boundaries
          final endOfDayUtc = DateTime.utc(parsed.year, parsed.month, parsed.day, 23, 59, 59);
          final formattedEnd = DateFormat("yyyyMMdd'T'HHmmss'Z'").format(endOfDayUtc);
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

    // 💡 1. Fetch dynamic IANA timezone directly from the device
    String userTimeZone = 'UTC';
    try {
      final tz = await FlutterTimezone.getLocalTimezone();
      if (tz.identifier.contains('/')) {
        userTimeZone = tz.identifier;
      } else {
        userTimeZone = DateTime.now().timeZoneName;
      }
    } catch (e) {
      debugPrint("⚠️ Could not fetch IANA timezone: $e");
      userTimeZone = DateTime.now().timeZoneName;
    }

    final parts = date.split('-');
    final int year = parts.length == 3 ? int.parse(parts[0]) : DateTime.now().year;
    final int month = parts.length == 3 ? int.parse(parts[1]) : DateTime.now().month;
    final int day = parts.length == 3 ? int.parse(parts[2]) : DateTime.now().day;

    final startParts = cleanStart.split(':').map(int.parse).toList();
    final endParts = cleanEnd.split(':').map(int.parse).toList();

    // 💡 2. FIXED: Use DateTime.utc to lock coordinates completely in place
    // This stops the system from adding or subtracting timezone hours automatically.
    final startDt = DateTime.utc(year, month, day, startParts[0], startParts[1]);
    var endDt = DateTime.utc(year, month, day, endParts[0], endParts[1]);

    if (endDt.isBefore(startDt) || endDt.isAtSameMomentAs(startDt)) {
      endDt = startDt.add(const Duration(minutes: 30));
    }

    // 💡 3. Format with a trailing 'Z' to explicitly indicate a locked UTC string payload
    final String startIso = "${DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(startDt)}Z";
    final String endIso = "${DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(endDt)}Z";

    final rrule = _buildGoogleRRule(repeat, customRepeat);

    final body = {
      "summary": title,
      "description": description ?? "",
      "location": location ?? "",
      "start": {
        "dateTime": startIso,       // e.g. "2026-10-28T21:00:00Z"
        "timeZone": userTimeZone,   // Tells Google exactly how to translate it to your local grid
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
        "https://googleapis.com",
        data: body,
        options: Options(
          headers: {
            "Authorization": "Bearer $accessToken",
            "Content-Type": "application/json",
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint("✅ Google Calendar recurring event locked perfectly!");
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

        final Set<String> seenGoogleIds = {};
        final List<Map<String, dynamic>> parsedEvents = [];

        for (var event in activeItems) {
          final String googleId = event['id'] ?? '';
          if (googleId.isNotEmpty && seenGoogleIds.contains(googleId)) {
            continue;
          }
          seenGoogleIds.add(googleId);

          final startRaw = event['start']?['dateTime'] ?? event['start']?['date'] ?? '';
          final endRaw = event['end']?['dateTime'] ?? event['end']?['date'] ?? '';

          final DateTime? startDt = DateTime.tryParse(startRaw)?.toLocal();
          final DateTime? endDt = DateTime.tryParse(endRaw)?.toLocal();

          if (startDt == null) continue;

          final int eventId = googleId.hashCode.abs() % 1000000;

          parsedEvents.add({
            'id': eventId,
            'google_id': googleId,
            'title': event['summary'] ?? 'No Title',
            'description': event['description'] ?? '',
            'location': event['location'] ?? '',
            'startTime': DateFormat('HH:mm').format(startDt),
            'endTime': endDt != null ? DateFormat('HH:mm').format(endDt) : '',
            'date': DateFormat('yyyy-MM-dd').format(startDt),
            'alarm_time': startDt.subtract(const Duration(minutes: 15)).toIso8601String(),
          });
        }

        return parsedEvents;
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