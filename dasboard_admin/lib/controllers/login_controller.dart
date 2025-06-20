// ignore_for_file: unnecessary_null_comparison

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dasboard_admin/modals/users_modal.dart';
import 'package:dasboard_admin/screens/dashboard/screen_dashboard.dart';
import 'package:dasboard_admin/screens/login/screen_login.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final users = UserSnapshot(user: Users(), documentReference: null).obs;
  final usersSelect = UserSnapshot(user: Users(), documentReference: null).obs;
  final usersClient = UserSnapshot(user: Users(), documentReference: null).obs;
  Rx<User?> user = Rx<User?>(null);

  @override
  void onInit() {
    super.onInit();
    user.bindStream(_auth.authStateChanges());
    bindingAdminUser();
  }

  bindingAdminUser() {
    users.bindStream(UserSnapshot.getUserAdminStream());

    users.listen((snapshotList) async {
      final currentToken = await FirebaseMessaging.instance.getToken();
      if (currentToken != users.value.user!.Token) {
        if (snapshotList.user != null) {
          final UserSnapshot snapshot = snapshotList;
          final Users user = snapshot.user!;

          updateTokenIfNeededS(user);
        }
      }
    });
  }

  getUserById(String id) {
    usersClient.bindStream(UserSnapshot.getUser(id));
  }

  void updateTokenIfNeededS(Users user) async {
    String? currentToken = await FirebaseMessaging.instance.getToken();
    if (currentToken != user.Token) {
      user.Token = currentToken;

      updateUserInfo(user.Id!, user);
    }
  }

  void updateUserInfo(String userId, Users updatedUser) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .where('Id', isEqualTo: userId)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      DocumentSnapshot documentSnapshot = querySnapshot.docs.first;
      UserSnapshot userSnapshot = UserSnapshot.fromSnapshot(documentSnapshot);
      userSnapshot.user = updatedUser;

      await userSnapshot.capNhat(updatedUser);
    }
  }

  Future<void> register(String email, String password) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? newUser = userCredential.user;
      if (newUser != null) {
        user.value = newUser;
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  Future<void> login(String email, String password) async {
    try {
      if (email != "" && password != "") {
        // Check Login
        final userCredential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        if (userCredential != null) {
          final currentUser = FirebaseAuth.instance.currentUser;
          if (currentUser != null) {
            // Get user document
            final userDoc = await FirebaseFirestore.instance
                .collection("Users")
                .doc(currentUser.uid)
                .get();

            if (userDoc.exists) {
              // Check isAdmin property
              final isAdmin = userDoc.get("isAdmin");
              if (isAdmin == true) {
                Get.to(() => const ScreenDashboard());
                Get.snackbar('Success', "Login Successful",
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.greenAccent.withOpacity(0.1),
                    colorText: Colors.black);
                return;
              } else {
                Get.snackbar('Error', "Account is Not Admin",
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.redAccent.withOpacity(0.1),
                    colorText: Colors.black);
              }
            }
          }
        }
      }

      Get.snackbar('Error', "Invalid Data",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent.withOpacity(0.1),
          colorText: Colors.black);
    } catch (e) {
      Get.snackbar('Error', e.toString(),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent.withOpacity(0.1),
          colorText: Colors.black);
    }

    // Redirect to other page if login fails or isAdmin is false
    Get.to(() => const LoginScreen());
  }

  void logout() async {
    await _auth.signOut();
    user.value = null;
    Get.to(() => const LoginScreen());
    Get.snackbar('Success', "Logout Successful",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.greenAccent.withOpacity(0.1),
        colorText: Colors.black);
  }
}


// Hiển thị tháng