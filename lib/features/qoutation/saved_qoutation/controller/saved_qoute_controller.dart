import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:time_verse/config/app_route/nav_config.dart';

class SavedQouteController extends ChangeNotifier{
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
}