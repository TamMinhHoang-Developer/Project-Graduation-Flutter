import 'package:dasboard_admin/connect/firebase_connection.dart';
import 'package:dasboard_admin/screens/login/screen_login.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: camel_case_types
class Page_GetXFirebaseApp extends StatelessWidget {
  const Page_GetXFirebaseApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MyFirebaseConnect(
        builder: (context) {
          return const GetMaterialApp(
            title: "GetX Firebase App",
            debugShowCheckedModeBanner: false,
            home: LoginScreen(),
          );
        },
        errorMessage: "Lỗi khi kết nối Firebase",
        connectingMessage: "Đang kết nối với Firebase");
  }
}
