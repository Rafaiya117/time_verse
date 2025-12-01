class EventModel {
  final int id;
  final String userName;
  final String title;
  final String description;
  final String date;
  final String startTime;
  final String endTime;
  final String location;
  final String alarmTime;
  final bool isCompleted;
  final bool isFavorite;
  final String createdAt;
  final int user;
  final String? category;

  EventModel({
    required this.id,
    required this.userName,
    required this.title,
    required this.description,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.location,
    required this.alarmTime,
    required this.isCompleted,
    required this.isFavorite,
    required this.createdAt,
    required this.user,
    this.category,
  });

  factory EventModel.fromMap(Map<String, dynamic> map) {
    return EventModel(
      id: map['id'] ?? 0,
      userName: map['user_name'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      date: map['date'] ?? '',
      startTime: map['start_time'] ?? '',
      endTime: map['end_time'] ?? '',
      location: map['location'] ?? '',
      alarmTime: map['alarm_time'] ?? '',
      isCompleted: map['is_completed'] ?? false,
      isFavorite: map['is_favorite'] ?? false,
      createdAt: map['created_at'] ?? '',
      user: map['user'] ?? 0,
      category: map['category'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_name': userName,
      'title': title,
      'description': description,
      'date': date,
      'start_time': startTime,
      'end_time': endTime,
      'location': location,
      'alarm_time': alarmTime,
      'is_completed': isCompleted,
      'is_favorite': isFavorite,
      'created_at': createdAt,
      'user': user,
      'category': category,
    };
  }
}
