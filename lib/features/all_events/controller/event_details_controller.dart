import 'dart:io';
import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:time_verse/features/all_events/model/event_model.dart';
import 'package:time_verse/features/auth/auth_service/auth_service.dart';

class EventController extends ChangeNotifier {
  String quoteText = '"Even the tallest tree\nstarts from a small seed. Your Contribution\nmatters."';
  
  final GlobalKey quoteShareKey = GlobalKey();
   final Dio _dio = Dio();
   EventModel? eventDetail;
  Future<void> shareQuoteAsImage() async {
    try {
      final boundary = quoteShareKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) return;

      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ImageByteFormat.png);
      final pngBytes = byteData!.buffer.asUint8List();

      final tempDir = await getTemporaryDirectory();
      final file = await File('${tempDir.path}/quote.png').create();
      await file.writeAsBytes(pngBytes);

      // ignore: deprecated_member_use
      await Share.shareXFiles([XFile(file.path)], text: '✨ ${quoteText}');
    } catch (e) {
      debugPrint('⚠️ Error sharing quote: $e');
    }
  }

  Future<EventModel?> fetchEventDetailsById(int eventId) async {
  try {
    final authService = AuthService();
    // final token = await authService.getToken();
    final token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzY0NzkxOTE1LCJpYXQiOjE3NjQ0OTE5MTUsImp0aSI6ImQ0ZmZiMzA0ODQ1ODQwMmM5YmFlMGVlYmU1YmQ5Yzk1IiwidXNlcl9pZCI6IjI3In0.4eETFk_9AwVkJtsosOZJBP5Pub3pJ5ZEGypEfrFPMSs'; 

    final baseUrl = dotenv.env['BASE_URL'] ?? '';
    final url = '${baseUrl}api/v1/event/details/?event_id=$eventId';

    final response = await _dio.get(
      url,
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ),
    );

    if (response.statusCode == 200) {
      final data = response.data;
      debugPrint('✅ Event details fetched: ${data['title']}');
      eventDetail = EventModel(
          id: data['id'] ?? 0,
          userName: data['user_name']?.toString() ?? '',
          title: data['title']?.toString() ?? '',
          description: data['description']?.toString() ?? '',
          date: data['date']?.toString() ?? '',
          startTime: data['start_time']?.toString() ?? '',
          endTime: data['end_time']?.toString() ?? '',
          location: data['location']?.toString() ?? '',
          alarmTime: data['alarm_time']?.toString() ?? '',
          isCompleted: data['is_completed'] ?? false,
          isFavorite: data['is_favorite'] ?? false,
          createdAt: data['created_at']?.toString() ?? '',
          user: data['user'] ?? 0,
          category: data['category']?.toString(),
        );
        notifyListeners();
        return eventDetail;
      } else {
      debugPrint('❌ Failed to fetch event details: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    debugPrint('⚠️ Error fetching event details: $e');
    return null;
  }
}

String formatTime(String timeString) {
  try {
    final DateTime dt = DateTime.parse(timeString); // handles ISO automatically
    return DateFormat("hh:mm a").format(dt);
  } catch (_) {
    return timeString; // fallback if parsing fails
  }
}

}
