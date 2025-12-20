// import 'package:flutter/material.dart';

// Future<void> showErrorDialog(BuildContext context, String message) async {
//   await showDialog(
//     context: context,
//     builder: (ctx) {
//       return AlertDialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         title: Row(
//           children: const [
//             Icon(Icons.error_outline, color: Colors.red),
//             SizedBox(width: 8),
//             Text(
//               'Error',
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 color: Colors.red,
//               ),
//             ),
//           ],
//         ),
//         content: SingleChildScrollView(
//           child: Text(
//             message,
//             style: const TextStyle(fontSize: 15),
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(ctx),
//             child: const Text('OK'),
//           ),
//         ],
//       );
//     },
//   );
// }
import 'package:flutter/material.dart';

Future<void> showMessageDialog(
  BuildContext context,
  String message, {
  String title = 'Error',
  IconData icon = Icons.error_outline,
  Color iconColor = Colors.red,
}) async {
  await showDialog(
    context: context,
    builder: (ctx) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        title: Row(
          children: [
            Icon(icon, color: iconColor),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: iconColor,
              ),
            ),
          ],
        ),
        content: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 250),
          child: SingleChildScrollView(
            child: SelectableText(
              message,
              style: const TextStyle(
                fontSize: 15,
                height: 1.4,
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}
