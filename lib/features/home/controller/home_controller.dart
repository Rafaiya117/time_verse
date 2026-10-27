// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'dart:io';
import 'dart:math';
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

  EventReflectionResponse? currentReflection;
  final List<EventModel> todaysEvents = [];

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;
  DateTime selectedDate = DateTime.now();

  bool isReflectionFavorite = false;
  bool isFavorite = false;

  static const int totalBgImages = 11;
  int? currentBgIndex;

  bool isAlarmRinging = false;
  Timer? _autoSlideTimer;

  final PageController _pageController = PageController();
  PageController get pageController => _pageController;

  int _selectedRating = 0;
  int get selectedRating => _selectedRating;

  final TextEditingController _feedbackController = TextEditingController();
  TextEditingController get feedbackController => _feedbackController;

  final GlobalKey quoteShareKey = GlobalKey();

  final List<QuoteData> _defaultQuote = [
    QuoteData(
      id: 0,
      name: '',
      quote: "Welcome to InfiniQuote. Your calendar has always kept you busy. Now let it inspire you.",
      reference: "",
    ),
  ];

  List<QuoteData> inspirationalQuotes = [];

  HomeController() {
    inspirationalQuotes = [..._defaultQuote];
  }

  void setRandomBackgroundImage() {
    currentBgIndex = Random().nextInt(totalBgImages) + 1;
    notifyListeners();
  }

  void toggleFavorite() {
    isFavorite = !isFavorite;
    notifyListeners();
  }

  void updateQuoteIndex(int index) {
    _currentQuoteIndex = index;
    notifyListeners();
  }

  void updateRating(int rating) {
    _selectedRating = rating;
    notifyListeners();
  }

  void clearFeedback() {
    _selectedRating = 0;
    _feedbackController.clear();
    notifyListeners();
  }

  Future<void> submitFeedback() async {
    final success = await _repository.postReviewToApi(
      rating: _selectedRating,
      comments: _feedbackController.text,
    );
    if (success) clearFeedback();
  }

  /// 🚀 FAST INITIALIZATION: Loads all home data concurrently using Future.wait
  void initOnce(ProfileController profileController, [BuildContext? context]) {
    if (_isInitialized) return;
    _isInitialized = true;

    profileController.loadUserProfile().then((_) async {
      await loadHomeScreenData(profileController, date: selectedDate);

      final userId = profileController.currentUser?.id;
      if (userId == null || todaysEvents.isEmpty) return;
      if (await _repository.alarmsAlreadyScheduled(userId)) return;

      final now = DateTime.now();
      for (final event in todaysEvents) {
        if (event.alarmTime.isNotEmpty) {
          final cleanIso = event.alarmTime.trim().replaceAll(RegExp(r'Z$'), '');
          final parsedAlarm = DateTime.tryParse(cleanIso);
          if (parsedAlarm != null && parsedAlarm.isAfter(now) && context != null) {
            await AlarmHelper.scheduleEventAlarm(context, event);
          }
        }
      }
      await _repository.markAlarmsScheduled(userId);
    });

    Alarm.ringing.listen((alarmSet) {
      isAlarmRinging = alarmSet.alarms.isNotEmpty;
      notifyListeners();
    });
  }

  /// 🚀 PARALLEL DATA LOADER: Fetches Backend Events, Google Events, Quotes, & AI Reflections simultaneously
  Future<void> loadHomeScreenData(ProfileController profileController, {DateTime? date}) async {
    final currentUserId = profileController.currentUser?.id?.toString() ?? UserSession().userId;
    if (currentUserId == null) return;

    final targetDate = date ?? selectedDate;

    // Run independent network requests in parallel
    final results = await Future.wait([
      _repository.fetchTodaysEvents(currentUserId, date: targetDate),
      _fetchGoogleCalendarEventsForHome(date: targetDate),
      _repository.fetchAIMooodReflection(),
      _repository.fetchInspirationalQuotes(currentUserId),
    ]);

    final backendEvents = results[0] as List<EventModel>;
    final googleEvents = results[1] as List<EventModel>;
    final reflection = results[2] as EventReflectionResponse?;
    final quotes = results[3] as List<QuoteData>?;

    todaysEvents
      ..clear()
      ..addAll(backendEvents)
      ..addAll(googleEvents);

    if (reflection != null) {
      currentReflection = reflection;
    }

    if (quotes != null && quotes.isNotEmpty) {
      inspirationalQuotes
        ..clear()
        ..addAll(quotes);
    } else {
      inspirationalQuotes
        ..clear()
        ..addAll(_defaultQuote);
    }

    setRandomBackgroundImage();
    notifyListeners();
  }

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
        return dt != null ? DateFormat('HH:mm').format(dt) : isoString;
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

  void selectDate(DateTime date, ProfileController profileController) {
    selectedDate = date;
    loadHomeScreenData(profileController, date: date);
  }

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

  Future<bool> saveQuoteToFavorite({required int eventId}) async {
    return await _repository.saveQuoteToFavorite(eventId: eventId);
  }

  /// -------------------- Image Sharing & Saving -------------------- ///
  Future<void> shareQuoteAsImage(BuildContext context, GlobalKey key, {required String bgAssetPath}) async {
    try {
      final boundary = key.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) return;

      final ui.Image textImage = await boundary.toImage(pixelRatio: 3.0);
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);
      final size = Size(textImage.width.toDouble(), textImage.height.toDouble());
      
      ByteData assetData;
      try {
        assetData = await rootBundle.load(bgAssetPath);
      } catch (_) {
        final fallbackPath = Theme.of(context).brightness == Brightness.dark
            ? 'assets/images/container_bgimg.png'
            : 'assets/images/container_bgimg_light.png';
        assetData = await rootBundle.load(fallbackPath);
      }

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
      final filePath = '${tempDir.path}/reflection_${DateTime.now().millisecondsSinceEpoch}.png';
      final file = File(filePath);
      await file.writeAsBytes(pngBytes, flush: true);

      if (context.mounted && await file.exists()) {
        final box = context.findRenderObject() as RenderBox?;
        final sharePositionOrigin = box != null ? box.localToGlobal(Offset.zero) & box.size : null;
        await Share.shareXFiles(
          [XFile(file.path, mimeType: 'image/png')],
          text: 'Your Daily Inspiration by Infiniqoute',
          sharePositionOrigin: sharePositionOrigin,
        );
      }
    } catch (e) {
      debugPrint("Error sharing image: $e");
    }
  }

  Future<bool> saveQuoteImageToGallery(GlobalKey key, {required String bgAssetPath}) async {
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