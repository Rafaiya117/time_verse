// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'dart:ui' as ui;
import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:gal/gal.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:time_verse/config/app_route/nav_config.dart';
import 'package:time_verse/config/services/alerm_notification_service.dart';
import 'package:time_verse/config/services/alerm_service.dart';
import 'package:time_verse/config/services/google_service.dart';
import 'package:time_verse/config/services/user_session.dart';
import 'package:time_verse/features/all_events/model/event_model.dart';
import 'package:time_verse/features/home/model/ai_refelction_model.dart';
import 'package:time_verse/features/home/model/quotedata_model.dart';
import 'dart:async';
import 'package:time_verse/features/home/model/review_model.dart';
import 'package:time_verse/features/home/repository/event_repository.dart';
import 'package:time_verse/features/settings/profile/controller/profile_controller.dart';

class HomeController extends ChangeNotifier {
  final EventRepository _repository = EventRepository();

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
  bool isFavorite = false;

  void toggleFavorite() {
    isFavorite = !isFavorite;
    notifyListeners();
  }

  // Daily Inspiration Quotes
  final List<QuoteData> _inspirationalQuotes = [
    QuoteData(
      id: 0,
      name: '',
      quote: "Welcome to InfiniQuote.Your calendar has always kept you busy.Now let it inspire you.",
      reference: "",
    ),
  ];

  List<QuoteData> get inspirationalQuotes => _inspirationalQuotes;
  List<QuoteData> allQuotes = [];

  String _welcomeMessage = "Welcome to TimeVerse";
  String get welcomeMessage => _welcomeMessage;

  bool isAlarmRinging = false;

  Timer? _autoSlideTimer;
  final PageController _pageController = PageController();
  PageController get pageController => _pageController;

  int _selectedRating = 0;
  int get selectedRating => _selectedRating;

  final TextEditingController _feedbackController = TextEditingController();
  TextEditingController get feedbackController => _feedbackController;

  final GlobalKey quoteShareKey = GlobalKey();

  HomeController() {
    allQuotes = [..._inspirationalQuotes];
  }

  void updateWelcomeMessage(String message) {
    _welcomeMessage = message;
    notifyListeners();
  }

  /// -------------------- Initialization -------------------- ///
  void initOnce(ProfileController profileController) {
    if (_isInitialized) return;
    _isInitialized = true;

    /// Load profile FIRST
    profileController.loadUserProfile().then((_) async {
      await fetchEvents();
      await todaysfetchEvents(profileController);

      debugPrint("TODAYS EVENTS LENGTH: ${todaysEvents.length}");

      if (todaysEvents.isEmpty) return;

      final userId = profileController.currentUser?.id;
      if (userId == null) return;

      if (await _repository.alarmsAlreadyScheduled(userId)) return;

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

      await _repository.markAlarmsScheduled(userId);
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
    postReviewToApi();
  }

  Future<void> postReviewToApi() async {
    final success = await _repository.postReviewToApi(
      rating: _selectedRating,
      comments: _feedbackController.text,
    );
    if (success) {
      clearFeedback();
    }
  }

  /// -------------------- Events & Quotes API Operations -------------------- ///
  Future<List<EventModel>> _fetchGoogleCalendarEventsForHome({DateTime? date}) async {
    final accessToken = GoogleServices().accessToken;
    if (accessToken == null || accessToken.isEmpty) return [];

    final targetDate = date ?? DateTime.now();
    final dayStart = DateTime(targetDate.year, targetDate.month, targetDate.day);
    final dayEnd = dayStart.add(const Duration(days: 1));

    final gEventsData = await GoogleServices().getGoogleCalendarEvents(
      accessToken: accessToken,
      timeMin: dayStart,
      timeMax: dayEnd,
    );

    return gEventsData.map((json) {
      final rawStart = json['startTime'] ?? '';
      final rawEnd = json['endTime'] ?? '';

      String extractTime(String isoString) {
        final dt = DateTime.tryParse(isoString);
        return dt != null ? DateFormat('HH:mm').format(dt) : '';
      }

      return EventModel(
        id: json['id'].hashCode,
        userName: UserSession().username ?? 'Google Calendar',
        title: json['title'] ?? '',
        description: json['description'] ?? '',
        date: DateFormat('EEEE, MMM d, yyyy').format(targetDate),
        startTime: extractTime(rawStart),
        endTime: extractTime(rawEnd),
        location: json['location'] ?? '',
        alarmTime: '',
        isCompleted: false,
        createdAt: DateTime.now().toIso8601String(),
        user: int.tryParse(UserSession().userId ?? '0') ?? 0,
        category: 'Google Calendar',
        isFavorite: false,
      );
    }).toList();
  }

  /// -------------------- Events & Quotes API Operations -------------------- ///
  Future<void> todaysfetchEvents(
    ProfileController profileController, {
    DateTime? selectedDate,
  }) async {
    final currentUserId = profileController.currentUser?.id;
    if (currentUserId == null) {
      debugPrint("❌ Current user is null");
      return;
    }

    final fetchedEvents = await _repository.fetchTodaysEvents(
      currentUserId.toString(),
      date: selectedDate,
    );

    // Fetch Google Calendar events ONLY if user signed in with Google
    final googleEvents = await _fetchGoogleCalendarEventsForHome(date: selectedDate);

    todaysEvents
      ..clear()
      ..addAll(fetchedEvents)
      ..addAll(googleEvents);

    debugPrint("✅ TODAYS EVENTS LENGTH: ${todaysEvents.length}");
    notifyListeners();
  }

  Future<void> fetchEvents() async {
    debugPrint("🔥 fetchEvents CALLED");
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

    final newQuotes = await _repository.fetchInspirationalQuotes(currentUserId.toString());

    if (newQuotes == null || newQuotes.isEmpty) {
      _inspirationalQuotes
        ..clear()
        ..addAll(allQuotes);
    } else {
      _inspirationalQuotes
        ..clear()
        ..addAll(newQuotes);
    }

    debugPrint("✅ Inspirational Quotes Length: ${_inspirationalQuotes.length}");
    notifyListeners();
  }

  Future<bool> saveQuoteToFavorite({required int eventId}) async {
    return await _repository.saveQuoteToFavorite(eventId: eventId);
  }

  Future<void> fetchAIMooodReflection() async {
    final reflection = await _repository.fetchAIMooodReflection();
    if (reflection != null) {
      currentReflection = reflection;
      isReflectionFavorite = false;
      notifyListeners();
    }
  }

  void selectDate(DateTime date, ProfileController profileController) {
    selectedDate = date;
    todaysfetchEvents(profileController, selectedDate: date);
    notifyListeners();
  }

  /// -------------------- Image Sharing & Saving -------------------- ///
  void shareQuoteAsImage(BuildContext context, GlobalKey key) async {
    final boundary = key.currentContext?.findRenderObject() as RenderRepaintBoundary?;
    if (boundary != null) {
      final textImage = await boundary.toImage(pixelRatio: 3.0);
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);
      final size = Size(textImage.width.toDouble(), textImage.height.toDouble());

      final isDarkMode = Theme.of(context).brightness == Brightness.dark;
      final assetPath = isDarkMode
          ? 'assets/images/container_bgimg.png'
          : 'assets/images/container_bgimg_light.png';

      final ByteData assetData = await rootBundle.load(assetPath);
      final ui.Codec codec = await ui.instantiateImageCodec(assetData.buffer.asUint8List());
      final ui.FrameInfo frameInfo = await codec.getNextFrame();
      final ui.Image bgImage = frameInfo.image;

      canvas.drawImageRect(
        bgImage,
        Rect.fromLTWH(0, 0, bgImage.width.toDouble(), bgImage.height.toDouble()),
        Rect.fromLTWH(0, 0, size.width, size.height),
        Paint(),
      );
      canvas.drawImage(textImage, Offset.zero, Paint());

      final finalPicture = recorder.endRecording();
      final finalImage = await finalPicture.toImage(textImage.width, textImage.height);
      final byteData = await finalImage.toByteData(format: ui.ImageByteFormat.png);
      final pngBytes = byteData!.buffer.asUint8List();

      final tempDir = await getTemporaryDirectory();
      final file = await File('${tempDir.path}/quote.png').create();
      await file.writeAsBytes(pngBytes);

      await Share.shareXFiles([XFile(file.path)], text: 'Your Daily Inspiration by Infiniqoute');
    }
  }

  Future<bool> saveQuoteImageToGallery(GlobalKey key, {bool isDarkMode = true}) async {
    try {
      bool hasAccess = await Gal.hasAccess();
      if (!hasAccess) {
        hasAccess = await Gal.requestAccess();
        if (!hasAccess) return false;
      }

      final boundary = key.currentContext!.findRenderObject() as RenderRepaintBoundary;
      final textImage = await boundary.toImage(pixelRatio: 3.0);

      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);
      final size = Size(textImage.width.toDouble(), textImage.height.toDouble());

      final String bgAssetPath = isDarkMode
          ? 'assets/images/container_bgimg.png'
          : 'assets/images/container_bgimg_light.png';

      final ImageStream stream = AssetImage(bgAssetPath).resolve(const ImageConfiguration());
      final Completer<ui.Image> completer = Completer<ui.Image>();
      late ImageStreamListener listener;

      listener = ImageStreamListener((ImageInfo frame, bool _) {
        completer.complete(frame.image);
        stream.removeListener(listener);
      });
      stream.addListener(listener);

      final ui.Image bgUiImage = await completer.future;

      paintImage(
        canvas: canvas,
        rect: Rect.fromLTWH(0, 0, size.width, size.height),
        image: bgUiImage,
        fit: BoxFit.cover,
      );

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

  @override
  void dispose() {
    _feedbackController.dispose();
    _autoSlideTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }
}