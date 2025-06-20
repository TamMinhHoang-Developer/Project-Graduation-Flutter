import 'package:client_user/repository/auth_repository/auth_repository.dart';
import 'package:client_user/repository/auth_repository/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  static LoginController get instance => Get.find();

  // Input variable
  final email = TextEditingController();
  final password = TextEditingController();

  final userRepo = Get.put(UserRepository());

  final authControl = Get.put(AuthenticationRepository());

  // Call this Fun
  void loginUser(String email, String password) {
    authControl.login(email, password);
  }
}
