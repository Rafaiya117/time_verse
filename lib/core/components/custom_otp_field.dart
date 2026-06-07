import 'package:flutter/material.dart';
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
class CircularOtpField extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final controllers = List.generate(numberOfFields, (_) => TextEditingController());

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(numberOfFields, (index) {
        return Container(
          width: 72,
          height: 55,
          margin: const EdgeInsets.symmetric(horizontal: 6),
          decoration: BoxDecoration(
            color: isDarkMode
                ? AppColors.containers_bgd
                : AppColors.background_color,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppColors.fourth_color.withOpacity(0.5), 
              width: 1,
            ),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent, 
                Colors.white.withOpacity(0.01),
                Colors.white.withOpacity(0.07),
                Colors.white.withOpacity(0.20),
              ],
              stops: const [0.0, 0.50, 0.82, 1.0], 
            ),
            boxShadow: [
              BoxShadow(
                // ignore: deprecated_member_use
                color: Colors.white.withOpacity(0.01),
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Center(
            child: TextFormField(
              controller: controllers[index],
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              maxLength: 1,
              style: GoogleFonts.outfit(
                fontSize: 24,
                color: isDarkMode
                    ? AppColors.text_color
                    : AppColors.heading_color,
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
                  final code = controllers.map((c) => c.text).join();
                  if (mainController != null) mainController!.text = code;
                  onSubmit(code);
                }
              },
            ),
          ),
        );
      }),
    );
  }
}