import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_verse/features/calender/controller/time_controller.dart';

class TimePickerField extends StatelessWidget {
  const TimePickerField({super.key});

  Widget _buildTimeField({
    required BuildContext context,
    required String label,
    required TimeOfDay? time,
    required VoidCallback onTap,
    required String formattedTime,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            // ignore: deprecated_member_use
            border: Border.all(color: Colors.white.withOpacity(0.3)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                time == null ? label : formattedTime,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
              const Icon(
                Icons.access_time,
                color: Colors.white,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<TimePickerController>(context);

    return Row(
      children: [
        _buildTimeField(
          context: context,
          label: 'Start time',
          time: controller.startTime,
          formattedTime: controller.formatTime(controller.startTime),
          onTap: () => controller.selectTime(context, true),
        ),
        const SizedBox(width: 12),
        _buildTimeField(
          context: context,
          label: 'End time',
          time: controller.endTime,
          formattedTime: controller.formatTime(controller.endTime),
          onTap: () => controller.selectTime(context, false),
        ),
      ],
    );
  }
}
