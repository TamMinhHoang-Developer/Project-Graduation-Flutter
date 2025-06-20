import 'package:dasboard_admin/controllers/total_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ScreenUsersSetting extends StatefulWidget {
  const ScreenUsersSetting({super.key});

  @override
  State<ScreenUsersSetting> createState() => _ScreenUsersSettingState();
}

class _ScreenUsersSettingState extends State<ScreenUsersSetting> {
  final cu = Get.put(TotalController());
  
  
  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Scaffold(
        body: Center(
          child: Text("Hello"),
        ),
      ),
    );
  }
}
