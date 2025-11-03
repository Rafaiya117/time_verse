import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:time_verse/config/app_route/nav_config.dart';
import 'dart:async';

class QuoteData {
  final String quote;
  final String reference;

  QuoteData({required this.quote, required this.reference});
}

class HomeController extends ChangeNotifier {
  int selectedIndex = 0;

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

  // Home-specific functionality can be added here
  String _welcomeMessage = "Welcome to TimeVerse";
  
  String get welcomeMessage => _welcomeMessage;

  void updateWelcomeMessage(String message) {
    _welcomeMessage = message;
    notifyListeners();
  }

  final Dio _dio = Dio();
  // Daily Inspiration Quotes
  final List<QuoteData> _inspirationalQuotes = [
    // QuoteData(
    //   quote: '"This is the day that the Lord has made; let us rejoice and be glad in it"',
    //   reference: 'Psalm 118:24',
    // ),
    // QuoteData(
    //   quote: '"For I know the plans I have for you," declares the Lord, "plans to prosper you and not to harm you, to give you hope and a future."',
    //   reference: 'Jeremiah 29:11',
    // ),
    // QuoteData(
    //   quote: '"Trust in the Lord with all your heart and lean not on your own understanding; in all your ways submit to him, and he will make your paths straight."',
    //   reference: 'Proverbs 3:5-6',
    // ),
  ];

  int _currentQuoteIndex = 0;
  Timer? _autoSlideTimer;
  final PageController _pageController = PageController();

  List<QuoteData> get inspirationalQuotes => _inspirationalQuotes;
  int get currentQuoteIndex => _currentQuoteIndex;
  PageController get pageController => _pageController;

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

  // Feedback functionality
  int _selectedRating = 0;
  final TextEditingController _feedbackController = TextEditingController();

  int get selectedRating => _selectedRating;
  TextEditingController get feedbackController => _feedbackController;

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
    // Here you can add logic to submit feedback to backend
    // For now, just clear the form
    clearFeedback();
  }
  
  //!---------------- New ----------!
  final GlobalKey quoteShareKey = GlobalKey();

void shareQuoteAsImage(BuildContext context) async {
  final boundary = quoteShareKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
  if (boundary != null) {
    final image = await boundary.toImage(pixelRatio: 3.0);
    final byteData = await image.toByteData(format: ImageByteFormat.png);
    final pngBytes = byteData!.buffer.asUint8List();

    final tempDir = await getTemporaryDirectory();
    final file = await File('${tempDir.path}/quote.png').create();
    await file.writeAsBytes(pngBytes);

    // ignore: deprecated_member_use
    await Share.shareXFiles([XFile(file.path)], text: 'Your Daily Inspiration');
  }
}

Future<void> fetchQuotesFromApi() async {
  debugPrint('🚀 Starting fetchQuotesFromApi...');

  try {
    final response = await _dio.get('http://10.10.13.6:5000/get-quotes');
    debugPrint('✅ API responded with status: ${response.statusCode}');

    if (response.statusCode == 200 && response.data != null) {
      final data = response.data;
      debugPrint('📦 Response body: $data');

      if (data['quotes'] is List) {
        final List<QuoteData> loadedQuotes = (data['quotes'] as List).map((q) {
          final parsed = q is String ? jsonDecode(q) : q;
          debugPrint('💬 Parsed quote: $parsed');
          return QuoteData(
            quote: parsed['quote'] ?? '',
            reference: parsed['event_name'] ?? '',
          );
        }).toList();

        _inspirationalQuotes
          ..clear()
          ..addAll(loadedQuotes);

        debugPrint('🎉 Loaded ${_inspirationalQuotes.length} quotes');
        notifyListeners();
      } else {
        debugPrint('⚠️ Unexpected quotes format: ${data['quotes']}');
      }
    } else {
      debugPrint('❌ Failed to load quotes: ${response.statusCode}');
    }
  } catch (e) {
    debugPrint('⚠️ Error fetching quotes: $e');
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