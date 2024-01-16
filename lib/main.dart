import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hotel_kitchen_management/screen/admin/order.dart';
import 'package:hotel_kitchen_management/screen/notification/initialize_notification.dart';
import 'package:hotel_kitchen_management/screen/utils/notification_service.dart';
import 'firebase_options.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey();
final NotificationService notificationService = NotificationService();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await notificationService.init(
      onDidReceiveNotificationResponse: _onDidReceiveNotificationResponse);
  runApp(InitializeNotification(
    notificationService: notificationService,
  ));
}

_onDidReceiveNotificationResponse(NotificationResponse details) {
  String? payload = details.payload;
  if (payload != null && payload.isNotEmpty) {
    navigatorKey.currentState?.push(
      MaterialPageRoute(
        builder: (context) => const OrderPage(),
      ),
    );
  }
}
