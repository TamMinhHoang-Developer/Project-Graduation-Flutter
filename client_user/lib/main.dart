// ignore_for_file: avoid_print

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:client_user/controller/fcm_controller.dart';
import 'package:client_user/controller/message_helper.dart';
import 'package:client_user/screens/init_firebase/screen_err404.dart';
import 'package:client_user/screens/init_firebase/screen_inprogress.dart';
import 'package:client_user/screens/welcome/screen_welcome.dart';
import 'package:client_user/shared/connect_firebase.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await GetStorage.init();

  // FirebaseMessagingService firebaseMessagingService =
  //     FirebaseMessagingService();
  // await firebaseMessagingService.initializeFirebaseMessaging();
  // await FirebaseMessaging.instance.setAutoInitEnabled(true);

  // AwesomeNotifications().initialize(null, [
  //   NotificationChannel(
  //       channelKey: "notification_chanel",
  //       channelName: "Notification Chanel",
  //       channelDescription: "Chanel is Notification",
  //       defaultColor: Colors.redAccent,
  //       ledColor: Colors.white,
  //       importance: NotificationImportance.Max,
  //       channelShowBadge: true,
  //       locked: true,
  //       defaultRingtoneType: DefaultRingtoneType.Notification)
  // ]);

  // FirebaseMessaging messaging = FirebaseMessaging.instance;

  // // Grand Permission
  // NotificationSettings settings = await messaging.requestPermission(
  //   alert: true,
  //   announcement: false,
  //   badge: true,
  //   carPlay: false,
  //   criticalAlert: false,
  //   provisional: false,
  //   sound: true,
  // );

  // print('User granted permission: ${settings.authorizationStatus}');
  // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //   print('Got a message whilst in the foreground!');
  //   print('Message data: ${message.data}');

  //   if (message.notification != null) {
  //     print('Message also contained a notification: ${message.notification}');
  //   }
  // });

  // // Test Token
  // final fcmToken = await FirebaseMessaging.instance.getToken();
  // print("Token: $fcmToken ==========================");

  FirebaseMessaging.onBackgroundMessage(MessageHelper.fcm_BackgroundHandler);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true, badge: true, sound: true);

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  print('User granted permission: ${settings.authorizationStatus}');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyFirebaseConnect(
        builder: (context) {
          return const GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: "GetX Firebase App",
            home: ScreenWelcome(),
            transitionDuration: Duration(milliseconds: 500),
          );
        },
        builderConnect: (BuildContext context) {
          return const MaterialApp(
            debugShowCheckedModeBanner: false,
            title: "GetX Firebase App",
            home: ScreenInprogress(),
          );
        },
        builderError: (context) {
          return const MaterialApp(
            debugShowCheckedModeBanner: false,
            title: "GetX Firebase App",
            home: ScreenErr404(),
          );
        },
      ),
    );
  }
}

Future<bool?> showExitConfirmationDialog(BuildContext context) async {
  return await showDialog<bool?>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Confirm Exit'),
          content: const Text('Are you sure you want to exit?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false), // Không thoát
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true), // Thoát
              child: const Text('Exit'),
            ),
          ],
        ),
      ) ??
      false; // Mặc định không thoát
}
