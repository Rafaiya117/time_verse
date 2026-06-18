import 'dart:convert';

class EventReflectionResponse {
  final String mood;
  final List<String> events;
  final List<String> preQuotes;
  final String aiReflection;
  final Map<String, dynamic> rawResponse;

  EventReflectionResponse({
    required this.mood,
    required this.events,
    required this.preQuotes,
    required this.aiReflection,
    required this.rawResponse,
  });

  factory EventReflectionResponse.fromJson(Map<String, dynamic> json) {
    return EventReflectionResponse(
      mood: json['mood'] ?? '',
      events: List<String>.from(json['events'] ?? []),
      preQuotes: List<String>.from(json['pre_quotes'] ?? []),
      aiReflection: json['ai_reflection'] ?? '',
      // Decodes internal nested string block fields into structural maps cleanly
      rawResponse: json['raw_response'] != null 
          ? jsonDecode(json['raw_response'] as String) as Map<String, dynamic>
          : {},
    );
  }
}