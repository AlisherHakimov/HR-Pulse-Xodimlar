import 'dart:convert';
import 'dart:developer';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hr_plus/core/core.dart';
import 'package:hr_plus/firebase_options.dart';
import 'package:hr_plus/main.dart';
import 'package:hr_plus/presentation/notifications/pages/notifications_page.dart';

int uuidToInt(String uuid) => uuid.hashCode.abs() % 2147483647;

class NotificationService {
  static final _firebaseMessaging = FirebaseMessaging.instance;
  static final _localNotifications = FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    final settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: false,
      criticalAlert: true,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      await _initLocalNotifications();
      _listenToMessages();
    } else {
      log('Notifications permission denied');
    }
  }

  static Future<String?> getFcmToken() async {
    try {
      final token = await _firebaseMessaging.getToken();
      log("Device token: $token");
      return token;
    } catch (e) {
      log("Failed to get token: $e");
      return null;
    }
  }

  static Future<void> _initLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = DarwinInitializationSettings();
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: onNotificationTap,
      onDidReceiveBackgroundNotificationResponse: onNotificationTap,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();
  }

  static void _listenToMessages() {
    FirebaseMessaging.onMessage.listen(showNotification);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleNavigation);

    _firebaseMessaging.getInitialMessage().then((message) {
      if (message != null) _handleNavigation(message);
    });
  }

  static Future<void> showNotification(RemoteMessage message) async {
    try {
      const channel = AndroidNotificationChannel(
        'high_importance_channel',
        'High Importance Notifications',
        description: 'This channel is used for important notifications.',
        importance: Importance.max,
      );

      await _localNotifications
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.createNotificationChannel(channel);

      final notificationId = uuidToInt(
        message.data['id'] ?? DateTime.now().toString(),
      );
      final payload = jsonEncode(message.data);

      const details = NotificationDetails(
        android: AndroidNotificationDetails(
          'high_importance_channel',
          'High Importance Notifications',
          channelDescription: 'Used for important notifications.',
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
          enableVibration: true,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      );

      await _localNotifications.show(
        notificationId,
        message.notification?.title ?? 'Notification',
        message.notification?.body ?? 'You have a new notification',
        details,
        payload: payload,
      );
    } catch (e, st) {
      log('Error showing notification: $e\n$st');
    }
  }

  static void onNotificationTap(NotificationResponse response) {
    final payload = response.payload;
    // Map<String, dynamic> data = jsonDecode(payload ?? '');
    // final type = data['target_object'];

    if (payload != null && payload.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _navigateTo());
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) => _navigateToDefault());
    }
  }

  static void _handleNavigation(RemoteMessage message) {
    try {
      final type = message.data['choice'] ?? message.data['type'];
      final comeFrom = message.data['come_from'];

      dynamic item;
      if (comeFrom != null && comeFrom.isNotEmpty) {
        try {
          item = jsonDecode(comeFrom); // agar JSON bo‘lsa
        } catch (_) {
          item = comeFrom; // oddiy string bo‘lsa
        }
      }

      if (type != null && type.isNotEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) => _navigateTo());
      } else {
        WidgetsBinding.instance.addPostFrameCallback(
          (_) => _navigateToDefault(),
        );
      }
    } catch (e, st) {
      log("❌ Navigation error: $e\n$st");
      WidgetsBinding.instance.addPostFrameCallback((_) => _navigateToDefault());
    }
  }

  static void _navigateTo() async {
    final context = navigatorKey.currentState?.context;
    if (context == null) return;

    await Future.delayed(Duration(milliseconds: 1500)).then((val) {
      _navigateToDefault();
    });

    // switch (type) {
    //   case NotificationType.TeacherFinance:
    //     if (item != null) {
    //       print("+++++> kelgan item => $item");
    //       final model = ResultNotificationModel.fromJson(item);
    //       context.push(ResultDetailPage(model: ResultModel()));
    //     } else {
    //       _navigateToDefault();
    //     }
    //     break;
    //
    //   case NotificationType.Examination:
    //     print("+++++> kelgan item => $item");
    //     context.push(TestsScreen());
    //     break;
    //
    //   case NotificationType.Shopping:
    //   case NotificationType.Homework:
    //     _navigateToDefault();
    //     break;
    //   default:
    //     _navigateToDefault();
    // }
  }

  static void _navigateToDefault() {
    final context = navigatorKey.currentState?.context;
    context?.push(NotificationsPage());
  }

  static Future<void> markNotificationAsRead(String notificationId) async {
    try {
      await _localNotifications.cancel(uuidToInt(notificationId));
    } catch (e) {
      log('Error cancelling notification: $e');
    }
  }
}

@pragma('vm:entry-point')
Future<void> _backgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // await NotificationService.showNotification(message);
}
