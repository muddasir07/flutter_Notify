import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static Future<String> getFcmToken() async {
    FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
    firebaseMessaging.requestPermission();
    String? fcmToken; // Change here
    await firebaseMessaging.getToken().then((token) {
      fcmToken = token;
    });
    return fcmToken.toString();
  }

  static final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  static void initializeLocalNotification() {
    const InitializationSettings initializationSettings =
        InitializationSettings(android: AndroidInitializationSettings("@mipmap/ic_launcher"), iOS: DarwinInitializationSettings());

    _notificationsPlugin.initialize(initializationSettings, onDidReceiveNotificationResponse: (data) async {});
  }

  static void display(RemoteMessage message) async {
    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      const NotificationDetails notificationDetails = NotificationDetails(
          android: AndroidNotificationDetails(
            "notificationapp", // this cannel name should be same as in AndroidManifest.xml file
            "Notification App channel",
            channelDescription: "Channel to Send App Notifications",
            importance: Importance.max,
            priority: Priority.high,
            playSound: true,
          ),
          iOS: DarwinNotificationDetails(
            presentSound: true,
            presentBadge: true,
            presentAlert: true,
          ));

      await _notificationsPlugin.show(
        id,
        message.notification!.title,
        message.notification!.body,
        notificationDetails,
      );
    } on Exception {
      debugPrint("Exceptions Occured");
    }
  }
}
