import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:time_verse/features/calender/repository/add_event_repository.dart';

class OfflineSyncService {
  static final OfflineSyncService _instance = OfflineSyncService._internal();
  factory OfflineSyncService() => _instance;
  OfflineSyncService._internal();

  static const String _queueKey = 'pending_event_queue';

  /// Initialize listener for internet status changes
  void initListener(AddEventRepository repository) {
    Connectivity().onConnectivityChanged.listen((results) async {
      final hasConnection = results.any((r) => r != ConnectivityResult.none);
      if (hasConnection) {
        debugPrint('🌐 Network connected. Syncing offline events...');
        await processQueue(repository);
      }
    });
  }

  /// Save request payload locally when offline or request fails due to connection
  Future<void> saveToQueue(Map<String, dynamic> body) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> queue = prefs.getStringList(_queueKey) ?? [];
    queue.add(jsonEncode(body));
    await prefs.setStringList(_queueKey, queue);
    debugPrint('💾 Event queued locally for sync. Items in queue: ${queue.length}');
  }

  /// Send all queued events to the backend
  Future<void> processQueue(AddEventRepository repository) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> queue = prefs.getStringList(_queueKey) ?? [];

    if (queue.isEmpty) return;

    List<String> remainingItems = List.from(queue);

    for (String itemStr in queue) {
      try {
        final body = jsonDecode(itemStr) as Map<String, dynamic>;
        final result = await repository.createTaskRaw(body);

        if (result != null) {
          remainingItems.remove(itemStr);
          debugPrint('✅ Synced queued event: ${body['title']}');
        }
      } catch (e) {
        debugPrint('⚠️ Sync attempt failed for item: $e');
        break;
      }
    }

    await prefs.setStringList(_queueKey, remainingItems);
  }
}