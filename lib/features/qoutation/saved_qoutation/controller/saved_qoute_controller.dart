// ignore_for_file: deprecated_member_use
import 'dart:io';
import 'dart:ui' as ui;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:time_verse/features/auth/auth_service/auth_service.dart';


class SavedQouteController extends ChangeNotifier {
  final List<Map<String, dynamic>> savedQuotes = [];
  final Set<int> selectedQuotes = {};

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  void updateSearchQuery(String query) {
    _searchQuery = query.toLowerCase();
    notifyListeners(); 
  }

  List<Map<String, dynamic>> get filteredQuotes {
    if (_searchQuery.isEmpty) return savedQuotes;
    return savedQuotes.where((quote) {
      final description = (quote['description'] ?? '').toString().toLowerCase();
      final author = (quote['author'] ?? '').toString().toLowerCase();
      return description.contains(_searchQuery) || author.contains(_searchQuery);
    }).toList();
  }

  void toggleQuoteSelection(int index) {
    if (selectedQuotes.contains(index)) {
      selectedQuotes.remove(index);
    } else {
      selectedQuotes.add(index);
    }
    notifyListeners();
  }

  void selectAllQuotes() {
    selectedQuotes.clear();
    for (int i = 0; i < savedQuotes.length; i++) {
      selectedQuotes.add(i);
    }
    notifyListeners();
  }

  void clearSelection() {
    selectedQuotes.clear();
    notifyListeners();
  }

  void shareSelectedQuotes(BuildContext context) {
    if (selectedQuotes.isEmpty) return;
    final quotesToShare = selectedQuotes
        .map((i) => savedQuotes[i]['description'])
        .where((q) => q != null && q.toString().trim().isNotEmpty)
        .join('\n\n');
    if (quotesToShare.trim().isEmpty) return;
    Share.share(quotesToShare);
  }

  Future<void> fetchSavedQuotes() async {
    try {
      final authService = AuthService();
      final token = await authService.getToken();
      final dio = Dio();
      final baseUrl = dotenv.env['BASE_URL'] ?? '';
      final url = '${baseUrl}api/v1/event/my-quotes/';

      final response = await dio.get(
        url,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        savedQuotes.clear();

        for (var item in data) {
          savedQuotes.add({
            'id': item['id'] as int? ?? 0,
            'time': item['created_at']?.toString() ?? '',
            'description': item['description']?.toString() ?? '',
            'author': item['author']?.toString() ?? '',
          });
        }
        notifyListeners();
      } else {
        debugPrint('❌ Failed to fetch saved quotes: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('⚠️ Error fetching saved quotes: $e');
    }
  }

  Future<bool> toggleFavorite(int eventId) async {
    try {
      final authService = AuthService();
      final token = await authService.getToken();
      final dio = Dio();
      final baseUrl = dotenv.env['BASE_URL'] ?? '';
      final url = '${baseUrl}api/v1/event/$eventId/favorite/';
      
      final response = await dio.post(
        url,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint('⭐ Favorite toggled successfully: ${response.data}');
        return true;
      } else {
        debugPrint('❌ Failed with status: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      debugPrint('⚠️ Error toggling favorite: $e');
      return false;
    }
  }

  Future<void> shareQuotesAsImage(GlobalKey boundaryKey) async {
    try {
      final RenderRepaintBoundary? boundary = 
          boundaryKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      
      if (boundary == null) return;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      
      if (byteData != null) {
        final buffer = byteData.buffer.asUint8List();
        final tempDir = await getTemporaryDirectory();
        final file = await File('${tempDir.path}/wisdom_journal.png').create();
        await file.writeAsBytes(buffer);
        await Share.shareXFiles(
          [XFile(file.path)],
          text: 'Check out my Wisdom Journal entry!',
        );
      }
    } catch (e) {
      debugPrint('⚠️ Error compiling layout vector image files: $e');
    }
  }
}