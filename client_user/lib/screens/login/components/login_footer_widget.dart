import 'package:client_user/constants/const_spacer.dart';
import 'package:client_user/constants/string_button.dart';
import 'package:client_user/constants/string_context.dart';
import 'package:client_user/constants/string_img.dart';
import 'package:client_user/repository/auth_repository/auth_repository.dart';
import 'package:client_user/screens/signup/screen_signup.dart';
import 'package:client_user/uilt/style/color/color_main.dart';
import 'package:client_user/uilt/style/text_style/text_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginFooterWidget extends StatelessWidget {
  const LoginFooterWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final auth = Get.put(AuthenticationRepository());
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "OR",
          style: textSmallQuicksan,
        ),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
              style: ElevatedButton.styleFrom(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  side: BorderSide(color: bgBlack, width: 5.0),
                ),
                foregroundColor: bgBlack,
                backgroundColor: bgWhite,
                padding: const EdgeInsets.symmetric(vertical: sButtonHeight),
              ),
              icon: Image.asset(
                iLoginGG,
                width: 20.0,
              ),
              onPressed: () {
                auth.loginWithGoogle();
              },
              label: Text(
                tButtonSigninGG,
                style: textSmallQuicksan,
              )),
        ),
        const SizedBox(
          height: 20,
        ),
        TextButton(
            onPressed: () {
              Get.to(() => const ScreenSignup());
            },
            child: Text.rich(TextSpan(
                text: tAlready,
                style: textSmallQuicksan,
                children: [
                  TextSpan(text: tSignUp, style: textSmallQuicksanLink)
                ])))
      ],
    );
  }
}
