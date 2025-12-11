import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:time_verse/config/services/user_session.dart';
import 'package:time_verse/features/auth/auth_model/auth_model.dart';
import 'package:time_verse/features/auth/auth_service/auth_service.dart';
import 'package:time_verse/features/settings/profile/user_service/user_service.dart';

// class ProfileController extends ChangeNotifier{
//   TextEditingController nameController = TextEditingController();
//   TextEditingController emailController = TextEditingController();
//   TextEditingController passwordController = TextEditingController();
//   TextEditingController dateController = TextEditingController();

//   File? pickedImage;

//   Future<void> pickImage() async {
//     final picker = ImagePicker();
//     final picked = await picker.pickImage(source: ImageSource.gallery);
//     if (picked != null) {
//       pickedImage = File(picked.path);
//       notifyListeners();
//     }
//   }
// }

class ProfileController extends ChangeNotifier {
  final UserService _userService = UserService();

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  
  final auth = AuthService();

  File? pickedImage;
  User? currentUser;
  bool isLoading = false;

  void onInit() {
    loadUserProfile();
  }

  Future<void> loadUserProfile() async {
  try {
    isLoading = true;
    notifyListeners();
    final user = await _userService.getUserProfile();

    if (user != null) {
      currentUser = user; 
      nameController.text = user.name;
      passwordController.text = user.password ?? '';
      dateController.text = user.birthDate ?? '';
      
      UserSession().userId = user.id.toString();
      UserSession().username = user.name;
      UserSession().profileImageUrl = user.profilePicture; 
      //await auth.saveUserInfo(user.id.toString(), user.name);

      debugPrint("✅ User data preloaded: ${UserSession().username}");
      debugPrint("✅ User Image: ${UserSession().profileImageUrl}");
    } else {
      debugPrint("⚠️ No user data found");
    }
  } catch (e) {
    debugPrint("❌ Error loading user data: $e");
  } finally {
    isLoading = false;
    notifyListeners();
  }
}

   
  Future<void> updateProfile(BuildContext context) async {
  if (nameController.text.trim().isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Name cannot be empty")),
    ); 
    return; 
  }

  final updatedUser = User(
    id: currentUser?.id ?? 0,
    name: nameController.text.trim(),
    birthDate: dateController.text.trim().isNotEmpty
      ? dateController.text.trim()
      : null,
    profilePicture:null,
    password: passwordController.text.trim().isNotEmpty
      ? passwordController.text.trim()
      : null,
  );

  isLoading = true;
  notifyListeners();

  try {
    final result = await _userService.updateUserProfile(updatedUser,profileImage: pickedImage);
    if (result != null) {
      currentUser = result;
      nameController.text = result.name;
      passwordController.text = result.password ?? '';
      dateController.text = result.birthDate ?? '';
      UserSession().profileImageUrl = result.profilePicture;

        debugPrint("✅ Updated image path: ${UserSession().profileImageUrl}");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile updated successfully")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to update profile")),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Something went wrong. Please try again.")),
    );
  } finally {
    isLoading = false;
    loadUserProfile();
    notifyListeners();
  }
}

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      pickedImage = File(picked.path);
      debugPrint("✅ Image picked: ${pickedImage}");
      notifyListeners();
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    dateController.dispose();
    super.dispose();
  }
}
