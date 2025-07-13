import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import '../config/supabase_config.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();

  // Initialize the notification service
  Future<void> initialize() async {
    try {
      print('Initializing notification service...'); // Debug log
      
      // Request notification permissions
      await _requestPermissions();
      
      // Initialize local notifications
      await _initializeLocalNotifications();
      
      print('Notification service initialized successfully'); // Debug log
    } catch (e) {
      print('Error initializing notification service: $e'); // Debug log
    }
  }

  // Request notification permissions
  Future<void> _requestPermissions() async {
    try {
      // Request system notification permissions (Android 13+)
      if (Platform.isAndroid) {
        final status = await Permission.notification.request();
        print('System notification permission: $status'); // Debug log
      }
    } catch (e) {
      print('Error requesting permissions: $e'); // Debug log
    }
  }

  // Initialize local notifications
  Future<void> _initializeLocalNotifications() async {
    try {
      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      const DarwinInitializationSettings initializationSettingsIOS =
          DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

      const InitializationSettings initializationSettings =
          InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
      );

      await _localNotifications.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: _onNotificationTapped,
      );

      print('Local notifications initialized'); // Debug log
    } catch (e) {
      print('Error initializing local notifications: $e'); // Debug log
    }
  }

  // Handle notification tap
  void _onNotificationTapped(NotificationResponse response) {
    print('Local notification tapped: ${response.id}'); // Debug log
    print('Payload: ${response.payload}'); // Debug log
  }

  // Show local notification
  Future<void> showLocalNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    try {
      const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
        'sylonow_vendor_channel',
        'SyloNow Vendor Notifications',
        channelDescription: 'Notifications for SyloNow Vendor app',
        importance: Importance.high,
        priority: Priority.high,
      );

      const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const NotificationDetails notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _localNotifications.show(
        DateTime.now().millisecondsSinceEpoch.remainder(100000),
        title,
        body,
        notificationDetails,
        payload: payload,
      );

      print('Local notification shown: $title'); // Debug log
    } catch (e) {
      print('Error showing local notification: $e'); // Debug log
    }
  }

  // Send test notification
  Future<void> sendTestNotification() async {
    await showLocalNotification(
      title: 'Test Notification',
      body: 'This is a test notification from SyloNow Vendor',
      payload: 'test_payload',
    );
  }
} 