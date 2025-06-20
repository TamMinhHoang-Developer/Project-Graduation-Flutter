// ignore_for_file: file_names

import 'package:client_user/constants/const_spacer.dart';
import 'package:client_user/constants/string_button.dart';
import 'package:client_user/constants/string_context.dart';

import 'package:client_user/uilt/style/color/color_main.dart';
import 'package:client_user/uilt/style/text_style/text_style.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ScreenOTPPhone extends StatefulWidget {
  const ScreenOTPPhone(
      {super.key, required this.verificationId, required this.phone});
  final String verificationId;
  final String phone;

  @override
  State<ScreenOTPPhone> createState() => _ScreenOTPPhoneState();
}

class _ScreenOTPPhoneState extends State<ScreenOTPPhone> {
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
                  widget.phone,
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
                      onPressed: () {},
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
