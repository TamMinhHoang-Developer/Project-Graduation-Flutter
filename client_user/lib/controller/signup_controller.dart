import 'package:client_user/modal/users.dart';
import 'package:client_user/repository/auth_repository/auth_repository.dart';
import 'package:client_user/repository/auth_repository/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpController extends GetxController {
  static SignUpController get instance => Get.find();

  // Input variable
  final email = TextEditingController();
  final password = TextEditingController();
  final fullName = TextEditingController();
  final phoneNo = TextEditingController();

  final userRepo = Get.put(UserRepository());
  final auth = Get.put(AuthenticationRepository());

  // Call this Fun
  void registerUser(String email, String password) {
    Get.put(AuthenticationRepository());
    String? error = AuthenticationRepository.instance
        .createUserWithEmailAndPasswordv2(email, password) as String?;
    if (error != null) {
      Get.showSnackbar(GetSnackBar(message: error.toString()));
    }
  }

  void phoneAuthentication(String phoneNo) {
    auth.phoneAuthentication(phoneNo);
  }

  Future<void> createUser(Users users) async {
    await userRepo.createUser(users);
  }
}
