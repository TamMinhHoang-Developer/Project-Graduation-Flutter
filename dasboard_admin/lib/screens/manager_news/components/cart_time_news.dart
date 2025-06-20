// ignore_for_file: avoid_print, avoid_unnecessary_containers

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dasboard_admin/controllers/new_controller.dart';
import 'package:dasboard_admin/modals/news_modal.dart';
import 'package:dasboard_admin/modals/users_modal.dart';
import 'package:dasboard_admin/ulti/styles/main_styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CartItemNews extends StatefulWidget {
  const CartItemNews({super.key, required this.user});
  final Users user;

  @override
  State<CartItemNews> createState() => _CartItemNewsState();
}

class _CartItemNewsState extends State<CartItemNews> {
  final cu = Get.put(ManageNewsController());
  var userId = "";

  @override
  Widget build(BuildContext context) {
    if (FirebaseAuth.instance.currentUser != null) {
      userId = FirebaseAuth.instance.currentUser!.uid;
    } else {
      userId = "";
    }
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 40,
                      child: widget.user.Avatar!.isNotEmpty
                          ? Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border:
                                    Border.all(width: 2, color: Colors.black),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: CachedNetworkImage(
                                  imageUrl: widget.user.Avatar!,
                                  placeholder: (context, url) =>
                                      const CircularProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                              ),
                            )
                          : Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.greenAccent.withOpacity(0.4),
                              ),
                              width: 40,
                              height: 40,
                            ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.user.Name ?? '',
                          style: textNormalLatoBold,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          widget.user.Email ?? '',
                          style: textNormalQuicksanGrey,
                        ),
                      ],
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    Get.dialog(MyDialog(
                      user: widget.user,
                    ));
                    // if (widget.user.Token!.isNotEmpty) {
                    //   sendNotificationToUser(widget.user.Token!,
                    //       "1 Notification From Admin", "Open Amager to now!");
                    // }
                    // final newsw = News(
                    //     Id: "",
                    //     isRead: false,
                    //     CreateAt: convertInputDateTimetoNumber(
                    //         DateTime.now().toString()),
                    //     UserCreate: "Admin",
                    //     IdUserCreate: userId.toString());
                    // cu.addNews(newsw, widget.user.Id!);
                  },
                  child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Colors.greenAccent.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(50)),
                      child: const Icon(Icons.send_to_mobile_outlined)),
                )
              ],
            ),
          ),
          Divider(
            height: 2,
            color: Colors.black.withOpacity(0.5),
          )
        ],
      ),
    );
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
    Get.snackbar('Success', "Send Notification Success",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.greenAccent.withOpacity(0.1),
        colorText: Colors.black);
  } else {
    print('Failed to send notification. Error: ${response.reasonPhrase}');
  }
}

convertInputDateTimetoNumber(String tiem) {
  String activeDate = tiem; // giá trị ngày tháng dưới dạng chuỗi
  DateTime dateTime =
      DateTime.parse(activeDate); // chuyển đổi thành đối tượng DateTime
  int timestamp = dateTime.millisecondsSinceEpoch; // chuyển đổi thành số
  return timestamp;
}

class MyDialog extends StatefulWidget {
  const MyDialog({super.key, required this.user});
  final Users user;
  @override
  State<MyDialog> createState() => _MyDialogState();
}

class _MyDialogState extends State<MyDialog> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController messageController = TextEditingController();
  final cu = Get.put(ManageNewsController());
  var userId = "";
  @override
  Widget build(BuildContext context) {
    if (FirebaseAuth.instance.currentUser != null) {
      userId = FirebaseAuth.instance.currentUser!.uid;
    } else {
      userId = "";
    }
    return AlertDialog(
      title: const Text('Add Item'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 16),
          TextField(
            controller: titleController,
            decoration: const InputDecoration(
              labelText: 'Title',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: messageController,
            decoration: const InputDecoration(
              labelText: 'Message',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            String title = titleController.text;
            String message = messageController.text;

            // Xử lý khi nhấn nút "Add" trong dialog
            if (title.isNotEmpty && message.isNotEmpty) {
              if (widget.user.Token!.isNotEmpty) {
                sendNotificationToUser(widget.user.Token!, "1 News From Admin",
                    "Open Amager or News to now!");
              }
              final newsw = News(
                  Id: "",
                  isRead: false,
                  CreateAt:
                      convertInputDateTimetoNumber(DateTime.now().toString()),
                  UserCreate: "Admin",
                  IdUserCreate: userId.toString(),
                  Message: message,
                  Title: title);
              cu.addNews(newsw, widget.user.Id!);
              Get.back();
            } else {
              // Hiển thị thông báo lỗi
              Get.snackbar('Error', 'Please enter title and message',
                  snackPosition: SnackPosition.BOTTOM);
            }
          },
          child: const Text('Add'),
        ),
        TextButton(
          onPressed: () {
            // Xử lý khi nhấn nút "Cancel" trong dialog
            Get.back();
          },
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}
