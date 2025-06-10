import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import '../config/supabase_config.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();
  
  String? _fcmToken;
  String? get fcmToken => _fcmToken;

  // Initialize the notification service
  Future<void> initialize() async {
    try {
      print('Initializing notification service...'); // Debug log
      
      // Request notification permissions
      await _requestPermissions();
      
      // Initialize local notifications
      await _initializeLocalNotifications();
      
      // Get FCM token
      await _getFCMToken();
      
      // Setup message handlers
      _setupMessageHandlers();
      
      print('Notification service initialized successfully'); // Debug log
    } catch (e) {
      print('Error initializing notification service: $e'); // Debug log
    }
  }

  // Request notification permissions
  Future<void> _requestPermissions() async {
    try {
      // Request FCM permissions
      NotificationSettings settings = await _firebaseMessaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      print('FCM permission status: ${settings.authorizationStatus}'); // Debug log

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

  // Get FCM token and save to database
  Future<void> _getFCMToken() async {
    try {
      _fcmToken = await _firebaseMessaging.getToken();
      print('FCM Token: $_fcmToken'); // Debug log

      if (_fcmToken != null) {
        await _saveFCMTokenToDatabase(_fcmToken!);
      }

      // Listen for token refresh
      _firebaseMessaging.onTokenRefresh.listen((newToken) {
        print('FCM Token refreshed: $newToken'); // Debug log
        _fcmToken = newToken;
        _saveFCMTokenToDatabase(newToken);
      });
    } catch (e) {
      print('Error getting FCM token: $e'); // Debug log
    }
  }

  // Save FCM token to Supabase database
  Future<void> _saveFCMTokenToDatabase(String token) async {
    try {
      final user = SupabaseConfig.client.auth.currentUser;
      if (user == null) {
        print('No authenticated user to save FCM token'); // Debug log
        return;
      }

      print('Saving FCM token to database for user: ${user.id}'); // Debug log

      // Update or insert FCM token in vendors table
      await SupabaseConfig.client
          .from('vendors')
          .update({
            'fcm_token': token,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('auth_user_id', user.id);

      print('FCM token saved successfully'); // Debug log
    } catch (e) {
      print('Error saving FCM token: $e'); // Debug log
    }
  }

  // Setup message handlers
  void _setupMessageHandlers() {
    // Handle foreground messages
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // Handle background messages
    FirebaseMessaging.onBackgroundMessage(_handleBackgroundMessage);

    // Handle notification taps when app is in background
    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);

    // Handle notification tap when app is terminated
    _firebaseMessaging.getInitialMessage().then((message) {
      if (message != null) {
        _handleNotificationTap(message);
      }
    });
  }

  // Handle foreground messages
  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    print('Received foreground message: ${message.messageId}'); // Debug log
    print('Title: ${message.notification?.title}'); // Debug log
    print('Body: ${message.notification?.body}'); // Debug log
    print('Data: ${message.data}'); // Debug log

    // Show local notification when app is in foreground
    await _showLocalNotification(message);
  }

  // Handle notification tap
  void _handleNotificationTap(RemoteMessage message) {
    print('Notification tapped: ${message.messageId}'); // Debug log
    print('Data: ${message.data}'); // Debug log

    // Handle navigation based on notification data
    _handleNotificationNavigation(message.data);
  }

  // Handle notification navigation
  void _handleNotificationNavigation(Map<String, dynamic> data) {
    try {
      final type = data['type'];
      print('Handling notification navigation for type: $type'); // Debug log

      switch (type) {
        case 'account_verified':
          // Navigate to home screen or show verification success
          print('Account verified notification - navigate to home'); // Debug log
          break;
        case 'account_rejected':
          // Navigate to rejection details or onboarding
          print('Account rejected notification - navigate to details'); // Debug log
          break;
        default:
          print('Unknown notification type: $type'); // Debug log
      }
    } catch (e) {
      print('Error handling notification navigation: $e'); // Debug log
    }
  }

  // Show local notification
  Future<void> _showLocalNotification(RemoteMessage message) async {
    try {
      const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
        'vendor_status_channel',
        'Vendor Status Updates',
        channelDescription: 'Notifications about vendor account status changes',
        importance: Importance.high,
        priority: Priority.high,
        showWhen: true,
        icon: '@mipmap/ic_launcher',
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
        message.hashCode,
        message.notification?.title ?? 'SyloNow Vendor',
        message.notification?.body ?? 'You have a new update',
        notificationDetails,
        payload: message.data.toString(),
      );

      print('Local notification shown'); // Debug log
    } catch (e) {
      print('Error showing local notification: $e'); // Debug log
    }
  }

  // Handle local notification tap
  void _onNotificationTapped(NotificationResponse response) {
    print('Local notification tapped: ${response.payload}'); // Debug log
    
    try {
      if (response.payload != null) {
        // Parse payload and handle navigation
        print('Notification payload: ${response.payload}'); // Debug log
      }
    } catch (e) {
      print('Error handling notification tap: $e'); // Debug log
    }
  }

  // Send test notification (for testing purposes)
  Future<void> sendTestNotification() async {
    try {
      if (_fcmToken == null) {
        print('No FCM token available for test notification'); // Debug log
        return;
      }

      print('Sending test notification to token: $_fcmToken'); // Debug log
      
      // This would typically be done from your backend/admin panel
      // For testing, you can use Firebase Console or a test endpoint
      
    } catch (e) {
      print('Error sending test notification: $e'); // Debug log
    }
  }

  // Clear FCM token (for logout)
  Future<void> clearFCMToken() async {
    try {
      final user = SupabaseConfig.client.auth.currentUser;
      if (user != null) {
        await SupabaseConfig.client
            .from('vendors')
            .update({
              'fcm_token': null,
              'updated_at': DateTime.now().toIso8601String(),
            })
            .eq('auth_user_id', user.id);
      }

      _fcmToken = null;
      print('FCM token cleared'); // Debug log
    } catch (e) {
      print('Error clearing FCM token: $e'); // Debug log
    }
  }
}

// Background message handler (must be top-level function)
@pragma('vm:entry-point')
Future<void> _handleBackgroundMessage(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Background message received: ${message.messageId}'); // Debug log
  print('Title: ${message.notification?.title}'); // Debug log
  print('Body: ${message.notification?.body}'); // Debug log
  print('Data: ${message.data}'); // Debug log
} 