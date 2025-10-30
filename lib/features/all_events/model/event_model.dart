class EventModel {
  final String title;
  final String date;
  final String time;
  final String location;

  EventModel({
    required this.title,
    required this.date,
    required this.time,
    required this.location,
  });

  factory EventModel.fromMap(Map<String, String> map) {
    return EventModel(
      title: map['title'] ?? '',
      date: map['date'] ?? '',
      time: map['time'] ?? '',
      location: map['location'] ?? '',
    );
  }

  Map<String, String> toMap() {
    return {
      'title': title,
      'date': date,
      'time': time,
      'location': location,
    };
  }
}
