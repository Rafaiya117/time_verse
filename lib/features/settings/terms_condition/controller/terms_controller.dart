import 'package:flutter/material.dart';
import 'package:time_verse/features/settings/terms_condition/term_service/term_service.dart';

class TermsController extends ChangeNotifier {
  final TermsService _service = TermsService();

  String title = '';
  String description = '';
  bool isLoading = false;

  Future<void> loadTerms() async {
    isLoading = true;
    notifyListeners();

    try {
      final data = await _service.fetchTerms();
      if (data != null) {
        title = data['title'] ?? '';
        description = data['description'] ?? '';
      }
    } catch (e) {
      debugPrint("❌ Error loading terms: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
