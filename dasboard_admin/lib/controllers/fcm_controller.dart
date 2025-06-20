// ignore_for_file: prefer_const_declarations, avoid_print

import 'dart:convert';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FirebaseMessagingService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<String?> getDeviceToken() async {
    return await _firebaseMessaging.getToken();
  }

  Future<void> initializeFirebaseMessaging() async {
    FirebaseMessaging.onMessage.listen(_handleMessage);
    FirebaseMessaging.onBackgroundMessage(_handleBackgroundMessage);
    await _firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  void _handleMessage(RemoteMessage message) {
    print('Received message: ${message.notification?.title}');
    // Hiển thị thông báo hoặc thực hiện hành động cần thiết
    String title = message.notification?.title ?? '';
    String body = message.notification?.body ?? '';
    print('Title: $title');
    print('Body: $body');
    AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: 123,
            channelKey: "notification_chanel",
            color: Colors.white,
            title: title,
            body: body,
            category: NotificationCategory.Call,
            wakeUpScreen: true,
            fullScreenIntent: true,
            autoDismissible: false,
            notificationLayout: NotificationLayout.Default,
            backgroundColor: Colors.orange),
        actionButtons: [
          NotificationActionButton(
              key: "ACCEPT",
              label: "ACCEPT NOTIFICATION",
              color: Colors.green,
              autoDismissible: true),
          // NotificationActionButton(
          //     key: "REJECT",
          //     label: "REJECT NOTIFICATION",
          //     color: Colors.green,
          //     autoDismissible: true)
        ]);
  }

  Future<void> _handleBackgroundMessage(RemoteMessage message) async {
    final notification = message.notification;
    if (notification != null) {
      final title = notification.title;
      final body = notification.body;

      // Tạo thông báo và hiển thị nó cho người dùng
      final androidPlatformChannelSpecifics = const AndroidNotificationDetails(
        'your_channel_id',
        'your_channel_name',
        importance: Importance.max,
        priority: Priority.high,
      );
      final platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics);
      await FlutterLocalNotificationsPlugin().show(
        0,
        title,
        body,
        platformChannelSpecifics,
        payload: 'your_notification_payload',
      );
    }
  }

  void sendNotificationToUser(String userToken, String notificationTitle,
      String notificationBody) async {
    final String serverKey =
        'AAAAAQaiVfI:APA91bGn_dXpSEwAU7qg4WXV54tdS15B_LcFRN5ubCnLkcijDOzXHJRVfcnO0GNs_kiSZahvjVuAe64VwT5rQQVK0GcJHhjq2RaegF7NXK-EUChoqIgPOe9_yPzEsSxsn9Z9CDmH1KOj';
    final String fcmEndpoint = 'https://fcm.googleapis.com/fcm/send';

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
