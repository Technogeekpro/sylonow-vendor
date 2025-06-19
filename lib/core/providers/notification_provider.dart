import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../services/notification_service.dart';

part 'notification_provider.g.dart';

@riverpod
class NotificationNotifier extends _$NotificationNotifier {
  late final NotificationService _notificationService;

  @override
  Future<bool> build() async {
    _notificationService = NotificationService();
    
    try {
      print('Initializing notification provider...'); // Debug log
      await _notificationService.initialize();
      print('Notification provider initialized successfully'); // Debug log
      return true;
    } catch (e) {
      print('Error initializing notification provider: $e'); // Debug log
      return false;
    }
  }

  // Send test notification
  Future<void> sendTestNotification() async {
    try {
      await _notificationService.sendTestNotification();
    } catch (e) {
      print('Error sending test notification: $e'); // Debug log
    }
  }
} 