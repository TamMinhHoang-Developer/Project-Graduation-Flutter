import 'package:client_user/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConfirmInfo extends GetxController {
  static ConfirmInfo get instance => Get.find();

  // Input variable
  final address = TextEditingController();
  final avatar = TextEditingController();

  // Call this Fun
  void updateUser(String uid, List<Map<String, dynamic>> data) {
    Get.put(AuthController());
    AuthController.instance.updateUserv2(uid, data);
  }
}
