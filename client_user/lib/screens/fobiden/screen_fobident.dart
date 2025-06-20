// ignore_for_file: avoid_print

import 'package:client_user/constants/const_spacer.dart';
import 'package:client_user/constants/string_context.dart';
import 'package:client_user/constants/string_img.dart';
import 'package:client_user/controller/auth_controller.dart';
import 'package:client_user/repository/auth_repository/auth_repository.dart';
import 'package:client_user/screens/login/screen_login.dart';
import 'package:client_user/uilt/style/color/color_main.dart';
import 'package:client_user/uilt/style/text_style/text_style.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ScreenFobident extends StatefulWidget {
  const ScreenFobident({super.key});

  @override
  State<ScreenFobident> createState() => _ScreenFobidentState();
}

class _ScreenFobidentState extends State<ScreenFobident> {
  var userId = "";
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AuthenticationRepository());
    final controllerA = Get.put(AuthController());
    Size size = MediaQuery.of(context).size;

    if (FirebaseAuth.instance.currentUser != null) {
      userId = FirebaseAuth.instance.currentUser!.uid;
    } else {
      userId = "";
    }
    controller.bindingUser(userId);
    controller.bindingAdminUser();
    return SafeArea(
        child: Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Image.asset(
              iForbident,
              width: 400,
            ),
            SizedBox(
              child: Column(
                children: [
                  Text(
                    tForbidentTitle,
                    style: textBigKanit,
                  ),
                  Text(
                    tForbidentDes,
                    style: textNormalQuicksan,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    width: size.width - 80,
                    child: ElevatedButton(
                        onPressed: () {
                          Get.to(() => const ScreenLogin());
                          controller.logout();
                        },
                        style: ElevatedButton.styleFrom(
                            elevation: 0,
                            shape: const StadiumBorder(),
                            foregroundColor: bgBlack,
                            backgroundColor: padua,
                            padding: const EdgeInsets.symmetric(
                                vertical: sDashboardPadding)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const Icon(Icons.arrow_back),
                            Text(
                              tButtonFor,
                              style: textXLQuicksanBold,
                            )
                          ],
                        )),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: size.width - 80,
                    child: ElevatedButton(
                        onPressed: () {
                          DateTime tsdate = DateTime.fromMillisecondsSinceEpoch(
                              controller.users.value.user!.CreatedAt!);
                          final data = DateFormat('MMM dd, yyyy | hh:mm aaa')
                              .format(tsdate);
                          controllerA.sendEmailActive(
                              "TestDaar",
                              'HAEN',
                              "TEST Email",
                              "hoangchienpro195@gmail.com",
                              controller.users.value.user!.Email!,
                              data);

                          sendNotificationToUser(
                              controller.userAdmin.value.user!.Token!,
                              "Notification",
                              "1 News Form ${controller.users.value.user!.Email}");
                        },
                        style: ElevatedButton.styleFrom(
                            elevation: 0,
                            shape: const StadiumBorder(),
                            foregroundColor: bgBlack,
                            backgroundColor: padua,
                            padding: const EdgeInsets.symmetric(
                                vertical: sDashboardPadding)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const Icon(Icons.send),
                            Text(
                              "Send Nofication To Admin",
                              style: textXLQuicksanBold,
                            )
                          ],
                        )),
                  ),
                ],
              ),
            ),
            Text(
              tForbidentTimming,
              style: textNormalQuicksan,
            )
          ],
        ),
      ),
    ));
  }
}

void sendNotificationToUser(
    String userToken, String notificationTitle, String notificationBody) async {
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
    Get.snackbar('Success', "Send Success",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.greenAccent.withOpacity(0.1),
        colorText: Colors.white);
  } else {
    print('Failed to send notification. Error: ${response.reasonPhrase}');
    Get.snackbar('Error', "Send Error",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withOpacity(0.1),
        colorText: Colors.black);
  }
}
