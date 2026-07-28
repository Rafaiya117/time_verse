class EditEventModel {
  final String id;
  final String? title;
  final String? note;
  final String? location;
  final DateTime? date;
  final String? startTime;
  final String? endTime;
  final String? category;
  final String? reminder;
  final String? repeat;

  EditEventModel({
    required this.id,
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

  factory EditEventModel.fromJson(Map<String, dynamic> json) {
    return EditEventModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString(),
      note: json['note']?.toString(),
      location: json['location']?.toString(),
      date: json['date'] != null ? DateTime.tryParse(json['date'].toString()) : null,
      startTime: json['start_time']?.toString(),
      endTime: json['end_time']?.toString(),
      category: json['category']?.toString(),
      reminder: json['reminder']?.toString(),
      repeat: json['repeat']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'note': note,
      'location': location,
      'date': date?.toIso8601String(),
      'start_time': startTime,
      'end_time': endTime,
      'category': category,
      'reminder': reminder,
      'repeat': repeat,
    };
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