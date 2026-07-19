// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'dart:ui';
import 'dart:ui' as ui;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gal/gal.dart';
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

  Future<void> shareQuoteToSocialMedia([String? explicitText]) async {
    try {
      final boundary = quoteShareKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) return;
      final textImage = await boundary.toImage(pixelRatio: 3.0);
      
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);
      final size = Size(textImage.width.toDouble(), textImage.height.toDouble());

      // 🛠️ Draws explicit soft grey layer profile
      final paint = Paint()..color = const Color.fromARGB(255, 112, 98, 98);
      canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
      canvas.drawImage(textImage, Offset.zero, Paint());

      final finalPicture = recorder.endRecording();
      final finalImage = await finalPicture.toImage(textImage.width, textImage.height);
      final byteData = await finalImage.toByteData(format: ImageByteFormat.png);
      final pngBytes = byteData!.buffer.asUint8List();
      
      final tempDir = await getTemporaryDirectory();
      final uniqueFileName = 'social_share_${DateTime.now().millisecondsSinceEpoch}.png';
      final file = await File('${tempDir.path}/$uniqueFileName').create();
      await file.writeAsBytes(pngBytes);

      final sharedContent = explicitText ?? quoteText;

      debugPrint('📸 Generated pure local share file path: ${file.path}');
      await Share.shareXFiles(
        [XFile(file.path)],
        text: '✨ Check out this inspiring insight:\n“ $sharedContent ”',
      );
    } catch (e) {
      debugPrint('⚠️ Local social media sharing failed: $e');
    }
  }

  Future<void> shareQuoteAsImage([String? explicitText]) async {
    try {
      final boundary = quoteShareKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) return;

      final textImage = await boundary.toImage(pixelRatio: 3.0);
      
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);
      final size = Size(textImage.width.toDouble(), textImage.height.toDouble());

      // 🛠️ Draws explicit soft grey layer profile
      final paint = Paint()..color = const Color.fromARGB(255, 117, 90, 90);
      canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
      canvas.drawImage(textImage, Offset.zero, Paint());

      final finalPicture = recorder.endRecording();
      final finalImage = await finalPicture.toImage(textImage.width, textImage.height);
      final byteData = await finalImage.toByteData(format: ui.ImageByteFormat.png);
      final pngBytes = byteData!.buffer.asUint8List();

      await Gal.putImageBytes(pngBytes, album: 'MyQuotes');

      debugPrint('📸 Image successfully saved directly to the device gallery!');
    } catch (e) {
      debugPrint('⚠️ Error saving quote to gallery: $e');
    }
  }

  Future<EventModel?> fetchEventDetailsById(int eventId) async {
    try {
      final authService = AuthService();
      final token = await authService.getToken();
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
        debugPrint('✅ Event details fetched: $data');
        eventDetail = EventModel(
          id: data['id'] ?? 0,
          userName: "${data['user_first_name'] ?? ''} ${data['user_last_name'] ?? ''}".trim(),
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
    final utc = DateTime.parse(timeString);
    final local = utc.toLocal();
    return DateFormat('hh:mm a').format(local);
  }
}