import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:time_verse/config/app_route/nav_config.dart';
import 'package:time_verse/features/calender/view/add_event.dart';

class BottomNavController extends ChangeNotifier {
  int selectedIndex = 0;
  bool showBottomCard = false;

  void updateIndexFromRoute(String location) {
    final index = appRoutes.indexWhere((r) => location.startsWith(r));
    if (index != -1 && index != selectedIndex) {
      selectedIndex = index;
      notifyListeners();
    }
  }

// void navigateTo(int index, BuildContext context) {
//   selectedIndex = index;
//   notifyListeners();

//   // if the "Add" button (index == 2) is pressed, show bottom card
//   if (index == 2) {
//     showBottomCard = true;
//     debugPrint('Showing bottom card for Add Event');
//     notifyListeners();
//     return; // 🟢 prevent navigation
//   }

//   // otherwise, go to page
//   showBottomCard = false;
//   notifyListeners();
//   context.push(appRoutes[index > 2 ? index - 1 : index]); // adjust index shift
// }

void navigateTo(int index, BuildContext context) {
  if (appRoutes[index] == '/add') {
    showBottomCard = true;
    notifyListeners();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const AddEventPage(),
    );
    return;
  }

  // 1. Update the local tab indexing state safely first
  selectedIndex = index;
  showBottomCard = false;
  notifyListeners(); // This triggers the bar rebuild cleanly

  // 2. 🛠️ THE PERMANENT FIX: Defer the push to the next frame macro-task loop.
  // This completely eliminates the framework traversal error while using .push()
  // so your history stack stays alive and context.pop() works perfectly.
  Future.delayed(Duration.zero, () {
    if (context.mounted) {
      context.push(appRoutes[index]);
    }
  });
}

  void hideBottomCard() {
    if (showBottomCard) {
      showBottomCard = false;
      notifyListeners();
    }
  }
}
