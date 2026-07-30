import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:time_verse/features/edit_event/model/edit_event_model.dart';
import 'package:time_verse/features/edit_event/repository/edit_event_repo.dart';

class EditEventController extends ChangeNotifier {
  final EditEventRepository _repository = EditEventRepository();

  // Form Controllers
  final titleController = TextEditingController();
  final noteController = TextEditingController();
  final locationController = TextEditingController();
  final dateController = TextEditingController();
  final startTimeController = TextEditingController();
  final endTimeController = TextEditingController();

  // Selected State
  List<EditCategoryModel> categories = [];
  String? selectedCategory;
  String? selectedRepeat;
  String? selectedReminder;
  bool isLoading = true;

  // Options Lists
  final List<String> reminderOptions = [
    'None',
    '5 minutes before',
    '10 minutes before',
    '15 minutes before',
    '30 minutes before',
    '1 hour before',
    '1 day before',
  ];

  final List<String> repeatOptions = [
    "Don't repeat",
    'Every 1 day',
    'Every 1 week',
    'Every 1 month',
    'Every 1 year',
  ];

  Future<void> initEditPage(String eventId) async {
    isLoading = true;
    notifyListeners();

    try {
      categories = await _repository.getCategories();
      final eventDetails = await _repository.getEventDetails(eventId);

      if (eventDetails != null) {
        titleController.text = eventDetails.title ?? '';
        noteController.text = eventDetails.note ?? '';
        locationController.text = eventDetails.location ?? '';
        dateController.text = eventDetails.date != null
            ? DateFormat('MMMM d, yyyy').format(eventDetails.date!)
            : '';
        startTimeController.text = eventDetails.startTime ?? '';
        endTimeController.text = eventDetails.endTime ?? '';

        // ONLY set category from network if not already selected from the view
        selectedCategory ??= eventDetails.category?.toString();

        selectedRepeat ??= repeatOptions.contains(eventDetails.repeat)
            ? eventDetails.repeat
            : repeatOptions.first;

        selectedReminder ??= reminderOptions.contains(eventDetails.reminder)
            ? eventDetails.reminder
            : reminderOptions.first;
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Updated to update selectedCategory and notify listeners properly
  void selectCategory(dynamic category) {
    selectedCategory = category?.toString();
    notifyListeners();
  }


  void selectRepeat(String repeat) {
    selectedRepeat = repeat;
    notifyListeners();
  }

  void setSelectedRepeat(String repeat) {
    selectRepeat(repeat);
  }

  void selectReminder(String reminder) {
    selectedReminder = reminder;
    notifyListeners();
  }

  Future<bool> updateEvent({
    required BuildContext context,
    required String eventId,
    String? rawStart,
    String? rawEnd,
    String? rawAlarm,
    VoidCallback? onSuccess,
  }) async {
    int? categoryId;
    try {
      final catObj = categories.firstWhere(
        (c) => c.name.toLowerCase() == selectedCategory?.toLowerCase(),
      );
      categoryId = int.tryParse(catObj.id.toString());
    } catch (_) {
      categoryId = int.tryParse(selectedCategory ?? '');
    }

    DateTime? parsedDate;
    if (dateController.text.isNotEmpty) {
      try {
        parsedDate = DateFormat('MMMM d, yyyy').parse(dateController.text);
      } catch (_) {
        parsedDate = DateTime.tryParse(dateController.text);
      }
    }

    final updatedData = EditEventModel(
      id: eventId,
      title: titleController.text.trim(),
      note: noteController.text.trim(),
      location: locationController.text.trim(),
      date: parsedDate,
      startTime: rawStart ?? startTimeController.text.trim(),
      endTime: rawEnd ?? endTimeController.text.trim(),
      category: categoryId,
      repeat: selectedRepeat,
      reminder: rawAlarm ?? selectedReminder,
    );

    final isSuccess = await _repository.updateEvent(eventId, updatedData);
    if (isSuccess && onSuccess != null) {
      onSuccess();
    }
    return isSuccess;
  } 
  
  @override
  void dispose() {
    titleController.dispose();
    noteController.dispose();
    locationController.dispose();
    dateController.dispose();
    startTimeController.dispose();
    endTimeController.dispose();
    super.dispose();
  }
}