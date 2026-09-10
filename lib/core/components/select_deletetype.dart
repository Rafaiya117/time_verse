import 'package:flutter/material.dart';

void showRemoveEventDialog(
  BuildContext context, {
  required Function(String deleteType) onConfirm,
}) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Delete Event'),
        content: const Text('Choose how you want to delete this event:'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onConfirm('single');
            },
            child: const Text('Delete This Instance'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              onConfirm('all');
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete All Recurring'),
          ),
        ],
      );
    },
  );
}