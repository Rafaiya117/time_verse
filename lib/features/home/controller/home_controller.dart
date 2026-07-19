// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'dart:ui' as ui;
import 'package:alarm/alarm.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gal/gal.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:time_verse/config/app_route/nav_config.dart';
import 'package:time_verse/config/services/alerm_notification_service.dart';
import 'package:time_verse/config/services/alerm_service.dart';
import 'package:time_verse/config/services/user_session.dart';
import 'package:time_verse/features/all_events/model/event_model.dart';
import 'package:time_verse/features/auth/auth_service/auth_service.dart';
import 'package:time_verse/features/home/model/ai_refelction_model.dart';
import 'dart:async';
import 'package:time_verse/features/home/model/review_model.dart';
import 'package:time_verse/features/settings/profile/controller/profile_controller.dart';

class QuoteData {
  final int? id; 
  final String name;     
  final String quote;
  final String reference;

  QuoteData({
    this.id,
    required this.name,
    required this.quote,
    required this.reference,
  });
}


class HomeController extends ChangeNotifier {
  int selectedIndex = 0;
  int _currentQuoteIndex = 0;
  int get currentQuoteIndex => _currentQuoteIndex;
  final List<ReviewData> _reviews = [];
  List<ReviewData> get reviews => List.unmodifiable(_reviews);
  EventReflectionResponse? currentReflection;

  final List<EventModel> todaysEvents = [];
  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;
  DateTime selectedDate = DateTime.now();

  bool isReflectionFavorite = false;

  final Dio _dio =  Dio(BaseOptions(
    baseUrl: dotenv.env['BASE_URL'] ?? '',
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));

  

  // Daily Inspiration Quotes
  final List<QuoteData> _inspirationalQuotes = [
    QuoteData(
      id: 0,
      name: '',
      quote:"Welcome to InfiniQuote.Your calendar has always kept you busy.Now let it inspire you.",
      reference: "",
    ),    
  ];

  List<QuoteData> get inspirationalQuotes => _inspirationalQuotes;
  List<QuoteData> allQuotes = [];

  String _welcomeMessage = "Welcome to TimeVerse";
  String get welcomeMessage => _welcomeMessage;

  bool isAlarmRinging = false;

  void updateWelcomeMessage(String message) {
    _welcomeMessage = message;
    notifyListeners();
  }


  Timer? _autoSlideTimer;
  final PageController _pageController = PageController();
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

  /// 🔥 Load profile FIRST
  profileController.loadUserProfile().then((_) async {
    await fetchEvents();              
    await todaysfetchEvents(profileController);

    debugPrint("TODAYS EVENTS LENGTH: ${todaysEvents.length}");

    if (todaysEvents.isEmpty) return;

    final userId = profileController.currentUser?.id;
    if (userId == null) return;

    if (await _alarmsAlreadyScheduled(userId)) return;

    for (final event in todaysEvents) {
      if (event.alarmTime.isNotEmpty) {
        await AlarmHelper.scheduleEventAlarm(event);

        NotificationService.scheduleNotification(
          id: event.id,
          title: event.title,
          body: event.description,
          alarmTime: DateTime.parse(event.alarmTime),
          payload: event.id,
        );
      }
    }

    await _markAlarmsScheduled(userId);
  });

  Alarm.ringing.listen((alarmSet) {
    isAlarmRinging = alarmSet.alarms.isNotEmpty;
    notifyListeners();
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
    //clearFeedback();
    postReviewToApi();
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

      debugPrint('📤 Post Review Response Data: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        clearFeedback();
      }
    } catch (e) {
      debugPrint('⚠️ Error posting review: $e');
    }
  }

  Future<void> todaysfetchEvents(ProfileController profileController, {DateTime? selectedDate,}) async {
  try {
    final token = await AuthService().getToken();
    /// ✅ default = today
    final dateToFetch = selectedDate ?? DateTime.now();

    final formattedDate = "${dateToFetch.year.toString().padLeft(4, '0')}-" "${dateToFetch.month.toString().padLeft(2, '0')}-""${dateToFetch.day.toString().padLeft(2, '0')}";

    final response = await _dio.get(
      'api/v1/event/',
      queryParameters: {
        'date': formattedDate, 
      },
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );

    final data = response.data is String
    ? jsonDecode(response.data) : response.data;

    if (data is List) {
      final currentUserId = profileController.currentUser?.id;

      if (currentUserId == null) {
        debugPrint("❌ Current user is null");
        return;
      }

      todaysEvents
        ..clear()
        ..addAll(
          data.map((e) => EventModel.fromMap(e)).where((event) => event.user.toString() == currentUserId.toString(),).toList(),
        );
      debugPrint("✅ TODAYS EVENTS LENGTH: ${todaysEvents.length}");
    } else {
      debugPrint("❌ API did not return List");
      todaysEvents.clear();
    }

    notifyListeners();
  } catch (e) {
    debugPrint("❌ Error fetching events: $e");
  }
}

Future<bool> _alarmsAlreadyScheduled(int userId) async {
  final prefs = await SharedPreferences.getInstance();
  final todayKey = DateFormat('yyyy-MM-dd').format(DateTime.now());
  return prefs.getBool('alarms_scheduled_${userId}_$todayKey') ?? false;
}

Future<void> _markAlarmsScheduled(int userId) async {
  final prefs = await SharedPreferences.getInstance();
  final todayKey = DateFormat('yyyy-MM-dd').format(DateTime.now());
  await prefs.setBool('alarms_scheduled_${userId}_$todayKey', true);
}

Future<void> fetchEvents() async {
  try {
    debugPrint("🔥 fetchEvents CALLED");

    final token = await AuthService().getToken();
    final currentUserId = UserSession().userId;

    debugPrint("👤 Current User ID: $currentUserId");

    if (currentUserId == null) {
      debugPrint("❌ User ID is null — restoring default quote.");

      _inspirationalQuotes
        ..clear()
        ..addAll(allQuotes);

      notifyListeners();
      return;
    }

    final response = await _dio.get(
      'api/v1/event/',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ),
    );

    debugPrint("📡 Response Status: ${response.statusCode}");
    debugPrint("📦 Raw Response Type: ${response.data.runtimeType}");

    if (response.statusCode == 200) {
      final List data = response.data is List ? response.data : [response.data];

      debugPrint("📊 Total Events From API: ${data.length}");

      /// 🔥 Safe filtering
      final userEvents = data.where((event) {
      debugPrint("🔎 Checking Event User: ${event['user']}");
      return event['user'].toString() == currentUserId.toString();}).toList();

      debugPrint("🎯 User Events After Filter: ${userEvents.length}");

      /// ⭐ No events → restore default
      if (userEvents.isEmpty) {
        debugPrint("⚠️ No user events found. Restoring default quote.");

        _inspirationalQuotes
          ..clear()
          ..addAll(allQuotes);

        notifyListeners();
        return;
      }

      /// Sort by created date
      userEvents.sort((a, b) {
        final aTime = DateTime.parse(a['created_at']);
        final bTime = DateTime.parse(b['created_at']);
        return aTime.compareTo(bTime);
      });

      final latest = userEvents.last;

      debugPrint("🏆 Latest Event ID: ${latest['id']}");
      debugPrint("📝 Description: ${latest['description']}");
      debugPrint("📌 Type Description: ${latest['type_event_description']}");

      /// ⭐ Use description OR fallback
      final quoteText = (latest['description']?.toString().trim().isNotEmpty == true)
      ? latest['description'].toString() : latest['type_event_description']?.toString() ?? '';

      debugPrint("✨ Final Quote Text: $quoteText");

      _inspirationalQuotes
        ..clear()
        ..add(
          QuoteData(
            id: latest['id'],
            name: latest['category_name'],
            quote: quoteText,
            reference: latest['title']?.toString() ?? '',
          ),
        );

      debugPrint("✅ Inspirational Quotes Length: ${_inspirationalQuotes.length}");
      notifyListeners();
    }
  } catch (e) {
    debugPrint('⚠️ Error fetching events: $e');
  }
}

 /// -------------------- Share Quote -------------------- ///
void shareQuoteAsImage(BuildContext context, GlobalKey key) async {
    final boundary = key.currentContext?.findRenderObject() as RenderRepaintBoundary?;
    if (boundary != null) {
      // 1. Capture the transparent text snapshot layer
      final textImage = await boundary.toImage(pixelRatio: 3.0);
      
      // 2. Initialize a dynamic high-fidelity canvas frame backing
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);
      final size = Size(textImage.width.toDouble(), textImage.height.toDouble());

      // 3. 🛠️ FIX: Replaced gradient shader with a clean, solid soft grey color fill pass
      final paint = Paint()
        ..color = const Color.fromARGB(255, 117, 117, 117); 
      canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);

      // 4. Overlap the recorded transparent text frame directly over your canvas paint layout
      canvas.drawImage(textImage, Offset.zero, Paint());

      // 5. Compile into a solid graphic object configuration asset
      final finalPicture = recorder.endRecording();
      final finalImage = await finalPicture.toImage(textImage.width, textImage.height);
      final byteData = await finalImage.toByteData(format: ImageByteFormat.png);
      final pngBytes = byteData!.buffer.asUint8List();

      final tempDir = await getTemporaryDirectory();
      final file = await File('${tempDir.path}/quote.png').create();
      await file.writeAsBytes(pngBytes);

      await Share.shareXFiles([XFile(file.path)], text: 'Your Daily Inspiration by Infiniqoute');
    }
  }

  Future<bool> saveQuoteImageToGallery(GlobalKey key) async {
    try {
      bool hasAccess = await Gal.hasAccess();
      if (!hasAccess) {
        hasAccess = await Gal.requestAccess();
        if (!hasAccess) return false;
      }

      final boundary = key.currentContext!.findRenderObject() as RenderRepaintBoundary;
      final textImage = await boundary.toImage(pixelRatio: 3.0);
      
      // 🛠️ Dynamic Canvas composition mapping rules duplicate exactly to maintain parity across share/save passes
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);
      final size = Size(textImage.width.toDouble(), textImage.height.toDouble());

      // 🛠️ FIX: Replaced gradient shader with a clean, solid soft grey color fill pass
      final paint = Paint()
        ..color = const Color.fromARGB(255, 61, 60, 60);
      canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
      canvas.drawImage(textImage, Offset.zero, Paint());

      final finalPicture = recorder.endRecording();
      final finalImage = await finalPicture.toImage(textImage.width, textImage.height);
      final byteData = await finalImage.toByteData(format: ui.ImageByteFormat.png);
      final pngBytes = byteData!.buffer.asUint8List();

      await Gal.putImageBytes(pngBytes);
      return true;
    } catch (e) {
      debugPrint("Save error: $e");
      return false;
    }
  }

  Future<bool> saveQuoteToFavorite({required int eventId}) async {
    try {
      final token = await AuthService().getToken(); 
      final baseUrl = dotenv.env['BASE_URL'] ?? '';

      final response = await _dio.post(
        '$baseUrl/api/v1/event/$eventId/favorite', 
        data: {}, 
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

  Future<void> fetchAIMooodReflection() async {
    try {
      final token = await AuthService().getToken();
      if (token == null || token.isEmpty) {
        debugPrint('⚠️ Error: Empty or missing auth token in fetchAIMooodReflection');
        return;
      }

      final response = await _dio.get(
        'api/v1/event/ai-reflection/', 
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      debugPrint('📥 AI Reflection Response Data: ${response.data}');

      if (response.statusCode == 200 && response.data != null) {
        currentReflection = EventReflectionResponse.fromJson(response.data);
        debugPrint('ai_reflection ${response.data}');
        isReflectionFavorite = false;
        notifyListeners();
      }
    } on DioException catch (e) {
      debugPrint('❌ Dio error fetching AI reflection: ${e.response?.statusCode} -> ${e.response?.data}');
    } catch (e) {
      debugPrint('⚠️ Unexpected error fetching AI reflection: $e');
    }
  }

  void selectDate(DateTime date, ProfileController profileController) {
    selectedDate = date;
    todaysfetchEvents(profileController, selectedDate: date);
    notifyListeners();
  }

  @override
  void dispose() {
    _feedbackController.dispose();
    _autoSlideTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }
}

