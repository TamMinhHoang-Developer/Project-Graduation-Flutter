// ignore_for_file: avoid_print

import 'package:client_user/constants/const_spacer.dart';
import 'package:client_user/constants/string_button.dart';
import 'package:client_user/constants/string_context.dart';
import 'package:client_user/controller/auth_controller.dart';
import 'package:client_user/controller/login_controller.dart';
import 'package:client_user/screens/forget_password/forget_password_options/forget_password_modal_bottom_sheet.dart';
import 'package:client_user/uilt/style/color/color_main.dart';
import 'package:client_user/uilt/style/text_style/text_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginForm extends StatefulWidget {
  const LoginForm({
    super.key,
  });

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final controller = Get.put(LoginController());
  final auth = Get.put(AuthController());
  final _formKey = GlobalKey<FormState>();
  bool isTooglePassword = false;
  var errorEmail = "Email is Invalid";
  var passwordEmail = "Password is required above 6 charater";
  var emailInvalid = false;
  var passwordInvalid = false;

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: controller.email,
                decoration: InputDecoration(
                    errorText: emailInvalid ? errorEmail : null,
                    labelStyle: textSmallQuicksan,
                    prefixIcon: const Icon(Icons.person_outline_outlined),
                    labelText: tEmail,
                    border: const OutlineInputBorder()),
              ),
              const SizedBox(
                height: sButtonHeight,
              ),
              TextFormField(
                obscureText: !isTooglePassword,
                controller: controller.password,
                decoration: InputDecoration(
                    errorText: passwordInvalid ? passwordEmail : null,
                    labelStyle: textSmallQuicksan,
                    prefixIcon: const Icon(Icons.fingerprint),
                    labelText: tPassword,
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                        onPressed: toggleShowPass,
                        icon: Icon(isTooglePassword
                            ? Icons.visibility_off
                            : Icons.visibility_rounded))),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                    onPressed: () {
                      ForgetPasswordScreen.buildShowModalBottomSheet(context);
                    },
                    child: Text(
                      tForgot,
                      style: textSmallQuicksanLink,
                    )),
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
                      checkValidator();
                      if (emailInvalid == false && passwordInvalid == false) {
                        LoginController.instance.loginUser(
                            controller.email.text.trim(),
                            controller.password.text.trim());
                        // auth.sendEmail("TestDaar", 'HAEN', "TEST Email",
                        //     "hoangchienpro195@gmail.com");

                        controller.email.clear();
                        controller.password.clear();
                      }
                    },
                    child: Text(
                      tButtonLogin.toUpperCase(),
                      style: textSmallQuicksanWhite,
                    )),
              ),
              const SizedBox(
                height: sButtonHeight,
              ),
              // SizedBox(
              //   width: double.infinity,
              //   child: ElevatedButton(
              //       style: ElevatedButton.styleFrom(
              //           elevation: 0,
              //           shape: RoundedRectangleBorder(
              //             borderRadius: BorderRadius.circular(5.0),
              //             side: BorderSide(color: bgBlack, width: 5.0),
              //           ),
              //           foregroundColor: bgWhite,
              //           backgroundColor: bgBlack,
              //           padding: const EdgeInsets.symmetric(
              //               vertical: sButtonHeight)),
              //       onPressed: () {
              //         // auth.sendEmail("TestDaar", 'HAEN', "TEST Email",
              //         //     "hoangchienpro195@gmail.com");
              //         sendNotificationToUser(
              //             "dxMrcNuAQqaEQbXPJriOZN:APA91bFZLpcvLASqpHCYInfRvWWVNxCleJqCm3-STdGNFnDhqqK2nETdvHuW_Su0bBTV9YMW4WW75IbdVoXw85_Jttd6bgt9PmTMRcgGwprQ_u3Gh8rq0BGyk2p6bv7ARffgljhrSvnv",
              //             "Hello",
              //             "Test Notificarion");
              //       },
              //       child: Text(
              //         "TEST FCM".toUpperCase(),
              //         style: textSmallQuicksanWhite,
              //       )),
              // )
            ],
          ),
        ));
  }

  void toggleShowPass() {
    setState(() {
      isTooglePassword = !isTooglePassword;
    });
  }

  void checkValidator() {
    setState(() {
      if (controller.email.text.length < 6 ||
          !controller.email.text.contains("@")) {
        emailInvalid = true;
      } else {
        emailInvalid = false;
      }

      if (controller.password.text.length < 6) {
        passwordInvalid = true;
      } else {
        passwordInvalid = false;
      }
    });
  }

  void sendNotificationToUser(String userToken, String notificationTitle,
      String notificationBody) async {
    const String serverKey =
        'AAAAAQaiVfI:APA91bGn_dXpSEwAU7qg4WXV54tdS15B_LcFRN5ubCnLkcijDOzXHJRVfcnO0GNs_kiSZahvjVuAe64VwT5rQQVK0GcJHhjq2RaegF7NXK-EUChoqIgPOe9_yPzEsSxsn9Z9CDmH1KOj';
    const String fcmEndpoint = 'https://fcm.googleapis.com/fcm/send';

    Map<String, dynamic> notificationData = {
      'to': userToken,
      'notification': {
        'title': notificationTitle,
        'body': notificationBody,
        'click_action': 'FLUTTER_NOTIFICATION_CLICK',
      },
    };

    final response = await http.post(
      Uri.parse(fcmEndpoint),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverKey',
      },
      body: jsonEncode(notificationData),
    );

    if (response.statusCode == 200) {
      print('Notification sent successfully');
    } else {
      print('Failed to send notification. Error: ${response.reasonPhrase}');
    }
  }
}
