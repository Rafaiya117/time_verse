import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class EventDateTimeUtils {
  static final List<DateFormat> _dateFormats = [
    DateFormat("yyyy-MM-dd"),
    DateFormat("dd/MM/yyyy"),
    DateFormat("dd-MM-yyyy"),
    DateFormat("MM/dd/yyyy"),
    DateFormat("MM-dd-yyyy"),
    DateFormat("EEEE, MMMM d, yyyy"),
    DateFormat("MMMM d, yyyy"),
    DateFormat("d MMMM yyyy"),
  ];

  /// Cleans raw time strings into HH:mm format
  static String cleanTimeStr(String raw) {
    final clean = raw.trim();
    if (clean.isEmpty) return "00:00";

    if (clean.toLowerCase().contains('am') || clean.toLowerCase().contains('pm')) {
      for (final pattern in ["h:mm a", "hh:mm:ss a", "hh:mm a"]) {
        try {
          return DateFormat("HH:mm").format(DateFormat(pattern).parse(clean));
        } catch (_) {}
      }
    }

    final parts = clean.split(':');
    if (parts.length >= 2) {
      final hour = parts[0].padLeft(2, '0');
      final minute = parts[1].padLeft(2, '0');
      return "$hour:$minute";
    }

    return clean;
  }

  /// Calculates alarm offset back from event start time
  static String calculateAlarmOffset(String startTimeClean, String alarmClean) {
    if (alarmClean.isEmpty || startTimeClean.isEmpty) return startTimeClean;
    try {
      final lowerAlarm = alarmClean.toLowerCase();
      if (lowerAlarm.contains(':') || lowerAlarm.contains('am') || lowerAlarm.contains('pm')) {
        return cleanTimeStr(lowerAlarm);
      }

      final parts = startTimeClean.split(':');
      final baseTime = DateTime(2026, 1, 1, int.parse(parts[0]), int.parse(parts[1]));

      int minutesBefore = 10;
      final match = RegExp(r'\d+').firstMatch(lowerAlarm);

      if (match != null) {
        final val = int.parse(match.group(0)!);
        if (lowerAlarm.contains('hr') || lowerAlarm.contains('hour')) {
          minutesBefore = val * 60;
        } else if (lowerAlarm.contains('day')) {
          minutesBefore = val * 1440;
        } else {
          minutesBefore = val;
        }
      }

      final calculated = baseTime.subtract(Duration(minutes: minutesBefore));
      return DateFormat("HH:mm:ss").format(calculated);
    } catch (e) {
      debugPrint("⚠️ Failed to parse offset: $e");
      return startTimeClean;
    }
  }

  /// Parses date string and time string into a DateTime instance
  static DateTime parseDateTime(String rawDate, String rawTime) {
    final cleanDate = rawDate.trim();
    final cleanTime = cleanTimeStr(rawTime);

    DateTime? parsedDate;
    for (final format in _dateFormats) {
      try {
        parsedDate = format.parse(cleanDate);
        break;
      } catch (_) {}
    }
    parsedDate ??= DateTime.tryParse(cleanDate) ?? DateTime.now();

    final timeParts = cleanTime.split(':');
    final hour = timeParts.isNotEmpty ? int.tryParse(timeParts[0]) ?? 0 : 0;
    final minute = timeParts.length > 1 ? int.tryParse(timeParts[1]) ?? 0 : 0;

    return DateTime(parsedDate.year, parsedDate.month, parsedDate.day, hour, minute);
  }

  /// Formats date and time into ISO standard string
  static String formatAlarmISO(String date, String time) {
    try {
      final dt = parseDateTime(date, time);
      return DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(dt);
    } catch (_) {
      return "${parseBackendDate(date)}T00:00:00";
    }
  }

  /// Converts multi-format date string into backend yyyy-MM-dd format
  static String parseBackendDate(String rawDateText) {
    for (final format in _dateFormats) {
      try {
        return DateFormat("yyyy-MM-dd").format(format.parse(rawDateText));
      } catch (_) {}
    }
    try {
      return DateFormat("yyyy-MM-dd").format(DateTime.parse(rawDateText));
    } catch (_) {
      return rawDateText;
    }
  }

  /// Parses DioException or dynamic error into user readable text
  static String formatErrorMessage(dynamic e) {
    if (e is DioException && e.response?.data is Map) {
      return (e.response!.data as Map).entries.map((entry) => "${entry.key}: ${entry.value.toString().replaceAll('[', '').replaceAll(']', '')}").join("\n");
    } else if (e is DioException) {
      return e.response?.data?.toString() ?? e.message ?? "Unknown server error";
    }
    return e.toString();
  }
}