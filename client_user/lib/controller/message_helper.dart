// ignore_for_file: avoid_print, non_constant_identifier_names, use_build_context_synchronously

import 'dart:convert';

import 'package:client_user/modal/message.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class MessageHelper {
  static String key_message_list = "fcm_message";
  static String key_count_message = "count_message";

  static Future<int> getCountMessage() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return (sharedPreferences.getInt(key_count_message) ?? 0);
  }

  static Future<int> getLengthList() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return (sharedPreferences.getStringList(key_message_list)!.length);
  }

  static Future<bool> writeMessage(MyNotificationMessage nofication) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    List<String>? strMessage =
        sharedPreferences.getStringList(key_message_list);
    int count = (sharedPreferences.getInt(key_count_message) ?? 0) + 1;
    FlutterAppBadger.updateBadgeCount(count);
    await sharedPreferences.setInt(key_count_message, count);
    if (strMessage != null) {
      strMessage.add(jsonEncode(nofication));
      return sharedPreferences.setStringList(key_message_list, strMessage);
    } else {
      return sharedPreferences
          .setStringList(key_message_list, [jsonEncode(nofication)]);
    }
  }

  static Future<List<MyNotificationMessage>?> readMessage() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    List<String>? strMessage =
        sharedPreferences.getStringList(key_message_list);
    FlutterAppBadger.removeBadge();
    sharedPreferences.remove(key_message_list);
    sharedPreferences.remove(key_count_message);

    print("Số lượng TN ${strMessage?.length}");
    return strMessage
        ?.map((e) => MyNotificationMessage.fromJson(jsonDecode(e)))
        .toList();
  }

  static Future<void> fcm_BackgroundHandler(RemoteMessage message) async {
    print("Hadler Message Background ${message.messageId}");
  }

  static void fcm_ForegroundHandler(
      {required RemoteMessage message,
      required BuildContext context,
      void Function(BuildContext context, RemoteMessage message)?
          messageHandler}) {
    print(message.notification?.title);
    print(message.notification?.body);
    print(message.from);
    print(message.sentTime.toString());

    final data = message.data;
    final imageUrl = data['image'];
    print(message.data);

    writeMessage(MyNotificationMessage(
            title: message.notification?.title,
            body: message.notification?.body,
            from: message.from,
            time: message.sentTime.toString(),
            image: imageUrl))
        .whenComplete(() {
      if (messageHandler != null) {
        messageHandler(context, message);
      }
    });

    print("Message in Forceground");
  }

  static void fcmOpenMessageHandler(
      {required RemoteMessage message,
      required BuildContext context,
      void Function(BuildContext context, RemoteMessage message)?
          messageHandler}) {
    print("Open fcm messgae");
    if (messageHandler != null) {
      messageHandler(context, message);
    }
  }

  static fcm_OpenAllMessageHandler(
      {required BuildContext context,
      void Function(BuildContext context, List<MyNotificationMessage>)?
          messageHandler}) async {
    List<MyNotificationMessage>? list = await readMessage();
    if (messageHandler != null) {
      messageHandler(context, list!);
    }
  }

  static String constuctorFCMPayload(
      {required content, required String to, required bool topic}) {
    String address = to;
    if (topic) {
      address = '/topics/$to';
    }
    return jsonEncode({
      // 'token': token,
      'to': address,
      'priority': 'high',
      'data': <String, dynamic>{
        'title': "Hello Futter",
        'body': content,
        "sound": 'true'
      }
    });
  }

  static Future<Response> sendPushMessageByHTTP_Post(
      {String? message, String? token, String? authorization_key}) async {
    if (token == null) {
      print("KO THE SEND FCM. NO TOKEN");
      return Future.error("No Token");
    }
    try {
      Response response =
          (await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
              headers: <String, String>{
                'Content-Type': 'application/json',
                'Authorization': 'key=${authorization_key!}',
              },
              body: message!)) as Response;
      print("FCM REQUEST SEND");
      return response;
    } catch (e) {
      print(e);
      return Future.error(e);
    }
  }
}
