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
    'Never',
    'Daily',
    'Weekly',
    'Monthly',
    'Yearly',
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
        selectedCategory = eventDetails.category;
        
        // Ensure values exist in options lists or fall back to defaults
        selectedRepeat = repeatOptions.contains(eventDetails.repeat)
            ? eventDetails.repeat
            : repeatOptions.first;

        selectedReminder = reminderOptions.contains(eventDetails.reminder)
            ? eventDetails.reminder
            : reminderOptions.first;
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void selectCategory(String categoryName) {
    selectedCategory = categoryName;
    notifyListeners();
  }

  void selectRepeat(String repeat) {
    selectedRepeat = repeat;
    notifyListeners();
  }

  void selectReminder(String reminder) {
    selectedReminder = reminder;
    notifyListeners();
  }

  Future<bool> updateEvent(String eventId) async {
    final updatedData = EditEventModel(
      id: eventId,
      title: titleController.text,
      note: noteController.text,
      location: locationController.text,
      startTime: startTimeController.text,
      endTime: endTimeController.text,
      category: selectedCategory,
      repeat: selectedRepeat,
      reminder: selectedReminder,
    );

    return await _repository.updateEvent(eventId, updatedData);
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