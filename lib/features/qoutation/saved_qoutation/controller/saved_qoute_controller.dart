import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:share_plus/share_plus.dart';
import 'package:time_verse/features/auth/auth_service/auth_service.dart';


class SavedQouteController extends ChangeNotifier{
  final List<Map<String, String>> savedQuotes = [
    {
      'time': 'Today, 2:30 PM',
      'quoteText': 'The only way to do great work is to love what you do. If you haven\'t found it yet, keep looking. Don\'t settle.',
      'author': 'Steve Jobs',
    },
    {
      'time': 'Yesterday, 4:15 PM',
      'quoteText': 'Your time is limited, so don’t waste it living someone else’s life.',
      'author': 'Steve Jobs',
    },
    {
      'time': 'Monday, 9:00 AM',
      'quoteText': 'Innovation distinguishes between a leader and a follower.',
      'author': 'Steve Jobs',
    },
  ];
  final Set<int> selectedQuotes = {};

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
    final quotesToShare = selectedQuotes.map((i) => savedQuotes[i]['quoteText']).join('\n\n');
    // ignore: deprecated_member_use
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
          'time': item['created_at']?.toString() ?? '',
          'quoteText': item['quote_text']?.toString() ?? 'The only way to do great work is to love what you do. If you haven\'t found it yet, keep looking. Don\'t settle.',
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

}