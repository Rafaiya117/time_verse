class EditEventModel {
  final String? id;
  final String? title;
  final String? note;
  final String? location;
  final DateTime? date;
  final String? startTime;
  final String? endTime;
  final dynamic category; // Can hold int ID or String name
  final String? reminder;
  final String? repeat;

  EditEventModel({
    this.id,
    this.title,
    this.note,
    this.location,
    this.date,
    this.startTime,
    this.endTime,
    this.category,
    this.reminder,
    this.repeat,
  });

  Map<String, dynamic> toJson() {
    // 1. Format date -> YYYY-MM-DD
    final dateString = date != null
        ? "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}"
        : null;

    // 2. Ensure times have seconds (HH:mm:ss)
    String? formatTime(String? time) {
      if (time == null || time.isEmpty) return null;
      final parts = time.split(':');
      if (parts.length == 2) return "$time:00";
      return time;
    }

    // 3. Format alarm_time to ISO format if date & time are valid
    String? formattedAlarm;
    if (dateString != null && startTime != null && startTime!.isNotEmpty) {
      try {
        final parsedStart = formatTime(startTime)!;
        final dt = DateTime.parse("${dateString}T$parsedStart");
        formattedAlarm = dt.toUtc().toIso8601String();
      } catch (_) {
        formattedAlarm = reminder;
      }
    }

    return {
      "category": category is int ? category : int.tryParse(category?.toString() ?? '') ?? category,
      "title": title,
      "type_event_description": note ?? "",
      "date": dateString,
      "start_time": formatTime(startTime),
      "end_time": formatTime(endTime),
      "location": (location == null || location!.isEmpty) ? "unknown" : location,
      "alarm_time": formattedAlarm,
      "repeat": selectedRepeatToApi(repeat),
      "is_completed": false,
      "is_alarm_sent": true,
      "is_favorite": false,
    };
  }

  /// Helper to convert UI display string to API repeat value
  static String selectedRepeatToApi(String? value) {
    if (value == null) return "1 day";
    final val = value.toLowerCase();
    if (val.contains("day")) return "1 day";
    if (val.contains("week")) return "1 week";
    if (val.contains("month")) return "1 month";
    if (val.contains("year")) return "1 year";
    return value;
  }
}

class EditCategoryModel {
  final String id;
  final String name;

  EditCategoryModel({required this.id, required this.name});

  factory EditCategoryModel.fromJson(Map<String, dynamic> json) {
    return EditCategoryModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
    );
  }
}