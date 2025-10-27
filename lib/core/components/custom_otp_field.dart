import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:time_verse/core/utils/colors.dart';

class CircularOtpField extends StatelessWidget {
  final int numberOfFields;
  final void Function(String) onSubmit;

  const CircularOtpField({
    super.key,
    this.numberOfFields = 4,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final controllers = List.generate(numberOfFields, (_) => TextEditingController());
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(numberOfFields, (index) {
        return Container(
          width: 67,
          height: 65,
          margin: const EdgeInsets.symmetric(horizontal: 6),
          decoration: BoxDecoration(
            color: isDarkMode?AppColors.containers_bgd:AppColors.background_color, 
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.fourth_color, width: 1.5),
          ),
          child: Center(
            child: TextFormField(
              controller: controllers[index],
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              maxLength: 1,
              style:GoogleFonts.outfit(
                fontSize: 24,
                color: isDarkMode? AppColors.text_color: AppColors.heading_color,
              ),
              decoration: const InputDecoration(
                counterText: '',
                border: InputBorder.none,
              ),
              onChanged: (value) {
                if (value.isNotEmpty && index < numberOfFields - 1) {
                  FocusScope.of(context).nextFocus();
                }
                if (controllers.every((c) => c.text.isNotEmpty)) {
                  onSubmit(controllers.map((c) => c.text).join());
                }
              },
            ),
          ),
        );
      }),
    );
  }
}
