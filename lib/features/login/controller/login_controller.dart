import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../shared/local_db/_db_helper.dart';
import '../services/_auth_service.dart';

class LoginController extends GetxController {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var firebaseAuth = FirebaseAuth.instance;
  var dbHelper = DBHelper();
  var isLoading = false.obs;

  Future<void> loginUser() async {
    // Perform login
    String email = emailController.text.toString().trim();
    String password = passwordController.text.toString().trim();

    if (email.isNotEmpty && password.isNotEmpty) {
      // Perform login

      LoginService loginService = LoginService();
      isLoading.value = true;
      Map<String, dynamic>? response =
          await loginService.loginUser(email, password);

      if (response != null && response.containsKey('error')) {
        isLoading.value = false;
        Get.snackbar('Error', response['error'],
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white);
      } else {
        isLoading.value = false;

        if (response!['role'] == 'u' || response['role'] == 'd') {
          Get.snackbar('Error', 'You are not authorized to login!',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.red,
              colorText: Colors.white);
        } else {
          Get.offAllNamed('/dashboard');
        }
      }
    } else {
      // Show error message
      Get.snackbar('Error', 'Please fill in all fields!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
  }

  Future<void> logoutUser() async {
    await firebaseAuth.signOut();
    await dbHelper.deleteUser();

    Get.offAllNamed('/login');
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
