// ignore_for_file: avoid_print, await_only_futures

import 'package:client_user/constants/const_spacer.dart';
import 'package:client_user/constants/string_button.dart';
import 'package:client_user/constants/string_context.dart';
import 'package:client_user/constants/string_img.dart';
import 'package:client_user/screens/login/screen_login.dart';
import 'package:client_user/screens/signup/screen_signup.dart';
import 'package:client_user/uilt/style/color/color_main.dart';
import 'package:client_user/uilt/style/text_style/text_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ScreenWelcome extends StatefulWidget {
  const ScreenWelcome({super.key});

  @override
  State<ScreenWelcome> createState() => _ScreenWelcomeState();
}

class _ScreenWelcomeState extends State<ScreenWelcome> {
  @override
  void initState() {
    super.initState();
    // Kiểm tra trạng thái đăng nhập của người dùng khi mở app
    // checkLoginStatus();
  }

  // Future<void> checkLoginStatus() async {
  //   if (FirebaseAuth.instance.currentUser != null) {
  //     Get.off(() => const ScreenHome());
  //   } else {
  //     Get.off(() => const ScreenWelcome());
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image.asset(
                  iWelcom4,
                  height: height * 0.5,
                ),
                Column(
                  children: [
                    Text(
                      tTitleWelcome,
                      style: textBigKanit,
                    ),
                    Text(
                      tDesWelcome,
                      style: textNormalQuicksan,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                        child: ElevatedButton(
                      onPressed: () {
                        // ignore: prefer_const_constructors
                        Get.to(() => ScreenLogin());
                      },
                      // ignore: sort_child_properties_last
                      child: const Text(tButtonLogin),
                      style: ElevatedButton.styleFrom(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            side: BorderSide(color: bgBlack, width: 5.0),
                          ),
                          foregroundColor: bgWhite,
                          backgroundColor: bgBlack,
                          padding: const EdgeInsets.symmetric(
                              vertical: sButtonHeight)),
                    )),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        child: OutlinedButton(
                      onPressed: () {
                        Get.to(() => const ScreenSignup());
                      },
                      // ignore: sort_child_properties_last
                      child: const Text(
                        tButtonSignUp,
                      ),
                      style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            side: BorderSide(color: bgBlack, width: 5.0),
                          ),
                          foregroundColor: bgBlack,
                          side: BorderSide(color: bgBlack),
                          padding: const EdgeInsets.symmetric(
                              vertical: sButtonHeight)),
                    ))
                  ],
                )
              ],
            )),
      ),
    );
  }
}
