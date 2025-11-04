import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:time_verse/features/auth/auth_service/auth_service.dart';

// class SignupController extends ChangeNotifier {
//   TextEditingController nameController = TextEditingController();
//   TextEditingController emailController = TextEditingController();
//   TextEditingController passwordController = TextEditingController();
//   TextEditingController confirm_passwordController = TextEditingController();

//   final AuthService _authService = AuthService(); 
//   String? signupError; 

//   void disposeControllers() {
//     emailController.dispose();
//     nameController.dispose();
//     passwordController.dispose();
//   }

//   bool areFieldsFilled(List<TextEditingController> controllers) {
//     for (final controller in controllers) {
//       if (controller.text.trim().isEmpty) {
//         return false;
//       }
//     }
//     return true;
//   }

//   bool validateSignupFields() {
//     return areFieldsFilled([emailController, nameController, passwordController]);
//   }


//   Future<bool> signupUser() async {
//     try {
//       final response = await _authService.signup(
//         emailController.text.trim(),
//         passwordController.text.trim(),
//         nameController.text.trim(),
//         profileImagePath: pickedImageName, // optional profile image
//       );

//       debugPrint("Signup response: $response");

//       if (response['success'] == true) {
//         signupError = null;

//         // debug print access token if available
//         final token = response['data']?['access'];
//         if (token != null) {
//           debugPrint('Signup Access Token: $token');
//         }

//         return true;
//       } else {
//         final error = response['error'] ?? response['message'];
//         signupError = (error != null ? error.toString() : 'Signup failed');
//         debugPrint("Signup error: $signupError");
//         return false;
//       }
//     } catch (e) {
//       debugPrint("Signup exception: $e");
//       signupError = 'Something went wrong. Please try again.';
//       return false;
//     }
//   }

//   String? pickedImageName;

//   void pickImage() async {
//     final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
//     if (picked != null) {
//       pickedImageName = picked.name;
//       notifyListeners();
//     }
//   }
// }

class SignupController extends ChangeNotifier {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirm_passwordController = TextEditingController();

  final AuthService _authService = AuthService(); 
  String? signupError; 

  void disposeControllers() {
    emailController.dispose();
    nameController.dispose();
    passwordController.dispose();
  }

  bool areFieldsFilled(List<TextEditingController> controllers) {
    for (final controller in controllers) {
      if (controller.text.trim().isEmpty) {
        return false;
      }
    }
    return true;
  }

  bool validateSignupFields() {
    return areFieldsFilled([emailController, nameController, passwordController]);
  }

  String? pickedImagePath;

  void pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      pickedImagePath = picked.path;
      notifyListeners();
    }
  }

  Future<bool> signupUser() async {
    try {
      final response = await _authService.signup(
        emailController.text.trim(),
        passwordController.text.trim(),
        nameController.text.trim(),
        profileImagePath: pickedImagePath, // optional profile image
      );

      debugPrint("Signup response: $response");

      if (response['success'] == true) {
        signupError = null;

        // debug print access token if available
        final token = response['data']?['access'];
        if (token != null) {
          debugPrint('Signup Access Token: $token');
        }

        return true;
      } else {
        final error = response['error'] ?? response['message'];
        signupError = (error != null ? error.toString() : 'Signup failed');
        debugPrint("Signup error: $signupError");
        return false;
      }
    } catch (e) {
      debugPrint("Signup exception: $e");
      signupError = 'Something went wrong. Please try again.';
      return false;
    }
  }
}
