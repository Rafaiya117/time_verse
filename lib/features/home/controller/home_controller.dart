import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:alarm/alarm.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:time_verse/config/app_route/app_route.dart';
import 'package:time_verse/config/app_route/nav_config.dart';
import 'package:time_verse/config/services/alerm_notification_service.dart';
import 'package:time_verse/config/services/alerm_service.dart';
import 'package:time_verse/features/all_events/model/event_model.dart';
import 'package:time_verse/features/auth/auth_service/auth_service.dart';
import 'dart:async';
import 'package:time_verse/features/home/model/review_model.dart';
import 'package:time_verse/features/settings/profile/controller/profile_controller.dart';

class QuoteData {
  final int? id;      
  final String quote;
  final String reference;

  QuoteData({
    this.id,
    required this.quote,
    required this.reference,
  });
}


class HomeController extends ChangeNotifier {
  int selectedIndex = 0;
  final List<ReviewData> _reviews = [];
  List<ReviewData> get reviews => List.unmodifiable(_reviews);

  final List<EventModel> todaysEvents = [];
  bool _isInitialized = false;

  final Dio _dio = Dio();

  // Daily Inspiration Quotes
  final List<QuoteData> _inspirationalQuotes = [
    QuoteData(
      id: 0,
      quote:"This is the day that the Lord has made; let us rejoice and be glad in it",
      reference: "Psalm 118:24",
    ),    
  ];

  List<QuoteData> get inspirationalQuotes => _inspirationalQuotes;
  List<QuoteData> allQuotes = [];

  String _welcomeMessage = "Welcome to TimeVerse";
  String get welcomeMessage => _welcomeMessage;

  void updateWelcomeMessage(String message) {
    _welcomeMessage = message;
    notifyListeners();
  }

  int _currentQuoteIndex = 0;
  Timer? _autoSlideTimer;
  final PageController _pageController = PageController();
  int get currentQuoteIndex => _currentQuoteIndex;
  PageController get pageController => _pageController;

  int _selectedRating = 0;
  final TextEditingController _feedbackController = TextEditingController();
  int get selectedRating => _selectedRating;
  TextEditingController get feedbackController => _feedbackController;

  final GlobalKey quoteShareKey = GlobalKey();

  HomeController() {
    allQuotes = [..._inspirationalQuotes];
  }

  /// -------------------- Initialization -------------------- ///
  void initOnce(ProfileController profileController) {
    if (_isInitialized) return;
    _isInitialized = true;

    startAutoSlide();
    fetchEvents();
    todaysfetchEvents().then((_) async {
      if (await _alarmsAlreadyScheduled()) return;

      for (final event in todaysEvents) {
        if (event.alarmTime.isNotEmpty) {
          await AlarmHelper.scheduleEventAlarm(event);
          NotificationService.scheduleNotification(
            id: event.id,
            title: event.title,
            body: event.description,
            alarmTime: DateTime.parse(event.alarmTime),
          );
        }
      }
    await _markAlarmsScheduled();
  });

  fetchReviewsFromApi();
    profileController.loadUserProfile();

    // Listen to alarm triggers in Home screen
    Alarm.ringing.listen((alarmSet) {
      if (alarmSet.alarms.isEmpty) return;
      final alarm = alarmSet.alarms.first;
      debugPrint('==== Alarm triggered on Home: ${alarm.id}');
      // Optional: Navigate to alarm screen
       appRouter.push('/alarm', extra: alarm);
    });
  }

  /// -------------------- Navigation -------------------- ///
  void updateIndexFromRoute(String location) {
    final index = appRoutes.indexWhere((r) => location.startsWith(r));
    if (index != -1 && index != selectedIndex) {
      selectedIndex = index;
      notifyListeners();
    }
  }

  void navigateTo(int index, BuildContext context) {
    selectedIndex = index;
    notifyListeners();
    context.push(appRoutes[index]);
  }

  /// -------------------- Quote Slider -------------------- ///
  void updateQuoteIndex(int index) {
    _currentQuoteIndex = index;
    notifyListeners();
  }

  void nextQuote() {
    final nextIndex = (_currentQuoteIndex + 1) % _inspirationalQuotes.length;
    _currentQuoteIndex = nextIndex;
    _pageController.animateToPage(
      nextIndex,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    notifyListeners();
  }

  void goToQuote(int index) {
    _currentQuoteIndex = index;
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    notifyListeners();
  }

  void startAutoSlide() {
    _autoSlideTimer?.cancel();
    _autoSlideTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      nextQuote();
    });
  }

  void stopAutoSlide() {
    _autoSlideTimer?.cancel();
  }

  /// -------------------- Feedback -------------------- ///
  void updateRating(int rating) {
    _selectedRating = rating;
    notifyListeners();
  }

  void clearFeedback() {
    _selectedRating = 0;
    _feedbackController.clear();
    notifyListeners();
  }

  void submitFeedback() {
    clearFeedback();
    postReviewToApi();
  }

  /// -------------------- Share Quote -------------------- ///
  void shareQuoteAsImage(BuildContext context) async {
    final boundary = quoteShareKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
    if (boundary != null) {
      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ImageByteFormat.png);
      final pngBytes = byteData!.buffer.asUint8List();

      final tempDir = await getTemporaryDirectory();
      final file = await File('${tempDir.path}/quote.png').create();
      await file.writeAsBytes(pngBytes);

      await Share.shareXFiles([XFile(file.path)], text: 'Your Daily Inspiration');
    }
  }


Future<void> fetchReviewsFromApi() async {
  try {
    final token = await AuthService().getToken();
    final baseUrl = dotenv.env['BASE_URL'] ?? '';
    final response = await _dio.get(
      '$baseUrl/api/v1/event/my-feedbacks/',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200 && response.data is List) {
        final List<dynamic> dataList = response.data as List<dynamic>;

        final List<ReviewData> loadedReviews = dataList.map((json) => ReviewData.fromJson(json as Map<String, dynamic>)).toList();
        _reviews
          ..clear()
          ..addAll(loadedReviews);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('⚠️ Error fetching reviews: $e');
    }
  }


  Future<void> postReviewToApi() async {
    try {
      final token = await AuthService().getToken();
      final baseUrl = dotenv.env['BASE_URL'] ?? '';

      final Map<String, dynamic> reviewData = {
        'rating': _selectedRating,
        'comments': _feedbackController.text.trim(),
      };

      final response = await _dio.post(
        '$baseUrl/api/v1/event/feedback/',
        data: jsonEncode(reviewData),
        options: Options(headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        clearFeedback();
        await fetchReviewsFromApi();
      }
    } catch (e) {
      debugPrint('⚠️ Error posting review: $e');
    }
  }

  Future<void> todaysfetchEvents() async {
    try {
      final token = await AuthService().getToken();
      final baseUrl = dotenv.env['BASE_URL'] ?? '';

      final response = await _dio.get(
        '$baseUrl/api/v1/today_event/',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200 && response.data is List) {
        final List data = response.data;
        todaysEvents
          ..clear()
          ..addAll(
            data.map((json) {
              final formattedDate = formatEventDate(json['date'] ?? '');
              return EventModel(
                id: json['id'] ?? 0,
                title: json['title']?.toString() ?? '',
                startTime: json['start_time']?.toString() ?? '',
                endTime: json['end_time']?.toString() ?? '',
                date: formattedDate,
                location: json['location']?.toString() ?? '',
                alarmTime: json['alarm_time']?.toString() ?? '',
                isCompleted: json['is_completed'] ?? false,
                createdAt: json['created_at']?.toString() ?? '',
                user: json['user'] ?? 0,
                category: json['category']?.toString(),
                isFavorite: json['is_favorite'] ?? false,
                userName: json['user_name']?.toString() ?? '',
                description: json['description']?.toString() ?? '',
              );
            }).toList(),
          );
        notifyListeners();
      }
    } catch (e) {
      debugPrint('⚠️ Error fetching today\'s events: $e');
    }
  }

Future<bool> _alarmsAlreadyScheduled() async {
  final prefs = await SharedPreferences.getInstance();
  final todayKey = DateFormat('yyyy-MM-dd').format(DateTime.now());
  return prefs.getBool('alarms_scheduled_$todayKey') ?? false;
}

Future<void> _markAlarmsScheduled() async {
  final prefs = await SharedPreferences.getInstance();
  final todayKey = DateFormat('yyyy-MM-dd').format(DateTime.now());
  await prefs.setBool('alarms_scheduled_$todayKey', true);
}


  Future<void> fetchEvents() async {
    try {
      final token = await AuthService().getToken();
      final baseUrl = dotenv.env['BASE_URL'] ?? '';

      final response = await _dio.get(
        '$baseUrl/api/v1/next-quite/',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        final List data = response.data is List ? response.data : [response.data];
        if (data.isEmpty) return;

        data.sort((a, b) {
          final aTime = DateTime.parse(a['created_at']);
          final bTime = DateTime.parse(b['created_at']);
          return aTime.compareTo(bTime);
        });

        final latest = data.last;

        _inspirationalQuotes
          ..clear()
          ..add(
            QuoteData(
              id: latest['id'],
              quote: latest['description']?.toString() ?? '',
              reference: latest['title']?.toString() ?? '',
            ),
          );
        notifyListeners();
      }
    } catch (e) {
      debugPrint('⚠️ Error fetching events: $e');
    }
  }

  /// -------------------- Helpers -------------------- ///
  String formatEventDate(String rawDate) {
    final startDateTime = DateTime.tryParse(rawDate);
    if (startDateTime == null) return '';

    final now = DateTime.now();
    if (startDateTime.year == now.year &&
      startDateTime.month == now.month &&
      startDateTime.day == now.day) {
      return 'Today';
    } else {
      return DateFormat('EEEE, MMM d, yyyy').format(startDateTime);
    }
  }

  Future<bool> saveQuoteToFavorite({required int eventId}) async {
    try {
      final token = await AuthService().getToken();
      final baseUrl = dotenv.env['BASE_URL'] ?? '';

      final response = await _dio.post(
        '$baseUrl/api/v1/event/$eventId/favorite/',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      debugPrint('⚠️ Error saving quote: $e');
      return false;
    }
  }

  @override
  void dispose() {
    _feedbackController.dispose();
    _autoSlideTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }
}
