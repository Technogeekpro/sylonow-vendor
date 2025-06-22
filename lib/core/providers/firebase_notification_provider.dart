import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../services/firebase_notification_service.dart';

part 'firebase_notification_provider.g.dart';

@riverpod
class FirebaseNotificationNotifier extends _$FirebaseNotificationNotifier {
  late final FirebaseNotificationService _notificationService;

  @override
  Future<bool> build() async {
    _notificationService = FirebaseNotificationService();
    
    try {
      print('🔔 Initializing Firebase notification provider...');
      await _notificationService.initialize();
      print('🟢 Firebase notification provider initialized successfully');
      return true;
    } catch (e) {
      print('🔴 Error initializing Firebase notification provider: $e');
      return false;
    }
  }

  // Send test notification
  Future<void> sendTestNotification() async {
    try {
      await _notificationService.sendTestNotification();
    } catch (e) {
      print('🔴 Error sending test notification: $e');
    }
  }

  // Get FCM token
  String? get fcmToken => _notificationService.fcmToken;

  // Check if notifications are enabled
  Future<bool> areNotificationsEnabled() async {
    return await _notificationService.areNotificationsEnabled();
  }

  // Request notification permissions
  Future<bool> requestNotificationPermissions() async {
    return await _notificationService.requestNotificationPermissions();
  }

  // Clear all notifications
  Future<void> clearAllNotifications() async {
    await _notificationService.clearAllNotifications();
  }

  // Clear specific notification
  Future<void> clearNotification(String bookingId) async {
    await _notificationService.clearNotification(bookingId);
  }

  // Show new booking notification manually (for testing)
  Future<void> showNewBookingNotification({
    required String bookingId,
    required String customerName,
    required String serviceName,
    required double amount,
  }) async {
    await _notificationService.showNewBookingNotification(
      bookingId: bookingId,
      customerName: customerName,
      serviceName: serviceName,
      amount: amount,
    );
  }

  // Show booking update notification manually (for testing)
  Future<void> showBookingUpdateNotification({
    required String bookingId,
    required String status,
    required String customerName,
    required String serviceName,
  }) async {
    await _notificationService.showBookingUpdateNotification(
      bookingId: bookingId,
      status: status,
      customerName: customerName,
      serviceName: serviceName,
    );
  }
} 