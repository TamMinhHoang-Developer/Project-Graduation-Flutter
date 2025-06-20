// ignore_for_file: avoid_print, avoid_unnecessary_containers

import 'package:dasboard_admin/controllers/total_controller.dart';
import 'package:dasboard_admin/controllers/waltinguser_controller.dart';
import 'package:dasboard_admin/ulti/styles/main_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fswitch_nullsafety/fswitch_nullsafety.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mailer/mailer.dart';
import 'dart:convert';

import 'package:mailer/smtp_server/gmail.dart';
import 'package:mustache_template/mustache_template.dart';

class ScreenUserWalting extends StatefulWidget {
  const ScreenUserWalting({super.key});

  @override
  State<ScreenUserWalting> createState() => _ScreenUserWaltingState();
}

class _ScreenUserWaltingState extends State<ScreenUserWalting> {
  final cu = Get.put(WaltingUserController());
  final total = Get.put(TotalController());

  final TextEditingController _searchController = TextEditingController();
  bool _isClearVisible = false;
  bool isChecked = false;

  void _onSearchTextChanged(String value) {
    setState(() {
      _isClearVisible = value.isNotEmpty;
    });

    if (value.isNotEmpty) {
      cu.searchUser(value);
    } else {
      cu.getListUser();
    }
  }

  void _onClearPressed() {
    setState(() {
      _searchController.clear();
      _isClearVisible = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // cu.getUsersStatus(false);
    Size size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          ),
          title: Text(
            "Manager Walting",
            style: textAppKanit,
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      color: Colors.black,
                      width: 2,
                    ),
                  ),
                  padding: const EdgeInsets.only(
                      top: 2, bottom: 2, right: 10, left: 10),
                  child: Row(
                    children: [
                      const Icon(Icons.search),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          onChanged: _onSearchTextChanged,
                          decoration: const InputDecoration(
                              hintText: 'Search...', border: InputBorder.none),
                        ),
                      ),
                      Visibility(
                        visible: _isClearVisible,
                        child: IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: _onClearPressed,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Stack(
                  children: [
                    SizedBox(
                      height: size.height - 200,
                      width: size.width - 40,
                      child: Obx(
                        () {
                          return ListView.separated(
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemBuilder: (context, index) => Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(15),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                cu.listUsers[index].user!.Name!,
                                                style: textNormalLatoBold,
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                cu.listUsers[index].user!
                                                    .Email!,
                                                style: textNormalQuicksanGrey,
                                              ),
                                            ],
                                          ),
                                        ),
                                        FSwitch(
                                          open: false,
                                          onChanged: (v) {
                                            // Update Status User
                                            cu.updateUserStatus(
                                                cu.listUsers[index].user!.Id!);

                                            // Send Notifications To User
                                            total.sendNotificationToUser(
                                                cu.listUsers[index].user!
                                                    .Token!,
                                                "Access Pemission",
                                                "Your Account Can Access In Amager");
                                            sendEmailActive(
                                                cu.listUsers[index].user!
                                                    .Email!,
                                                cu.listUsers[index].user!.Name!,
                                                cu.listUsers[index].user!
                                                    .Name!);
                                            Get.snackbar('Success',
                                                "Access Account To Success",
                                                snackPosition:
                                                    SnackPosition.BOTTOM,
                                                backgroundColor: Colors
                                                    .redAccent
                                                    .withOpacity(0.1),
                                                colorText: Colors.black);
                                          },
                                          closeChild: const Icon(
                                            Icons.close,
                                            size: 16,
                                            color: Colors.white,
                                          ),
                                          openChild: const Icon(
                                            Icons.check,
                                            size: 16,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Divider(
                                    height: 2,
                                    color: Colors.black.withOpacity(0.5),
                                  )
                                ],
                              ),
                            ),

                            // ignore: invalid_use_of_protected_member
                            itemCount: cu.listUsers.value.length,
                            padding: const EdgeInsets.only(bottom: 50 + 16),
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 0),
                          );
                        },
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
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
      Get.snackbar('Success', "Notification Successful",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.greenAccent.withOpacity(0.1),
          colorText: Colors.black);
    } else {
      print('Failed to send notification. Error: ${response.reasonPhrase}');
    }
  }

  String renderTemplate(String template, Map<String, dynamic> variables) {
    final templateRenderer = Template(template);
    return templateRenderer.renderString(variables);
  }

  Future sendEmailActive(String userEmail, username, usersendname) async {
    print("EMAIL");
    String username = "tam.hm.61cntt@ntu.edu.vn";
    String password = "hoangminhtam123pro";

    final templateContent =
        await rootBundle.loadString('assets/temp/mail_active.html');

    final variables = {
      'username': usersendname, // Ví dụ: Biến tùy chỉnh 'username'
      'useremail': userEmail,
      'usernamesen': usersendname
    };

    final emailContent = renderTemplate(templateContent, variables);

    final stmpServer = gmail(username, password);

    final message = Message()
      ..from = Address(username, 'SYSTEM')
      ..recipients.add(userEmail)
      ..subject = 'Active Account Success'
      ..html = emailContent;

    try {
      final sendReport = await send(message, stmpServer);
      print('Message sent: $sendReport');
    } on MailerException catch (e) {
      print('Message not sent. $e');
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    }
  }
}
