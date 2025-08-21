import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();

  // Initialize the notification service
  Future<void> initialize() async {
    try {
      // Request notification permissions
      await _requestPermissions();
      
      // Initialize local notifications
      await _initializeLocalNotifications();
      
    } catch (e) {
      // Handle error silently or log to a crash reporting service
    }
  }

  // Request notification permissions
  Future<void> _requestPermissions() async {
    try {
      // Request system notification permissions (Android 13+)
      if (Platform.isAndroid) {
        await Permission.notification.request();
      }
    } catch (e) {
      // Handle error silently or log to a crash reporting service
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

    } catch (e) {
      // Handle error silently or log to a crash reporting service
    }
  }

  // Handle notification tap
  void _onNotificationTapped(NotificationResponse response) {
    // Handle notification tap logic, e.g., navigate to a specific screen
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