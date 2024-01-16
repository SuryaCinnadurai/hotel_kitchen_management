// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hotel_kitchen_management/main.dart';
import 'package:hotel_kitchen_management/screen/admin/order.dart';
import 'package:hotel_kitchen_management/screen/notification/home.dart';

import 'package:hotel_kitchen_management/screen/utils/notification_service.dart';

class InitializeNotification extends StatefulWidget {
  final NotificationService notificationService;
  const InitializeNotification({Key? key, required this.notificationService})
      : super(key: key);

  @override
  InitializeNotificationState createState() => InitializeNotificationState();
}

class InitializeNotificationState extends State<InitializeNotification>
    with WidgetsBindingObserver {
  @override
  void initState() {
    _initializeNotification();
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  void _initializeNotification() async {
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) async {
      if (message != null) {
        navigatorKey.currentState?.push(
          MaterialPageRoute(
            builder: (context) => const OrderPage(),
          ),
        );
      }
    });

    // foreground notification
    FirebaseMessaging.onMessage.listen((message) {
      widget.notificationService.showNotification(message.notification!);
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const HomePage();
  }
}
