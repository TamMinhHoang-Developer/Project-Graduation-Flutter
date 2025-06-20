import 'package:client_user/common/form/form_header_widget.dart';
import 'package:client_user/constants/const_spacer.dart';
import 'package:client_user/constants/string_button.dart';
import 'package:client_user/constants/string_context.dart';
import 'package:client_user/constants/string_img.dart';
import 'package:client_user/screens/forget_password/forget_password_otp/screen_otp.dart';
import 'package:client_user/uilt/style/color/color_main.dart';
import 'package:client_user/uilt/style/text_style/text_style.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgetPasswordMailScreen extends StatefulWidget {
  const ForgetPasswordMailScreen({super.key});

  @override
  State<ForgetPasswordMailScreen> createState() =>
      _ForgetPasswordMailScreenState();
}

class _ForgetPasswordMailScreenState extends State<ForgetPasswordMailScreen> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const SizedBox(
                  height: 20 * 4,
                ),
                const FormHeaderWidget(
                  title: tForgot,
                  image: iForgot,
                  subTitle: tForgetPasswordSubTitle,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  heightBetween: 30.0,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Form(
                    child: Column(
                  children: [
                    TextFormField(
                      controller: emailController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) =>
                          value != null && !EmailValidator.validate(value)
                              ? "Enter a valid email"
                              : null,
                      decoration: InputDecoration(
                          label: Text(
                            tEmail,
                            style: textSmallQuicksan,
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 2.0, color: bgBlack)),
                          border: const OutlineInputBorder(),
                          hintText: tEmail,
                          prefixIcon: Icon(
                            Icons.mail_outline_rounded,
                            color: bgBlack,
                          )),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
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
                          onPressed: () {
                            // Navigator.pop(context);

                            FirebaseAuth.instance
                                .sendPasswordResetEmail(
                                    email: emailController.text)
                                .then((value) {
                              Get.to(() => ScreenOTPEmail(
                                    email: emailController.text,
                                  ));
                            }).catchError((err) {
                              Get.snackbar("Error", err.toString());
                            });
                          },
                          child: Text(
                            "Next".toUpperCase(),
                            style: textSmallQuicksanWhite,
                          )),
                    )
                  ],
                ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
