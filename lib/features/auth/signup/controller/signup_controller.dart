import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SignupController extends ChangeNotifier {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirm_passwordController = TextEditingController();

  String? pickedImageName;

  void pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      pickedImageName = picked.name;
      notifyListeners();
    }
  }
}