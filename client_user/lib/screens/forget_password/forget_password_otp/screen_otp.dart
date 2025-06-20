import 'package:client_user/constants/const_spacer.dart';
import 'package:client_user/constants/string_button.dart';
import 'package:client_user/constants/string_context.dart';
import 'package:client_user/controller/login_controller.dart';
import 'package:client_user/controller/otp_controller.dart';
import 'package:client_user/shared/input/input.dart';
import 'package:client_user/uilt/style/color/color_main.dart';
import 'package:client_user/uilt/style/text_style/text_style.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:google_fonts/google_fonts.dart';

class ScreenOTPEmail extends StatefulWidget {
  const ScreenOTPEmail({super.key, required this.email});
  final String email;

  @override
  State<ScreenOTPEmail> createState() => _ScreenOTPEmailState();
}

class _ScreenOTPEmailState extends State<ScreenOTPEmail> {
  final GlobalKey _formKey = GlobalKey<FormState>();
  TextEditingController txtPass = TextEditingController();

  bool passwordVisible = false;
  void togglePassword() {
    setState(() {
      passwordVisible = !passwordVisible;
    });
  }

  @override
  void dispose() {
    txtPass.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 100,
                ),
                Text(
                  tOtpTitle,
                  style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.bold, fontSize: 80),
                ),
                Text(
                  tOtpSubTitle.toUpperCase(),
                  style: textsubTitleOTP,
                ),
                const SizedBox(
                  height: 40,
                ),
                Text(
                  "$tOptMessage ${widget.email}",
                  style: textNormalQuicksanBold,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: txtPass,
                  obscureText: !passwordVisible,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) =>
                      value != null ? "Value is requiment" : null,
                  decoration: InputDecoration(
                    label: Text(
                      tPassword,
                      style: textSmallQuicksan,
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 2.0, color: bgBlack)),
                    border: const OutlineInputBorder(),
                    hintText: tPassword,
                    prefixIcon: Icon(
                      Icons.key,
                      color: bgBlack,
                    ),
                    suffixIcon: IconButton(
                      color: Colors.black,
                      splashRadius: 1,
                      icon: Icon(passwordVisible
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined),
                      onPressed: togglePassword,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () {
                        LoginController.instance
                            .loginUser(widget.email, txtPass.text.trim());
                      },
                      // ignore: sort_child_properties_last
                      child: Text(
                        "LOGIN",
                        style: textSmallQuicksanWhite,
                      ),
                      style: ElevatedButton.styleFrom(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            side: BorderSide(color: bgBlack, width: 5.0),
                          ),
                          foregroundColor: bgWhite,
                          backgroundColor: bgBlack,
                          padding: const EdgeInsets.symmetric(
                              vertical: sButtonHeight))),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
