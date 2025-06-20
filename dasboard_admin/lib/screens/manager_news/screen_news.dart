// ignore_for_file: avoid_unnecessary_containers, avoid_print, unnecessary_null_comparison, library_private_types_in_public_api

import 'dart:convert';

import 'package:dasboard_admin/controllers/login_controller.dart';
import 'package:dasboard_admin/controllers/new_controller.dart';
import 'package:dasboard_admin/controllers/total_controller.dart';
import 'package:dasboard_admin/modals/news_modal.dart';
import 'package:dasboard_admin/modals/users_modal.dart';
import 'package:dasboard_admin/screens/manager_news/screen_add_news.dart';
import 'package:dasboard_admin/ulti/styles/main_styles.dart';
import 'package:dropdown_input/dropdown_input.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class ScreenNews extends StatefulWidget {
  const ScreenNews({super.key});

  @override
  State<ScreenNews> createState() => _ScreenNewsState();
}

class _ScreenNewsState extends State<ScreenNews> {
  final controller = Get.put(ManageNewsController());
  final user = Get.put(AuthController());
  var userId = "";

  @override
  Widget build(BuildContext context) {
    if (FirebaseAuth.instance.currentUser != null) {
      userId = FirebaseAuth.instance.currentUser!.uid;
    } else {
      userId = "";
    }
    controller.getListNews();
    controller.getListNewsGroup(userId);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            leading: IconButton(
              onPressed: () => Get.back(),
              icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
            ),
            title: Text(
              "News",
              style: textAppKanit,
            ),
            elevation: 0,
            backgroundColor: Colors.transparent,
            actions: [
              TextButton(
                  onPressed: () => controller.markAllRead(userId),
                  child: Text(
                    "Mark all as read",
                    style: textNormalQuicksanBold,
                  )),
              Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(10)),
                child: IconButton(
                  onPressed: () => Get.to(() => const ScreenAddNews()),
                  icon: const Icon(Icons.add),
                  color: Colors.black,
                ),
              ),
            ]),
        body: SingleChildScrollView(
          child: Obx(() => Container(
                width: double.infinity,
                height: 700,
                padding: const EdgeInsets.all(20),
                child: GroupedListView<NewsSnapshot, String>(
                  elements:
                      controller.newListGroup.expand((group) => group).toList(),
                  groupBy: (newsSnapshot) =>
                      newsSnapshot.orderDetail!.formattedDate,
                  groupSeparatorBuilder: (String groupByValue) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        groupByValue,
                        style: textNormalLatoBold,
                        textAlign: TextAlign.center,
                      ),
                    );
                  },
                  itemBuilder: (context, newsSnapshot) {
                    final news = newsSnapshot.orderDetail!;
                    user.getUserById(news.IdUserCreate!);
                    return Container(
                      margin: const EdgeInsets.only(bottom: 5),
                      decoration: BoxDecoration(
                          border: news.isRead!
                              ? Border.all(
                                  width: 1, color: Colors.grey.withOpacity(0.5))
                              : Border.all(),
                          color: news.isRead!
                              ? Colors.white.withOpacity(0.5)
                              : Colors.white.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: news.isRead!
                              ? []
                              : [
                                  BoxShadow(
                                    color: const Color(0xFFA3014F)
                                        .withOpacity(0.05),
                                    offset: const Offset(0, 9),
                                    blurRadius: 30,
                                    spreadRadius: 0,
                                  ),
                                  BoxShadow(
                                      color: const Color(0xFFB2036C)
                                          .withOpacity(0.03),
                                      offset: const Offset(0, 2),
                                      blurRadius: 10,
                                      spreadRadius: 0)
                                ]),
                      padding: const EdgeInsets.all(20),
                      width: double.infinity,
                      child: Row(
                        children: [
                          Container(
                            child: const Icon(Icons.newspaper),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "From: ${user.usersClient.value.user?.Name!}",
                                      style: textNormalQuicksanBold,
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Title: ${news.Title!}",
                                      style: textNormalQuicksanBold,
                                    ),
                                    Text(
                                      DateFormat.jm().format(
                                          DateTime.fromMillisecondsSinceEpoch(
                                              news.CreateAt!)),
                                      style: textNormalKanit,
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                        child: Container(
                                            child: Text(news.Message!))),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Container(
                                      width: 30,
                                      height: 30,
                                      decoration: BoxDecoration(
                                          color: news.isRead!
                                              ? Colors.greenAccent
                                                  .withOpacity(0.5)
                                              : Colors.orangeAccent
                                                  .withOpacity(0.5),
                                          borderRadius:
                                              BorderRadius.circular(6)),
                                      child: Center(
                                          child: news.isRead!
                                              ? const Icon(
                                                  Icons.done,
                                                )
                                              : const Icon(
                                                  Icons.circle,
                                                  size: 10,
                                                )),
                                    )
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
              )),
        ),
      ),
    );
  }
}

void showDialogWithCustomUI(BuildContext context) {
  final controller = Get.put(AuthController());
  final total = Get.put(TotalController());
  total.bindingUser();
  controller.bindingAdminUser();
  // controller.getUserById(userID);

  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return CustomDialog();
    },
  );
}

convertInputDateTimetoNumber(String tiem) {
  String activeDate = tiem; // giá trị ngày tháng dưới dạng chuỗi
  DateTime dateTime =
      DateTime.parse(activeDate); // chuyển đổi thành đối tượng DateTime
  int timestamp = dateTime.millisecondsSinceEpoch; // chuyển đổi thành số
  return timestamp;
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
  } else {
    print('Failed to send notification. Error: ${response.reasonPhrase}');
  }
}

class CustomDialog extends StatefulWidget {
  const CustomDialog({super.key});

  @override
  _CustomDialogState createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> {
  final TextEditingController txtTitle = TextEditingController();
  final TextEditingController txtMess = TextEditingController();

  final controller = Get.put(AuthController());
  final total = Get.put(TotalController());

  @override
  void initState() {
    super.initState();
    total.bindingUser();
    controller.bindingAdminUser();

    if (total.users.isNotEmpty) {
      total.selectedUser.value = total.users.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Add News",
                  style: textNormalKanitBold,
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: const Icon(Icons.close),
                  ),
                ),
              ],
            ),
            DropdownButton<UserSnapshot>(
              value: total.selectedUser.value,
              icon: const Icon(Icons.arrow_downward),
              elevation: 16,
              style: const TextStyle(color: Colors.deepPurple),
              underline: Container(
                height: 2,
                color: Colors.deepPurpleAccent,
              ),
              onChanged: (UserSnapshot? value) {
                setState(() {
                  total.selectedUser.value = value ?? total.users.first;
                });
              },
              items: total.users
                  .map<DropdownMenuItem<UserSnapshot>>((UserSnapshot user) {
                return DropdownMenuItem<UserSnapshot>(
                  key: ValueKey(user.user!.Id),
                  value: user,
                  child: Text(user.user!.Email!),
                );
              }).toList(),
            ),
            const SizedBox(height: 20.0),
            TextFormField(
              controller: txtTitle,
              decoration: InputDecoration(
                labelStyle: textSmallQuicksan,
                prefixIcon: const Icon(Icons.abc),
                labelText: "Title",
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10.0),
            TextFormField(
              controller: txtMess,
              decoration: InputDecoration(
                labelStyle: textSmallQuicksan,
                prefixIcon: const Icon(Icons.message),
                labelText: "Message",
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shadowColor: Colors.white,
                      backgroundColor: Colors.grey.withOpacity(0.2),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: Text(
                      "Cancel",
                      style: textAppKanit,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(); // Đóng dialog
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: Text(
                      "Confirm",
                      style: textAppKanit,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
