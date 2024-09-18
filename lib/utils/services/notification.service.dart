import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:guest_allow/configs/themes/main_color.dart';
import 'package:guest_allow/utils/db/user_collection.db.dart';
import 'package:guest_allow/utils/services/local_db.service.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  NotificationService() {
    _initializeNotification();
  }

  void _initializeNotification() async {
    _configureLocalTimeZone();

    await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    // Initialization settings for iOS and Android
    DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      onDidReceiveLocalNotification: _onDidReceiveLocalNotification,
    );

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    InitializationSettings initializationSettings = InitializationSettings(
      iOS: initializationSettingsIOS,
      android: initializationSettingsAndroid,
    );

    if (Platform.isAndroid) {
      flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
    } else {
      // Request permissions for iOS
      _requestIOSPermissions();
    }

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onDidReceiveNotificationResponse,
    );

    String? token = await _firebaseMessaging.getToken();

    UserLocalData? data = await LocalDbService.getUserLocalData();
    if (data != null) {
      data.fcmToken = token;
      await LocalDbService.insertUserLocalData(data);
    } else {
      UserLocalData newData = UserLocalData(
        fcmToken: token,
      );
      await LocalDbService.insertUserLocalData(newData);
    }
    // Configure Firebase Messaging
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _handleForegroundMessage(message);
      if (kDebugMode) {
        print('Remote message=$message');
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((msg) {
      // _onOpen(msg.data);
      if (kDebugMode) {
        print('data = $msg');
      }
    });
  }

  void _handleForegroundMessage(RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    if (notification != null && android != null) {
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'channel_id',
            'Guest Allow',
            color: MainColor.primary,
            playSound: true,
            icon: '@mipmap/ic_launcher',
          ),
        ),
      );
    }
  }

  Future<void> _onDidReceiveLocalNotification(
    int id,
    String? title,
    String? body,
    String? payload,
  ) async {
    // Handle the received local notification
  }

  Future<void> _onDidReceiveNotificationResponse(
      NotificationResponse response) async {
    // Handle the notification response when tapped
    final String? payload = response.payload;
    if (payload != null) {
      // Handle the notification payload
    }
  }

  void _requestIOSPermissions() {
    _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  void _configureLocalTimeZone() async {
    tz.initializeTimeZones();
    final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
    var timezone = tz.getLocation(currentTimeZone);
    tz.setLocalLocation(timezone);
  }
}
