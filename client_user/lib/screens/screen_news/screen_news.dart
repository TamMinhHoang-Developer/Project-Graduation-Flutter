// ignore_for_file: avoid_unnecessary_containers, sized_box_for_whitespace, avoid_print
import 'package:client_user/controller/manage_news.dart';
import 'package:client_user/modal/news.dart';
import 'package:client_user/repository/auth_repository/auth_repository.dart';
import 'package:client_user/uilt/style/text_style/text_style.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ScreenNews extends StatefulWidget {
  const ScreenNews({super.key});

  @override
  State<ScreenNews> createState() => _ScreenNewsState();
}

class _ScreenNewsState extends State<ScreenNews> {
  final controller = Get.put(ManageNewsController());
  var userId = "";

  @override
  Widget build(BuildContext context) {
    if (FirebaseAuth.instance.currentUser != null) {
      userId = FirebaseAuth.instance.currentUser!.uid;
    } else {
      userId = "";
    }
    controller.getListNews(userId);
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
                  onPressed: () => showDialogWithCustomUI(
                    context,
                  ),
                  icon: const Icon(Icons.add),
                  color: Colors.black,
                ),
              ),
            ]),
        body: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            height: 600,
            padding: const EdgeInsets.all(20),
            child: Obx(
              () => GroupedListView<NewsSnapshot, String>(
                elements:
                    controller.newListGroup.expand((group) => group).toList(),
                groupBy: (newsSnapshot) =>
                    newsSnapshot.orderDetail!.formattedDate,
                groupSeparatorBuilder: (String groupByValue) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      groupByValue,
                      style: textNormalQuicksanBoldGray,
                      textAlign: TextAlign.center,
                    ),
                  );
                },
                itemBuilder: (context, newsSnapshot) {
                  final news = newsSnapshot.orderDetail!;
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
                                  color:
                                      const Color(0xFFA3014F).withOpacity(0.05),
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
                          child: Container(
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      news.Title!,
                                      style: textNormalQuicksanBold,
                                    ),
                                    Text(
                                      DateFormat.jm().format(
                                          DateTime.fromMillisecondsSinceEpoch(
                                              news.CreateAt!)),
                                      style: textSmailQuicksanBoldGray,
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
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

void showDialogWithCustomUI(BuildContext context) {
  final TextEditingController txtTitle = TextEditingController();
  final TextEditingController txtMess = TextEditingController();
  var userId = "";
  if (FirebaseAuth.instance.currentUser != null) {
    userId = FirebaseAuth.instance.currentUser!.uid;
  } else {
    userId = "";
  }
  final controller = Get.put(ManageNewsController());
  final user = Get.put(AuthenticationRepository());
  user.bindingUser(userId);
  user.bindingAdminUser();

  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(16.0), // Đặt border radius tại đây
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
                            borderRadius: BorderRadius.circular(50)),
                        child: const Icon(Icons.close)),
                  )
                ],
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                controller: txtTitle,
                decoration: InputDecoration(
                    labelStyle: textSmallQuicksan,
                    prefixIcon: const Icon(Icons.abc),
                    labelText: "Title",
                    border: const OutlineInputBorder()),
              ),
              const SizedBox(height: 10.0),
              TextFormField(
                controller: txtMess,
                decoration: InputDecoration(
                    labelStyle: textSmallQuicksan,
                    prefixIcon: const Icon(Icons.message),
                    labelText: "Message",
                    border: const OutlineInputBorder()),
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
                        borderRadius: BorderRadius.circular(
                            8.0), // Góc bo tròn với giá trị 8.0
                      ),
                    ),
                    child: Text(
                      "Cancel",
                      style: textNormalQuicksanBoldGray,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(); // Đóng dialog
                    },
                  )),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              8.0), // Góc bo tròn với giá trị 8.0
                        )),
                    child: Text(
                      "Confirm",
                      style: textNormalQuicksanBoldWhite,
                    ),
                    onPressed: () {
                      final news = News(
                          Id: "",
                          isRead: false,
                          Title: txtTitle.text,
                          Message: txtMess.text,
                          IdUserCreate: user.users.value.user!.Id,
                          UserCreate: user.users.value.user!.Name,
                          CreateAt: convertInputDateTimetoNumber(
                              DateTime.now().toString()));
                      if (txtTitle.text.isNotEmpty && txtMess.text.isNotEmpty) {
                        controller.addNews(news);
                        sendNotificationToUser(
                            user.userAdmin.value.user!.Token!,
                            "Notification",
                            "1 News Form ${user.users.value.user!.Email}");
                      }
                      Navigator.of(context).pop();
                    },
                  )),
                ],
              ),
            ],
          ),
        ),
      );
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
