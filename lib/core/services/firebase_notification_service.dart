import 'dart:io';
import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import '../config/supabase_config.dart';
import '../../firebase_options.dart';

// Background message handler - must be top-level function
@pragma('vm:entry-point')
Future<void> _handleBackgroundMessage(RemoteMessage message) async {
  print('🔔 Background message received: ${message.messageId}');
  
  if (message.data['type'] == 'new_order') {
    print('📦 New order received in background: ${message.data['order_id']}');
  }
}

class FirebaseNotificationService {
  static final FirebaseNotificationService _instance = FirebaseNotificationService._internal();
  factory FirebaseNotificationService() => _instance;
  FirebaseNotificationService._internal();

  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();
  late FirebaseMessaging _firebaseMessaging;
  
  bool _isInitialized = false;
  bool _isFirebaseInitialized = false;
  String? _fcmToken;

  bool get isInitialized => _isInitialized;
  String? get fcmToken => _fcmToken;

  /// Initialize Firebase if not already initialized
  Future<void> _ensureFirebaseInitialized() async {
    if (_isFirebaseInitialized) return;
    
    try {
      // Check if Firebase is already initialized
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
      }
      _isFirebaseInitialized = true;
      print('🟢 Firebase initialized successfully in notification service');
    } catch (e) {
      print('🔴 Firebase initialization failed in notification service: $e');
      throw Exception('Firebase initialization failed: $e');
    }
  }

  /// Initialize the notification service
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      print('🔔 Initializing Firebase notification service...');
      
      // Ensure Firebase is initialized first
      await _ensureFirebaseInitialized();
      
      // Request notification permissions
      await _requestNotificationPermissions();
      
      // Initialize local notifications
      await _initializeLocalNotifications();
      
      // Initialize FCM
      await _initializeFCM();
      
      // Message handlers are set up in _initializeFCM method
      
      _isInitialized = true;
      print('🟢 Firebase notification service initialized successfully');
      
    } catch (e) {
      print('🔴 Failed to initialize Firebase notification service: $e');
      rethrow;
    }
  }

  // Request notification permissions
  Future<void> _requestNotificationPermissions() async {
    try {
      // Request system notification permissions (Android 13+)
      if (Platform.isAndroid) {
        final status = await Permission.notification.request();
        print('📱 System notification permission: $status');
      }
      
      // Request FCM permissions for iOS
      if (Platform.isIOS) {
        final settings = await _firebaseMessaging.requestPermission(
          alert: true,
          badge: true,
          sound: true,
        );
        print('📱 iOS FCM permission: ${settings.authorizationStatus}');
      }
    } catch (e) {
      print('🔴 Error requesting permissions: $e');
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

      // Create notification channels for Android
      await _createNotificationChannels();

      print('📱 Local notifications initialized');
    } catch (e) {
      print('🔴 Error initializing local notifications: $e');
    }
  }

  // Create notification channels
  Future<void> _createNotificationChannels() async {
    if (Platform.isAndroid) {
      // New Orders Channel
      const AndroidNotificationChannel newOrdersChannel = AndroidNotificationChannel(
        'new_orders_channel',
        'New Orders',
        description: 'Notifications for new orders',
        importance: Importance.high,
        enableVibration: true,
        playSound: true,
      );

      // Order Updates Channel
      const AndroidNotificationChannel orderUpdatesChannel = AndroidNotificationChannel(
        'order_updates_channel',
        'Order Updates',
        description: 'Notifications for order status updates',
        importance: Importance.high,
        enableVibration: true,
      );

      await _localNotifications
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(newOrdersChannel);

      await _localNotifications
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(orderUpdatesChannel);
    }
  }

  // Initialize FCM
  Future<void> _initializeFCM() async {
    try {
      _firebaseMessaging = FirebaseMessaging.instance;
      
      // Get FCM token
      _fcmToken = await _firebaseMessaging.getToken();
      print('🔑 FCM Token: $_fcmToken');
      
      // Update token in database
      if (_fcmToken != null) {
        await _updateFCMTokenInDatabase(_fcmToken!);
      }
      
      // Listen for token refresh
      _firebaseMessaging.onTokenRefresh.listen((token) {
        _fcmToken = token;
        print('🔄 FCM Token refreshed: $token');
        _updateFCMTokenInDatabase(token);
      });
      
      // Handle foreground messages
      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
      
      // Handle background messages
      FirebaseMessaging.onBackgroundMessage(_handleBackgroundMessage);
      
      // Handle notification tap when app is in background
      FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);
      
      print('🟢 FCM initialized successfully');
    } catch (e) {
      print('🔴 Error initializing FCM: $e');
    }
  }

  // Handle foreground messages
  void _handleForegroundMessage(RemoteMessage message) {
    print('🔔 Foreground message received: ${message.messageId}');
    print('📄 Message data: ${message.data}');
    
    // Show local notification when app is in foreground
    if (message.data['type'] == 'new_booking' || message.data['type'] == 'new_order') {
      showNewBookingNotification(
        bookingId: message.data['booking_id'] ?? message.data['order_id'] ?? '',
        customerName: message.data['customer_name'] ?? 'Customer',
        serviceName: message.data['service_name'] ?? 'Service',
        amount: double.tryParse(message.data['amount'] ?? '0') ?? 0.0,
      );
    } else if (message.data['type'] == 'booking_update' || message.data['type'] == 'order_update') {
      showBookingUpdateNotification(
        bookingId: message.data['booking_id'] ?? message.data['order_id'] ?? '',
        status: message.data['status'] ?? message.data['new_status'] ?? '',
        customerName: message.data['customer_name'] ?? 'Customer',
        serviceName: message.data['service_name'] ?? 'Service',
      );
    }
  }

  // Handle notification tap from FCM
  void _handleNotificationTap(RemoteMessage message) {
    print('🔔 FCM notification tapped: ${message.messageId}');
    _handleNotificationNavigation(message.data['type'], message.data);
  }

  // Handle notification tap from local notifications
  void _onNotificationTapped(NotificationResponse response) {
    print('📱 Local notification tapped: ${response.id}');
    print('📄 Payload: ${response.payload}');
    
    if (response.payload != null) {
      final parts = response.payload!.split(':');
      if (parts.length >= 2) {
        final type = parts[0];
        final id = parts[1];
        // Handle both booking and order types
        if (type.contains('booking')) {
          _handleNotificationNavigation(type, {'booking_id': id});
        } else {
          _handleNotificationNavigation(type, {'order_id': id});
        }
      }
    }
  }

  // Handle notification navigation
  void _handleNotificationNavigation(String? type, Map<String, dynamic> data) {
    if (type == null) return;
    
    try {
      switch (type) {
        case 'new_booking':
        case 'new_order':
          print('🔄 Navigating to orders screen for new booking: ${data['booking_id'] ?? data['order_id']}');
          // TODO: Implement navigation using go_router
          // context.go('/orders', extra: {'highlight': data['booking_id'] ?? data['order_id']});
          break;
        case 'booking_update':
        case 'order_update':
          print('🔄 Navigating to booking details: ${data['booking_id'] ?? data['order_id']}');
          // TODO: Implement navigation using go_router
          // context.go('/orders/${data['booking_id'] ?? data['order_id']}');
          break;
      }
    } catch (e) {
      print('🔴 Error handling notification navigation: $e');
    }
  }

  // Show local notification for new booking
  Future<void> showNewBookingNotification({
    required String bookingId,
    required String customerName,
    required String serviceName,
    required double amount,
  }) async {
    try {
      final AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
        'new_orders_channel',
        'New Orders',
        channelDescription: 'Notifications for new orders',
        importance: Importance.high,
        priority: Priority.high,
        playSound: true,
        enableVibration: true,
        icon: '@mipmap/ic_launcher',
        largeIcon: const DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
        styleInformation: BigTextStyleInformation(
          '$customerName has booked $serviceName for ₹${amount.toStringAsFixed(2)}. Tap to view details.',
          contentTitle: '🎉 New Order Received!',
        ),
        actions: const [
          AndroidNotificationAction(
            'view_order',
            'View Order',
            showsUserInterface: true,
          ),
          AndroidNotificationAction(
            'call_customer',
            'Call Customer',
            showsUserInterface: true,
          ),
        ],
      );

      const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        subtitle: 'New booking received',
        categoryIdentifier: 'new_order_category',
      );

      final NotificationDetails notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _localNotifications.show(
        bookingId.hashCode, // Use booking ID as notification ID
        '🎉 New Booking Received!',
        '$customerName booked $serviceName for ₹${amount.toStringAsFixed(2)}',
        notificationDetails,
        payload: 'new_booking:$bookingId',
      );

      print('🟢 New booking notification shown for booking: $bookingId');
    } catch (e) {
      print('🔴 Error showing new order notification: $e');
    }
  }

  // Show booking status update notification
  Future<void> showBookingUpdateNotification({
    required String bookingId,
    required String status,
    required String customerName,
    required String serviceName,
  }) async {
    try {
      String title = '';
      String body = '';
      
      switch (status.toLowerCase()) {
        case 'confirmed':
          title = '✅ Order Confirmed';
          body = 'Your booking with $customerName for $serviceName has been confirmed';
          break;
        case 'cancelled':
          title = '❌ Order Cancelled';
          body = 'Booking with $customerName for $serviceName has been cancelled';
          break;
        case 'completed':
          title = '🎉 Order Completed';
          body = 'Service completed for $customerName. Please collect payment';
          break;
        case 'in_progress':
          title = '🔄 Service Started';
          body = 'Service for $customerName has started. Good luck!';
          break;
        default:
          title = '📋 Order Update';
          body = 'Status updated to $status for $customerName';
      }

      const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
        'order_updates_channel',
        'Order Updates',
        channelDescription: 'Notifications for order status updates',
        importance: Importance.high,
        priority: Priority.high,
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
        bookingId.hashCode + 1000, // Different ID for updates
        title,
        body,
        notificationDetails,
        payload: 'booking_update:$bookingId',
      );

      print('🟢 Booking update notification shown for booking: $bookingId');
    } catch (e) {
      print('🔴 Error showing order update notification: $e');
    }
  }

  // Update FCM token in database
  Future<void> _updateFCMTokenInDatabase(String token) async {
    try {
      final client = SupabaseConfig.client;
      final user = client.auth.currentUser;
      
      if (user != null) {
        // Update the vendor's FCM token
        await client
            .from('vendors')
            .update({'fcm_token': token})
            .eq('auth_user_id', user.id);
        
        print('🟢 FCM token updated in database');
      }
    } catch (e) {
      print('🔴 Error updating FCM token: $e');
      // If column doesn't exist, we'll handle it gracefully
    }
  }

  // Send test notification
  Future<void> sendTestNotification() async {
    await showNewBookingNotification(
      bookingId: 'test_booking_${DateTime.now().millisecondsSinceEpoch}',
      customerName: 'John Doe',
      serviceName: 'Event Photography',
      amount: 5000.0,
    );
  }

  // Get notification settings
  Future<bool> areNotificationsEnabled() async {
    if (Platform.isAndroid) {
      final status = await Permission.notification.status;
      return status == PermissionStatus.granted;
    }
    return true; // iOS handles this differently
  }

  // Request notification permissions if not granted
  Future<bool> requestNotificationPermissions() async {
    if (Platform.isAndroid) {
      final status = await Permission.notification.request();
      return status == PermissionStatus.granted;
    }
    return true;
  }

  // Clear all notifications
  Future<void> clearAllNotifications() async {
    await _localNotifications.cancelAll();
  }

  // Clear specific notification
  Future<void> clearNotification(String bookingId) async {
    await _localNotifications.cancel(bookingId.hashCode);
    await _localNotifications.cancel(bookingId.hashCode + 1000);
  }


} 