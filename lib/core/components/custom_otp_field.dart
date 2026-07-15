import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:time_verse/core/utils/colors.dart';

// class CircularOtpField extends StatelessWidget {
//   final int numberOfFields;
//   final void Function(String) onSubmit;

//   const CircularOtpField({
//     super.key,
//     this.numberOfFields = 4,
//     required this.onSubmit,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final controllers = List.generate(numberOfFields, (_) => TextEditingController());
//     final isDarkMode = Theme.of(context).brightness == Brightness.dark;
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: List.generate(numberOfFields, (index) {
//         return Container(
//           width: 67,
//           height: 65,
//           margin: const EdgeInsets.symmetric(horizontal: 6),
//           decoration: BoxDecoration(
//             color: isDarkMode?AppColors.containers_bgd:AppColors.background_color, 
//             shape: BoxShape.circle,
//             border: Border.all(color: AppColors.fourth_color, width: 1.5),
//           ),
//           child: Center(
//             child: TextFormField(
//               controller: controllers[index],
//               textAlign: TextAlign.center,
//               keyboardType: TextInputType.number,
//               maxLength: 1,
//               style:GoogleFonts.outfit(
//                 fontSize: 24,
//                 color: isDarkMode? AppColors.text_color: AppColors.heading_color,
//               ),
//               decoration: const InputDecoration(
//                 counterText: '',
//                 border: InputBorder.none,
//               ),
//               onChanged: (value) {
//                 if (value.isNotEmpty && index < numberOfFields - 1) {
//                   FocusScope.of(context).nextFocus();
//                 }
//                 if (controllers.every((c) => c.text.isNotEmpty)) {
//                   onSubmit(controllers.map((c) => c.text).join());
//                 }
//               },
//             ),
//           ),
//         );
//       }),
//     );
//   }
// }
class CircularOtpField extends StatefulWidget {
  final int numberOfFields;
  final void Function(String) onSubmit;
  final TextEditingController? mainController;

  const CircularOtpField({
    super.key,
    this.numberOfFields = 4,
    required this.onSubmit,
    this.mainController,
  });

  @override
  State<CircularOtpField> createState() => _CircularOtpFieldState();
}

class _CircularOtpFieldState extends State<CircularOtpField> {
  late List<TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(widget.numberOfFields, (_) => TextEditingController());
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(widget.numberOfFields, (index) {
        return Container(
          width: 70.w,
          height: 56.h,
          decoration: BoxDecoration(
            color: isDarkMode
                ? AppColors.containers_bgd
                : AppColors.background_color,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: AppColors.fourth_color.withOpacity(0.6), 
              width: 1,
            ),
          ),
          child: Center(
            child: TextFormField(
              controller: _controllers[index],
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              maxLength: 1,
              style: GoogleFonts.outfit(
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
                color: isDarkMode
                    ? AppColors.text_color
                    : AppColors.heading_color,
              ),
              decoration: const InputDecoration(
                counterText: '',
                border: InputBorder.none,
              ),
              onChanged: (value) {
                if (value.isNotEmpty && index < widget.numberOfFields - 1) {
                  FocusScope.of(context).nextFocus();
                }
                if (value.isEmpty && index > 0) {
                  FocusScope.of(context).previousFocus();
                }
                if (_controllers.every((c) => c.text.isNotEmpty)) {
                  final code = _controllers.map((c) => c.text).join();
                  if (widget.mainController != null) widget.mainController!.text = code;
                  widget.onSubmit(code);
                }
              },
            ),
          ),
        );
      }),
    );
  }
}