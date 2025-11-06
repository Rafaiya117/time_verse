import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:time_verse/features/auth/auth_service/auth_service.dart';
import 'package:time_verse/features/calender/model/event_category_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AddEventController extends ChangeNotifier {
  final Dio _dio = Dio();
  List<EventCategory> categories = [];
  bool isLoading = false;

  Future<Options> _authorizedHeader() async {
    final token = await AuthService().getToken();
    return Options(
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
  }

  Future<void> fetchCategories() async {
    try {
      isLoading = true;
      notifyListeners();
      final options = await _authorizedHeader();

      final response = await _dio.get(
        '${dotenv.env['BASE_URL']}api/v1/categories/',
        options: options,
      );

      if (response.statusCode == 200) {
        categories = (response.data as List)
            .map((json) => EventCategory.fromJson(json))
            .toList();
      } else {
        debugPrint('Failed to load categories: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching categories: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}


