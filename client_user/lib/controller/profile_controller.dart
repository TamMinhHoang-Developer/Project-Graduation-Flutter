import 'package:client_user/modal/users.dart';
import 'package:client_user/repository/auth_repository/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  static ProfileController get instance => Get.find();
  final authControl = Get.put(AuthenticationRepository());

  final email = TextEditingController();
  final password = TextEditingController();
  final fullname = TextEditingController();
  final phoneNo = TextEditingController();

  void updateUserData(String id, String name, String email, String password,
      String phone, String avatar) {
    final user = Users(
        Id: authControl.user.value.Id,
        Address: authControl.user.value.Address,
        Name: name,
        Avatar: avatar,
        Email: email,
        PackageType: authControl.user.value.PackageType,
        Phone: phone,
        Password: password,
        Status: authControl.user.value.Status,
        ActiveAt: authControl.user.value.ActiveAt,
        CreatedAt: authControl.user.value.CreatedAt);
    authControl
        .updateUserData(id, user)
        .then((_) => {
              Get.snackbar('Success', "Update Data Controll Success",
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.greenAccent.withOpacity(0.1),
                  colorText: Colors.black)
            })
        .catchError((err) => {
              Get.snackbar('Error', err.toString(),
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.greenAccent.withOpacity(0.1),
                  colorText: Colors.black)
            });
  }
}
